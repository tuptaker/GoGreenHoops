//
//  PlayerStatistics.h
//  GoGreen
//
//  Created by admin mac on 11/21/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Statistics.h"

@class Player;

@interface PlayerStatistics : Statistics

@property (nonatomic) int16_t plusOrMinus;
@property (nonatomic) int16_t gamesPlayed;
@property (nonatomic) int16_t gamesStarted;
@property (nonatomic, retain) NSString * minutes;
@property (nonatomic, retain) Player *newRelationship;

@end
