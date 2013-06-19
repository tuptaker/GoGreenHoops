//
//  Team+Create.m
//  GoGreen
//
//  Created by admin mac on 12/8/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#import "Team+Create.h"

@implementation Team (Create)

+ (Team *) teamWithName:(NSString *)name forTeamUid:(NSString *)teamUid withManagedObjectContext:(NSManagedObjectContext *)ctx andSeason:(NSNumber *)season {
    Team *team = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *teamArray = [ctx executeFetchRequest:request error:&error];
    
    if (!teamArray || ([teamArray count] > 1)) {
        // handle error
    } else if (![teamArray count]) {
        team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:ctx];
        team.name = name;
        team.teamUid = teamUid;
        team.season = season;
    } else {
        team = [teamArray lastObject];
    }
    
    return team;
}

@end
