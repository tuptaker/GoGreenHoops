//
//  RosterParseOperation.h
//  GoGreen
//
//  Created by admin mac on 11/12/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RosterParseOperation : NSOperation
- (id) initWithParser:(NSXMLParser *) parser andContext:(NSManagedObjectContext *)ctx;
@end
