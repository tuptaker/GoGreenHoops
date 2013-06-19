//
//  SportsDataLoader.h
//  GoGreen
//
//  Created by admin mac on 11/9/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SportsDataConstants.h"
#import "Player.h"

@interface SportsDataLoader : NSObject
+ (SportsDataLoader *) sportsDataLoaderWithContext:(NSManagedObjectContext *)ctx;
- (void) loadSportsDataOfType:(DataType)type WithCompletion:(void (^)(NSInteger statusCode, NSError *err))completion;
- (void) loadPlayerImagesForPlayerFirstName:(NSString *)firstName andLastName:(NSString *)lastName andSender:(id)sender WithCompletion:(void (^)(NSInteger statusCode, NSError *err))completion;
- (void) loadShortenedItunesUrlWithCompletion:(void (^)(NSInteger statusCode, NSError *err, NSString *shortUrl))completion;
@end
