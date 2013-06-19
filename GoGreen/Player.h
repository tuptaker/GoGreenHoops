//
//  Player.h
//  GoGreen
//
//  Created by admin mac on 12/29/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlayerStatistics, Team;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSString * college;
@property (nonatomic, retain) NSDate * dateOfBirth;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * firstYear;
@property (nonatomic, retain) NSNumber * heightInInches;
@property (nonatomic, retain) NSNumber * jerseyNumber;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * playerUid;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSNumber * weightInPounds;
@property (nonatomic, retain) PlayerStatistics *playerStatistics;
@property (nonatomic, retain) Team *team;

@end
