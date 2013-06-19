//
//  TeamStatsParseOperation.h
//  GoGreen
//
//  Created by admin mac on 11/19/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamStatsParseOperation : NSOperation
- (id) initWithData:(NSMutableData *) data;
- (id) initWithParser:(NSXMLParser *) parser andContext:(NSManagedObjectContext *)ctx;
@end
