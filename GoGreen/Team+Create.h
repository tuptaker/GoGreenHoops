//
//  Team+Create.h
//  GoGreen
//
//  Created by admin mac on 12/8/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#import "Team.h"

@interface Team (Create)
+ (Team *) teamWithName:(NSString *)name forTeamUid:(NSString *)teamUid withManagedObjectContext:(NSManagedObjectContext *)ctx andSeason:(NSNumber *)season;
@end
