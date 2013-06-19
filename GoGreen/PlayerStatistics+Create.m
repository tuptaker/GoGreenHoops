//
//  PlayerStatistics+Create.m
//  GoGreen
//
//  Created by admin mac on 1/19/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import "PlayerStatistics+Create.h"
#import "Player.h"

@implementation PlayerStatistics (Create)

+ (PlayerStatistics *) statsForPlayer:(Player *)player withManagedObjectContext:(NSManagedObjectContext *)ctx {
    PlayerStatistics *playerStats = nil;
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"PlayerStatistics"];
    req.predicate = [NSPredicate predicateWithFormat:@"newRelationship = %@", player];
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"newRelationship" ascending:YES];
    req.sortDescriptors = [NSArray arrayWithObject:sortDesc];
    NSError *err = nil;
    NSArray *playerStatsArray = [ctx executeFetchRequest:req error:&err];
    
    if (!playerStatsArray || ([playerStatsArray count] > 1)) {
        // handle error
    } else if (![playerStatsArray count]) {
        playerStats = [NSEntityDescription insertNewObjectForEntityForName:@"PlayerStatistics" inManagedObjectContext:ctx];
        playerStats.newRelationship = player;
    } else {
        playerStats = [playerStatsArray lastObject];
    }
    
    return playerStats;
}

@end
