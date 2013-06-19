//
//  SportsStatsInterface.m
//  GoGreen
//
//  Created by admin mac on 11/9/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#import "SportsDataLoader.h"
#import "SportsDataConstants.h"
#import "AFHTTPRequestOperation.h"
#import "AFXMLRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "RosterParseOperation.h"
#import "TeamStatsParseOperation.h"
#import "UIImageView+AFNetworking.h"
#import "PlayerInfoViewController.h"
#import "Reachability.h"
#import "PlayerImageView.h"

#define THUMB_HEIGHT 100
#define THUMB_V_PADDING 10
#define THUMB_H_PADDING 10

@interface SportsDataLoader () 

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableArray *resourceListArray;
@property (nonatomic, strong) NSManagedObjectContext *childCtx;
@property (nonatomic, strong) NSMutableArray *arrayOfPlayerImgUrls;

@end

@implementation SportsDataLoader
@synthesize connection;
@synthesize arrayOfPlayerImgUrls;
@synthesize resourceListArray = _resourceListArray;
@synthesize childCtx;

#pragma mark - SportsDataLoader

+ (SportsDataLoader *) sportsDataLoaderWithContext:(NSManagedObjectContext *)ctx {
    static SportsDataLoader *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,  ^ {
        singleton = [[SportsDataLoader alloc] initWithContext:ctx];
    });
    
    return singleton;
}

- (id) initWithContext:(NSManagedObjectContext *)ctx {
    self = [super init];
    self.childCtx = ctx;
    return self;
}

- (NSMutableArray *) resourceListArray {
    if (!_resourceListArray) _resourceListArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:RosterData], [NSNumber numberWithInt:TeamStatsData], nil];
    return _resourceListArray;
}

- (void) setResourceListArray:(NSMutableArray *)resourceListArray {
    if (_resourceListArray != resourceListArray) _resourceListArray = resourceListArray;
}

- (void) loadSportsDataOfType:(DataType)dataType WithCompletion:(void (^)(NSInteger statusCode,NSError *err))completion {
    
    NSMutableURLRequest *req = nil;
    NSOperation *parseOp = nil;
    
    switch (dataType) {
        case RosterData:
            req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kNBARosterUrl]];
            parseOp = [RosterParseOperation alloc];
            break;
        case TeamStatsData:
            req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kNBATeam2012SeasonStatsToDateUrl]];
            parseOp = [TeamStatsParseOperation alloc];
            break;
        default:
            break;
    }

    [req setHTTPMethod:@"GET"];
    [self loadSportsDataWithRequest:req andParseOp:parseOp WithCompletion:completion];
}

- (void) loadSportsDataWithRequest:(NSURLRequest *)req andParseOp:(NSOperation *)parseOp WithCompletion:(void (^)(NSInteger statusCode, NSError *err))completion {

    AFXMLRequestOperation *dataLoadOp = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        DLog(@"Success");
        if (completion) {
            completion(response.statusCode, nil);
            
            if ([parseOp isKindOfClass:[RosterParseOperation class]]) {
                RosterParseOperation *rosterParseOp = (RosterParseOperation *)parseOp;
                (void)[rosterParseOp initWithParser:XMLParser andContext:childCtx];
            }
            if ([parseOp isKindOfClass:[TeamStatsParseOperation class]]) {
                TeamStatsParseOperation *teamStatsParseOp = (TeamStatsParseOperation *)parseOp;
                (void)[teamStatsParseOp initWithParser:XMLParser andContext:childCtx];
            }
            [parseOp start];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
        DLog(@"Failure");
        if (completion)
            completion(response.statusCode, error);
    }];
    
    [dataLoadOp setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSString *resourceTypeStr = nil;
        if ([kNBARosterUrl isEqualToString:[req.URL absoluteString]]) {
            resourceTypeStr = @"roster";
        }
        if ([kNBATeam2012SeasonStatsToDateUrl isEqualToString:[req.URL absoluteString]]) {
            resourceTypeStr = @"statistics";
        }
        NSDictionary *progressDetails = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", bytesRead], @"bytes_read", [NSString stringWithFormat:@"%lld", totalBytesRead], @"total_bytes_read", [NSString stringWithFormat:@"%lld", totalBytesExpectedToRead], @"total_bytes_expected", resourceTypeStr, @"resource_type", nil];
        NSNotificationQueue *defaultQ = [NSNotificationQueue defaultQueue];
        NSNotification *readBytesNotification = [NSNotification notificationWithName:kNotificationReadBytes object:self userInfo:progressDetails];
        [defaultQ enqueueNotification:readBytesNotification postingStyle:NSPostWhenIdle];
        DLog(@"Read %lld of %lld bytes", totalBytesRead, totalBytesExpectedToRead);
    }];
    
    [dataLoadOp start];
}

