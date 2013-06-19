//
//  TeamStatistics+Create.m
//  GoGreen
//
//  Created by admin mac on 12/9/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#import "TeamStatistics+Create.h"

@implementation TeamStatistics (Create)
+ (TeamStatistics *) statsForTeam:(Team *)team withManagedObjectContext:(NSManagedObjectContext *)ctx {
    TeamStatistics *teamStats = nil;
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"TeamStatistics"];
    req.predicate = [NSPredicate predicateWithFormat:@"newRelationship = %@", team];
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"newRelationship" ascending:YES];
    req.sortDescriptors = [NSArray arrayWithObject:sortDesc];
    NSError *err = nil;
    NSArray *teamStatsArray = [ctx executeFetchRequest:req error:&err];
    
    if (!teamStatsArray || ([teamStatsArray count] > 1)) {
        // handle error
    } else if (![teamStatsArray count]) {
        teamStats = [NSEntityDescription insertNewObjectForEntityForName:@"TeamStatistics" inManagedObjectContext:ctx];
        teamStats.newRelationship = team;
    } else {
        teamStats = [teamStatsArray lastObject];
    }
    
    return teamStats;
}
@end
