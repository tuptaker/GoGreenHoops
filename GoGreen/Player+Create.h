//
//  Player+Create.h
//  GoGreen
//
//  Created by admin mac on 12/8/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#import "Player.h"

@interface Player (Create)
+ (Player *) playerWithUuid:(NSString *)uuid withManagedObjectContext:(NSManagedObjectContext *)ctx;
@end
