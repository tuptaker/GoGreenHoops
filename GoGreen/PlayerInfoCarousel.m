//
//  PlayerInfoCarousel.m
//  GoGreen
//
//  Created by admin mac on 2/12/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import "PlayerInfoCarousel.h"
#import "SportsDataConstants.h"
#import "AFJSONRequestOperation.h"
#import <QuartzCore/QuartzCore.h>

@implementation PlayerInfoCarousel

@synthesize playerThumbScrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
