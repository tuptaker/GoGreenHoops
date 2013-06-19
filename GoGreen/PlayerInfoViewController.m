//
//  PlayerInfoViewController.m
//  GoGreen
//
//  Created by admin mac on 1/28/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import "PlayerInfoViewController.h"
#import "PlayerStatsCell.h"
#import "TeamHeader.h"
#import "PlayerInfo.h"
#import "PlayerStatistics.h"
#import "PlayerInfoCarousel.h"
#import "PlayerInfoThumbScrollView.h"
#import "SportsDataLoader.h"
#import "SelectedPlayerImgViewController.h"
#import "ImageSizingUtil.h"
#import <Social/Social.h>

#define PLAYERINFO_INTERITEM_SPACING ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 10.0 : 2.0)
#define PLAYERINFO_HS_LINE_SPACING ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 35.0 : 15.0)
#define PLAYERINFO_HS_TOP_INSET ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 10.0 : 5.0)
#define PLAYERINFO_HS_LEFT_INSET ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 225.0 : 5.0)
#define PLAYERINFO_HS_BOTTOM_INSET ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 10.0 : 5.0)
#define PLAYERINFO_HS_RIGHT_INSET ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 225.0 : 5.0)

#define PLAYERINFO_THUMB_H_PADDING 10
#define PLAYERINFO_THUMB_V_PADDING 10
#define PLAYERINFO_THUMB_HEIGHT 155
#define PLAYERINFO_THUMB_WIDTH 155

@interface PlayerInfoViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PlayerImageViewDelegate>
@property (nonatomic, strong) PlayerInfoCarousel *carousel;
@property (nonatomic) float currThumbXPos;
@property (nonatomic, strong) UIImageView *selectedImg;
@property (nonatomic, strong) NSString *shortenedAppStoreLink;
@end

@implementation PlayerInfoViewController

@synthesize player;
@synthesize currentPlayerImageToAdd;
@synthesize carousel;
@synthesize currThumbXPos;
@synthesize selectedImg;
@synthesize shortenedAppStoreLink;
@synthesize childCtx;