- (void) loadPlayerImagesForPlayerFirstName:(NSString *)firstName andLastName:(NSString *)lastName andSender:(id)sender WithCompletion:(void (^)(NSInteger, NSError *))completion {
    
    
    NSString *googleImgSearchUrlWithArgs = [kPlayerImageSearchBaseUrl stringByAppendingFormat:@"cx=%@&q=%@+%@&searchType=image", kGoogleCustomSearchEngineId, firstName, lastName];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:googleImgSearchUrlWithArgs]];
    
    AFJSONRequestOperation *jsonReqOp = [AFJSONRequestOperation JSONRequestOperationWithRequest:(NSURLRequest *)req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *searchResItems = [JSON objectForKey:@"items"];
        
        for (NSDictionary *item in searchResItems) {
            NSString *imgUrlStr = [item valueForKey:@"link"];
            NSURL *imgUrl = [NSURL URLWithString:imgUrlStr];
            NSURLRequest *imgReq = [NSURLRequest requestWithURL:imgUrl];
            PlayerImageView *currentPlayerImage = [[PlayerImageView alloc] init];
            //currentPlayerImage
            //UIImageView *currentPlayerImage = [[UIImageView alloc] init];
            PlayerInfoViewController *playerInfoVC = nil;

            if ([sender isKindOfClass:[PlayerInfoViewController class]]) {
                playerInfoVC = (PlayerInfoViewController *)sender;
                [currentPlayerImage setDelegate:playerInfoVC];
                [currentPlayerImage setUserInteractionEnabled:YES];
                [currentPlayerImage setExclusiveTouch:YES];  // block other touches while dragging a thumb view
            }
            
            __weak UIImageView *playerImgView = currentPlayerImage; 
            
            [currentPlayerImage setImageWithURLRequest:imgReq placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                [playerImgView setImage:image];
                playerInfoVC.currentPlayerImageToAdd = playerImgView;
                [playerInfoVC refreshCurrentPlayerImage];
                DLog(@"Successfully loaded player image at %@", response.URL);
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                DLog(@"Failed to load player image at %@", response.URL);
            }];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        DLog(@"Failed to load player images query");
    }];
    
    [jsonReqOp start];
}

- (void) loadShortenedItunesUrlWithCompletion:(void (^)(NSInteger, NSError *, NSString *))completion {
    NSString *bitlyReqUrlStr = [NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?login=%@&apikey=%@&longUrl=%@&format=txt", kBitlyUsernameStr, kBitlyApiKeyStr, kGoGreenITunesURL];
    NSURL *bitlyReqUrl = [NSURL URLWithString:[bitlyReqUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *bitlyReq = [NSURLRequest requestWithURL:bitlyReqUrl];
    AFHTTPRequestOperation *bitlyReqOp = [[AFHTTPRequestOperation alloc] initWithRequest:bitlyReq];
    [bitlyReqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(operation.response.statusCode, nil, operation.responseString);
        }
        DLog(@"success: %@", operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(operation.response.statusCode, error, nil);
        }
        DLog(@"failure: %@", operation.responseString);
    }];
    
    [bitlyReqOp start];
}

@end