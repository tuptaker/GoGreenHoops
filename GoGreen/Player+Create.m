//
//  Player+Create.m
//  GoGreen
//
//  Created by admin mac on 12/8/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#import "Player+Create.h"

@implementation Player (Create)

+ (Player *) playerWithUuid:(NSString *)uuid withManagedObjectContext:(NSManagedObjectContext *)ctx {
    Player *player = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Player"];
    request.predicate = [NSPredicate predicateWithFormat:@"playerUid = %@", uuid];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"playerUid" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *playerArray = [ctx executeFetchRequest:request error:&error];
    
    if (!playerArray || ([playerArray count] > 1)) {
        // handle error
    } else if (![playerArray count]) {
        player = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:ctx];
        player.playerUid = uuid;
    } else {
        player = [playerArray lastObject];
    }
    
    return player;
}

@end
