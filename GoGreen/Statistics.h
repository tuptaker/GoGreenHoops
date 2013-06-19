//
//  Statistics.h
//  GoGreen
//
//  Created by admin mac on 11/21/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Statistics : NSManagedObject

@property (nonatomic) int16_t threePointersMade;
@property (nonatomic) int16_t threePointersAttempted;
@property (nonatomic) int16_t fieldGoalsMade;
@property (nonatomic) int16_t fieldGoalsAttempted;
@property (nonatomic) int16_t freeThrowsMade;
@property (nonatomic) int16_t freeThrowsAttempted;
@property (nonatomic) int16_t points;
@property (nonatomic) int16_t assists;
@property (nonatomic) int16_t offensiveRebounds;
@property (nonatomic) int16_t defensiveRebounds;
@property (nonatomic) int16_t steals;
@property (nonatomic) int16_t turnovers;
@property (nonatomic) int16_t blockedShots;
@property (nonatomic) int16_t blockedAgainst;

@end
