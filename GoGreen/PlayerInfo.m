//
//  PlayerInfo.m
//  GoGreen
//
//  Created by admin mac on 1/29/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import "PlayerInfo.h"

@implementation PlayerInfo

@synthesize nameLabel;
@synthesize numberLabel;
@synthesize dobLabel;
@synthesize collegeLabel;
@synthesize yearsLabel;
@synthesize heightLabel;
@synthesize weightLabel;
@synthesize positionLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
- (void)drawRect:(CGRect)rect
{
}
*/

@end
