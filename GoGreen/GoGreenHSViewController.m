//
//  GoGreenHSViewController.m
//  GoGreen
//
//  Created by admin mac on 1/24/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import "GoGreenHSViewController.h"
#import "PlayerCell.h"
#import "TeamHeader.h"
#import "SportsDataLoader.h"
#import "Player.h"
#import "PlayerInfoViewController.h"
#import "Team.h"
#import "Reachability.h"
#import "DownloadProgressBar.h"
#import <CoreData/CoreData.h>

#define HS_INTERITEM_SPACING ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 10.0 : 2.0)

#define HS_LINE_SPACING ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 35.0 : 15.0)

#define HS_TOP_INSET ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 10.0 : 10.0)

#define HS_LEFT_INSET ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 225.0 : 10.0)

#define HS_BOTTOM_INSET ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 10.0 : 10.0)

#define HS_RIGHT_INSET ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 225.0 : 10.0)

@interface GoGreenHSViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) SportsDataLoader *sportsDataLoader;
@property (nonatomic, strong) UIManagedDocument *teamDatabase;
@property (nonatomic, strong) NSManagedObjectContext *parentCtx;
@property (nonatomic, strong) NSManagedObjectContext *childCtx;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *psc;
@property (nonatomic) BOOL dataIsReady;
@property (nonatomic, strong) Player *selectedPlayer;
@property (nonatomic, strong) DownloadProgressBar *progressUI;
@property (nonatomic, strong) UIView *dimmedBG;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadButton;
@end

@implementation GoGreenHSViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize sportsDataLoader = _sportsDataLoader;
@synthesize teamDatabase;
@synthesize parentCtx;
@synthesize childCtx;
@synthesize dataIsReady;
@synthesize selectedPlayer;
@synthesize progressUI;
@synthesize dimmedBG;
@synthesize reloadButton;

#pragma mark GoGreenHSViewController

- (NSFetchedResultsController *) fetchedResultsController {
    
    if (!dataIsReady) {
        return nil;
    }
    
    if (_fetchedResultsController != nil && dataIsReady) {
        return _fetchedResultsController;
    }
    
    if (parentCtx) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:parentCtx];
        fetchRequest.entity =entity;
        NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDesc];
        
        [NSFetchedResultsController deleteCacheWithName:@"MasterTeamList"];
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:parentCtx sectionNameKeyPath:nil cacheName:@"MasterTeamList"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
        [parentCtx performBlockAndWait:^() {
            NSError *error = nil;
            if (![self.fetchedResultsController performFetch:&error]) {
                DLog(@"Error %@, %@", error, [error userInfo]);
            }
        }];
    }
    return _fetchedResultsController;
}

- (void) dataReady {
    dataIsReady = YES;
    (void)[self fetchedResultsController];
    NSError *err = nil;
    [self.parentCtx save:&err];
    [self.childCtx save:&err];
    [self.progressUI removeFromSuperview];
    [self.dimmedBG removeFromSuperview];
    [self.reloadButton setEnabled:YES];
    [self.collectionView reloadData];
}

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)setupCoreDataStack
{
    // setup managed object model
    NSString *path = [[NSBundle mainBundle] pathForResource:kDataModelName ofType:@"momd"];
    NSURL *modelUrl = [NSURL fileURLWithPath:path];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    
    // setup persistent store coordinator
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"GoGreen.sqlite"]];
    
    NSError *error = nil;
    self.psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    if (![self.psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error])
    {
        // handle error
    }
    
    self.parentCtx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType ];
    [self.parentCtx setPersistentStoreCoordinator:self.psc];
    
    self.childCtx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.childCtx.parentContext = self.parentCtx;
}

- (BOOL) dataNeedsToBeUpdated {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *err = nil;
    float timeElapsedInHrs = 0.0f;
    BOOL dataTooOld = NO;
    if ([fileMgr fileExistsAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"GoGreen.sqlite"]]) {
        NSDictionary *dbAttributesDictionary = [fileMgr attributesOfItemAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"GoGreen.sqlite"] error:&err];
        NSDate *dbCreationDate = [dbAttributesDictionary valueForKey:NSFileCreationDate];
        NSDate *dateRightNow = [NSDate date];
        NSTimeInterval timeElapsed = [dateRightNow timeIntervalSinceDate:dbCreationDate];
        timeElapsedInHrs = (timeElapsed / 60) / 60;
        if (timeElapsedInHrs > 0.25)
            dataTooOld = YES;
    } else {
        dataTooOld = YES;
    }
    return dataTooOld;
}

