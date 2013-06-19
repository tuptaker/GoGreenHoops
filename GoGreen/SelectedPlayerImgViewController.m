//
//  SelectedPlayerImgViewController.m
//  GoGreen
//
//  Created by admin mac on 3/12/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import "SelectedPlayerImgViewController.h"
#import "ImageSizingUtil.h"
#import "SportsDataConstants.h"
#import <Social/Social.h>

@interface SelectedPlayerImgViewController ()

@end

@implementation SelectedPlayerImgViewController
@synthesize selectedPlayerImgView;
@synthesize playerName;
// NOTE: facebook blocks bitly-shortened links--do not use on facebook
@synthesize shortenedAppStoreLink;
@synthesize childCtx;

- (IBAction) postThis:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebookComposerVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];

        NSString *facebookMsg = [NSString stringWithFormat:@"found this cool image of %@ using GoGreen.\nStats provided by Go Green for iPhone and iPad\nThe ultimate stats app for Boston hoops fans\nAvailable in the App Store\nDownload Go Green from iTunes here: %@", self.playerName, kGoGreenITunesURL];
        [facebookComposerVC setInitialText:facebookMsg];
        [facebookComposerVC addImage:selectedPlayerImgView.image];
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

- (IBAction) tweetThis:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterComposerVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *nameHashTagStr = [[NSString stringWithFormat:@"#%@", [self.playerName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]] lowercaseString];
        NSString *goGreenHashTagStr = @"#gogreen";
        NSString *tweetMsg =  [NSString stringWithFormat:@"found this image of %@ with Go Green %@ %@ %@", self.playerName, self.shortenedAppStoreLink, goGreenHashTagStr, nameHashTagStr];
        [twitterComposerVC setInitialText:tweetMsg];
        [twitterComposerVC addImage:self.selectedPlayerImgView.image];
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect vcRect = [[self view] frame];
    float maxHeight = vcRect.size.height - 10;
    float maxWidth  = vcRect.size.width - 10;
    CGRect imgRect = [ImageSizingUtil calculateRectForImage:self.selectedPlayerImgView withMaxHeight:maxHeight andWithMaxWidth:maxWidth];
    
    imgRect.origin.x = (vcRect.size.width - imgRect.size.width) / 2;
    imgRect.origin.y = 10;
    [self.selectedPlayerImgView setFrame:imgRect];
    [self.selectedPlayerImgView setContentMode:UIViewContentModeScaleAspectFit];
    [[self view] addSubview:self.selectedPlayerImgView];
    [[self view] bringSubviewToFront:self.selectedPlayerImgView];
    
    UIBarButtonItem *facebookBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Facebook" style:UIBarButtonItemStyleBordered target:self action:@selector(postThis:)];
    
    UIBarButtonItem *twitterBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Twitter" style:UIBarButtonItemStyleBordered target:self action:@selector(tweetThis:)];
    
    self.navigationItem.rightBarButtonItems = @[twitterBarButtonItem, facebookBarButtonItem];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