- (IBAction)postThis:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {

        SLComposeViewController *facebookComposerVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];

        PlayerStatistics *stats = [self.player playerStatistics];
        NSString *facebookMsg = [NSString stringWithFormat:@"is checking out statistics for %@ %@\n%.1f PPG, %.1f APG, %.1f RPG\n%.1f SPG, %.1f BPG\nStats provided by Go Green for iPhone and iPad\nThe ultimate stats app for Boston hoops fans\nAvailable in the App Store\nDownload Go Green from iTunes here: %@", player.firstName, player.lastName, (float)stats.points / (float)stats.gamesPlayed, (float)stats.assists / (float)stats.gamesPlayed, ((float)stats.offensiveRebounds + (float)stats.defensiveRebounds) / (float)stats.gamesPlayed, (float)stats.steals / (float)stats.gamesPlayed, (float)stats.blockedShots / (float)stats.gamesPlayed, kGoGreenITunesURL];

        [facebookComposerVC setInitialText:facebookMsg];
        [self presentViewController:facebookComposerVC animated:YES completion:^{
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Facebook Account"
                                                        message:@"Please configure your Facebook account under device settings."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)tweetThis:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterComposerVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        PlayerStatistics *stats = [self.player playerStatistics];
        NSString *nameHashTagStr = [[NSString stringWithFormat:@"#%@%@", self.player.firstName, self.player.lastName] lowercaseString];
        NSString *goGreenHashTagStr = @"#gogreen";
        NSString *tweetMsg = [NSString stringWithFormat:@"Stats for %@ %@ %@ %.1f PPG, %.1f APG, %.1f RPG %.1f SPG, %.1f BPG Stats by Go Green %@ %@", player.firstName, player.lastName, nameHashTagStr, (float)stats.points / (float)stats.gamesPlayed, (float)stats.assists / (float)stats.gamesPlayed, ((float)stats.offensiveRebounds + (float)stats.defensiveRebounds) / (float)stats.gamesPlayed, (float)stats.steals / (float)stats.gamesPlayed, (float)stats.blockedShots / (float)stats.gamesPlayed, self.shortenedAppStoreLink, goGreenHashTagStr];
        [twitterComposerVC setInitialText:tweetMsg];
        [self presentViewController:twitterComposerVC animated:YES completion:^{
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Account"
                                                        message:@"Please configure your Twitter account under device settings."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void) refreshCurrentPlayerImage {
    
    CGRect carouselRect = [self.carousel.playerThumbScrollView frame];
    float carouselHeight = carouselRect.size.height;

    CGRect currPlayerImgFrame = [ImageSizingUtil calculateRectForImage:self.currentPlayerImageToAdd withMaxHeight:PLAYERINFO_THUMB_HEIGHT andWithMaxWidth:PLAYERINFO_THUMB_WIDTH];
    //CGRect currPlayerImgFrame2 = [self calculateRectForImage:self.currentPlayerImageToAdd withMaxHeight:PLAYERINFO_THUMB_HEIGHT andWithMaxWidth:PLAYERINFO_THUMB_HEIGHT];
    
    // if this is the first, leftmost image being inserted into
    // the carousel, pad the image's left side
    if (![[self.carousel.playerThumbScrollView subviews] count]) {
        currPlayerImgFrame.origin.x = PLAYERINFO_THUMB_H_PADDING;
    } else {
        currPlayerImgFrame.origin.x = currThumbXPos + PLAYERINFO_THUMB_H_PADDING;
    }
    
    // center the images vertically in the scroll view with equal padding on top and bottom
    float currImgVerticalPadding = (carouselHeight - currPlayerImgFrame.size.height) / 2;
    
    currPlayerImgFrame.origin.y = currImgVerticalPadding; 
    [self.currentPlayerImageToAdd setFrame:currPlayerImgFrame];
    self.currentPlayerImageToAdd.contentMode = UIViewContentModeScaleAspectFit;
    [self.carousel.playerThumbScrollView addSubview:self.currentPlayerImageToAdd];
    self.currThumbXPos += currPlayerImgFrame.size.width + PLAYERINFO_THUMB_H_PADDING;
    [self.carousel.playerThumbScrollView setContentSize:CGSizeMake(currThumbXPos + PLAYERINFO_THUMB_H_PADDING, carouselHeight)];
}

#pragma mark UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"PlayerInfoThumbScrollView" owner:self options:nil];

    

    // NOTE: facebook will block bitly-shortened URLs, use kGoGreenITunesURL instead when sharing on facebook.
    self.shortenedAppStoreLink = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?login=%@&apikey=%@&longUrl=%@&format=txt", kBitlyUsernameStr, kBitlyApiKeyStr, kGoGreenITunesURL]] encoding:NSUTF8StringEncoding error:nil];
    [[self navigationItem] setTitle:[self.player.firstName stringByAppendingFormat:@" %@", self.player.lastName]];
    PlayerInfoThumbScrollView *thumbScrollView = nil;
    for (id object in bundle) {
        if ([object isKindOfClass:[PlayerInfoThumbScrollView class]])
            thumbScrollView = (PlayerInfoThumbScrollView *)object;
    }
    assert(thumbScrollView != nil && "thumbScrollView can't be nil");
    
    UIBarButtonItem *facebookBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Facebook" style:UIBarButtonItemStyleBordered target:self action:@selector(postThis:)];
    
    UIBarButtonItem *twitterBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Twitter" style:UIBarButtonItemStyleBordered target:self action:@selector(tweetThis:)];
    
    self.navigationItem.rightBarButtonItems = @[twitterBarButtonItem, facebookBarButtonItem];

    UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
    CGSize playerStatCellSize;
    playerStatCellSize.height = 455;
    playerStatCellSize.width = 310;

    flowLayout.itemSize = playerStatCellSize;
    flowLayout.headerReferenceSize = CGSizeMake(310, 217);
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PlayerInfoCarousel" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PlayerInfoCarousel"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PlayerStatsCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"PlayerStatsCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UICollectionViewDelegate

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return PLAYERINFO_HS_LINE_SPACING;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return PLAYERINFO_INTERITEM_SPACING;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(PLAYERINFO_HS_TOP_INSET, PLAYERINFO_HS_LEFT_INSET, PLAYERINFO_HS_BOTTOM_INSET, PLAYERINFO_HS_RIGHT_INSET);
}

#pragma mark UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    PlayerInfoCarousel *infoCarousel = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PlayerInfoCarousel" forIndexPath:indexPath];
    
    self.currThumbXPos = 0;

    [infoCarousel.playerThumbScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    SportsDataLoader *loader = [SportsDataLoader sportsDataLoaderWithContext:self.childCtx];
    self.carousel = infoCarousel;
    [loader loadPlayerImagesForPlayerFirstName:player.firstName andLastName:player.lastName andSender:self WithCompletion:^(NSInteger statusCode, NSError *err) {
        DLog(@"Successfully loaded player images");
    }];
    [loader loadShortenedItunesUrlWithCompletion:^(NSInteger statusCode, NSError *err, NSString *shortUrl) {
        if (err == nil) {
            self.shortenedAppStoreLink = shortUrl;
        } else {
            DLog(@"Failed to shorten URL");
        }
    }];

    return infoCarousel;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayerStatsCell* playerStatsCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PlayerStatsCell" forIndexPath:indexPath];

    PlayerStatistics *playerStats = self.player.playerStatistics;
    playerStatsCell.gamesPlayedLabel.text = [NSString stringWithFormat:@"%d", playerStats.gamesPlayed];
    playerStatsCell.gamesStartedLabel.text = [NSString stringWithFormat:@"%d", playerStats.gamesStarted];
    playerStatsCell.plusMinusLabel.text = [NSString stringWithFormat:@"%d", playerStats.plusOrMinus];
    playerStatsCell.minutesLabel.text = playerStats.minutes;
    playerStatsCell.ppgLabel.text = [NSString stringWithFormat:@"%.1f", (float)playerStats.points / (float)playerStats.gamesPlayed];
    playerStatsCell.assistsLabel.text = [NSString stringWithFormat:@"%.1f", (float)playerStats.assists / (float)playerStats.gamesPlayed];
    playerStatsCell.rpgLabel.text = [NSString stringWithFormat:@"%.1f", (float)((float)playerStats.offensiveRebounds + (float)playerStats.defensiveRebounds) / (float)playerStats.gamesPlayed];
    playerStatsCell.spgLabel.text = [NSString stringWithFormat:@"%.1f", playerStats.steals / (float)playerStats.gamesPlayed];
    playerStatsCell.bpgLabel.text = [NSString stringWithFormat:@"%.1f", (float)playerStats.blockedShots / (float)playerStats.gamesPlayed];
    playerStatsCell.apgLabel.text = [NSString stringWithFormat:@"%.1f", (float)playerStats.assists / (float)playerStats.gamesPlayed];
    playerStatsCell.threeptpctLabel.text = [NSString stringWithFormat:@"%.1f", 100 * (float)playerStats.threePointersMade / (float)playerStats.threePointersAttempted];
    playerStatsCell.fgpctLabel.text = [NSString stringWithFormat:@"%.1f", 100 * (float)playerStats.fieldGoalsMade / (float)playerStats.fieldGoalsAttempted];
    playerStatsCell.ftpctLabel.text = [NSString stringWithFormat:@"%.1f", 100 * (float)playerStats.freeThrowsMade / (float)playerStats.freeThrowsAttempted];
    playerStatsCell.ptsLabel.text = [NSString stringWithFormat:@"%d", playerStats.points];
    playerStatsCell.assistsLabel.text = [NSString stringWithFormat:@"%d", playerStats.assists];
    playerStatsCell.rebLabel.text = [NSString stringWithFormat:@"%d", playerStats.offensiveRebounds + playerStats.defensiveRebounds];
    playerStatsCell.stealsLabel.text = [NSString stringWithFormat:@"%d", playerStats.steals];
    playerStatsCell.blocksLabel.text = [NSString stringWithFormat:@"%d", playerStats.blockedShots];
    playerStatsCell.fgmLabel.text = [NSString stringWithFormat:@"%d", playerStats.fieldGoalsMade];
    playerStatsCell.ftmLabel.text = [NSString stringWithFormat:@"%d", playerStats.freeThrowsMade];
    playerStatsCell.threeptmLabel.text = [NSString stringWithFormat:@"%d", playerStats.threePointersMade];
    
    return playerStatsCell;
}

#pragma mark PlayerImageViewDelegate
- (void) playerImageViewTapped:(PlayerImageView *)playerImgView {
    self.selectedImg = playerImgView;
    [self performSegueWithIdentifier:@"ShowSelectedPlayerImage" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SelectedPlayerImgViewController *selectedImgVC = (SelectedPlayerImgViewController *)segue.destinationViewController;
    selectedImgVC.selectedPlayerImgView = [[UIImageView alloc] initWithImage:[self.selectedImg image]];
    selectedImgVC.playerName =  [self.player.firstName stringByAppendingFormat:@" %@", self.player.lastName];
    selectedImgVC.childCtx = self.childCtx;
    selectedImgVC.shortenedAppStoreLink = self.shortenedAppStoreLink;
}



@end