- (Player *) getPlayerForIndexPath:(NSIndexPath *)indexPath {
    Team *team = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
    NSSet *players = team.players;
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
    NSArray *playersArray = [players sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
    Player *player = [playersArray objectAtIndex:indexPath.row];
    return player;
}

-(BOOL) reachable {
    Reachability *r = [Reachability reachabilityWithHostName:@"api.sportsdatallc.org"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

- (IBAction)reloadFromWebService:(id)sender {
    [self.reloadButton setEnabled:NO];
    [self loadAppDataFromNetworkAndDB];
}

- (void) updateProgressBarWithNotification:(NSNotification *)notification {
    NSDictionary *progressDetails = [notification userInfo];
    long long downloadedSoFar = [[progressDetails valueForKey:@"total_bytes_read"] integerValue];
    long long expectedSize = [[progressDetails valueForKey:@"total_bytes_expected"] integerValue];
    self.progressUI.progressBar.progress = downloadedSoFar / expectedSize;
    self.progressUI.statusLabel.text = [NSString stringWithFormat:@"loading %@", [progressDetails valueForKey:@"resource_type"]];
    if (self.progressUI.hidden) {
        self.progressUI.hidden = NO;
    }
    if (self.dimmedBG.hidden) {
        self.dimmedBG.hidden = NO;
    }
}

- (void) loadAppDataFromNetworkAndDB {
    if (self.reachable) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReady) name:kNotificationDataReadyToDisplay object:nil];
        
        // Do not load data if exisiting db is less than 24 hours old
        if ([self dataNeedsToBeUpdated]) {
            
            [self setupCoreDataStack];
            SportsDataLoader *loader = [SportsDataLoader sportsDataLoaderWithContext:self.childCtx];
            self.progressUI.hidden = YES;
            CGRect bounds = self.view.bounds;
            self.progressUI.center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2);
            self.dimmedBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
            self.dimmedBG.hidden = YES;
            self.dimmedBG.backgroundColor = [UIColor blackColor];
            self.dimmedBG.alpha = 0.5f;
            [self.view addSubview:self.dimmedBG];
            [self.view addSubview:self.progressUI];
            
            [loader loadSportsDataOfType:RosterData WithCompletion:^(NSInteger statusCode, NSError *err) {
                
                if (err == nil ) {
                    DLog(@"Roster Data Load Success");
                } else {
                    DLog(@"Roster Data Load Failure");
                    [self.progressUI removeFromSuperview];
                    [self.dimmedBG removeFromSuperview];
                }
            }];
        }
        else {
            [self setupCoreDataStack];
            [self dataReady];
        }
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Unavailable" message:@"Go Green cannot load data without network connection. Please confirm data connection is available in device settings. When connection is restored, press Refresh button in the top right." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"DownloadProgressBar" owner:self options:nil];
    
    for (id object in bundle) {
        if ([object isKindOfClass:[DownloadProgressBar class]])
            self.progressUI = (DownloadProgressBar *)object;
    }
    assert(self.progressUI != nil && "progressBar can't be nil");

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgressBarWithNotification:) name:kNotificationReadBytes object:nil];
    // tint the nav bar with the same color used in the main views
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.000 green:0.380 blue:0.149 alpha:1.000];
    self.selectedPlayer = nil;
    self.dataIsReady = NO;
    [self loadAppDataFromNetworkAndDB];
    UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
    CGSize playerCellSize;
    playerCellSize.height = 82;
    playerCellSize.width = 82;
    flowLayout.itemSize = playerCellSize;
    flowLayout.headerReferenceSize = CGSizeMake(275, 95);
    [self.collectionView registerNib:[UINib nibWithNibName:@"PlayerCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"PlayerCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TeamHeader" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TeamHeader"];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PlayerInfoViewController *playerInfoVC = (PlayerInfoViewController *)segue.destinationViewController;
    playerInfoVC.childCtx = self.childCtx;
    playerInfoVC.player = self.selectedPlayer;
}

#pragma mark UICollectionViewDelegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.fetchedResultsController) {
        self.selectedPlayer = [self getPlayerForIndexPath:indexPath];
        [self performSegueWithIdentifier:@"ShowPlayerInfo" sender:self];
    }
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return HS_INTERITEM_SPACING;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return HS_LINE_SPACING;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(HS_TOP_INSET, HS_LEFT_INSET, HS_BOTTOM_INSET, HS_RIGHT_INSET);
}

#pragma mark UICollectionViewDataSource

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    TeamHeader *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TeamHeader" forIndexPath:indexPath];
    if (self.fetchedResultsController) {
        Team *team = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
        header.seasonIdLabel.text = [NSString stringWithFormat:@"%@ Roster", team.season];
        header.teamNameLabel.text = team.name;
    }
    return header;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger numSections = 1;
    if (self.fetchedResultsController) {
        numSections = [[self.fetchedResultsController fetchedObjects] count];
    }
    return numSections;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numItems = 15;
    if (self.fetchedResultsController) {
        Team *team = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
        numItems = [team.players count];
    }
    return numItems;
}


- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayerCell* playerCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PlayerCell"
                                                                           forIndexPath:indexPath];
    if (self.fetchedResultsController) {
        Player *player = [self getPlayerForIndexPath:indexPath];
        playerCell.firstNameLabel.text = player.firstName;
        playerCell.lastNameLabel.text = player.lastName;
        playerCell.playerNumberLabel.text = [NSString stringWithFormat:@"#%@", player.jerseyNumber];
    }
    return playerCell;
}

#pragma mark UICollectionViewDelegateFlowLayout

@end
