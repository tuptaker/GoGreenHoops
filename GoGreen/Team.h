//
//  Team.h
//  GoGreen
//
//  Created by admin mac on 1/30/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Player, TeamStatistics;

@interface Team : NSManagedObject

@property (nonatomic, retain) NSString * headCoach;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * season;
@property (nonatomic, retain) NSString * teamUid;
@property (nonatomic, retain) NSSet *players;
@property (nonatomic, retain) TeamStatistics *teamStatistics;
@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addPlayersObject:(Player *)value;
- (void)removePlayersObject:(Player *)value;
- (void)addPlayers:(NSSet *)values;
- (void)removePlayers:(NSSet *)values;

@end
