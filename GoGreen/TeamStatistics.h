//
//  TeamStatistics.h
//  GoGreen
//
//  Created by admin mac on 11/21/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Statistics.h"

@class Team;

@interface TeamStatistics : Statistics

@property (nonatomic) int16_t freeThrowsAllowed;
@property (nonatomic) int16_t pointsAllowed;
@property (nonatomic) int16_t turnoversForced;
@property (nonatomic, retain) Team *newRelationship;

@end
