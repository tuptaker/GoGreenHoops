//
//  TeamStatistics+Create.h
//  GoGreen
//
//  Created by admin mac on 12/9/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#import "TeamStatistics.h"

@interface TeamStatistics (Create)
+ (TeamStatistics *) statsForTeam:(Team *)team withManagedObjectContext:(NSManagedObjectContext *)ctx;
@end
