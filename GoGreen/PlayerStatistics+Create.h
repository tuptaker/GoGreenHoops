//
//  PlayerStatistics+Create.h
//  GoGreen
//
//  Created by admin mac on 1/19/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import "PlayerStatistics.h"

@interface PlayerStatistics (Create)
+ (PlayerStatistics *) statsForPlayer:(Player *)player withManagedObjectContext:(NSManagedObjectContext *)ctx;
@end
