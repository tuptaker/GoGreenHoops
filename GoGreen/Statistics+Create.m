//
//  Statistics+Create.m
//  GoGreen
//
//  Created by admin mac on 1/19/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import "Statistics+Create.h"

@implementation Statistics (Create)

#if 0
+ (Statistics *) playerWithUuid:(NSString *)uuid withManagedObjectContext:(NSManagedObjectContext *)ctx {
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
#endif

@end
