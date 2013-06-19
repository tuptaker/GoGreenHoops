//
//  PlayerCell.m
//  GoGreen
//
//  Created by admin mac on 1/27/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import "PlayerCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PlayerCell
@synthesize firstNameLabel;
@synthesize lastNameLabel;
@synthesize playerNumberLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void) awakeFromNib {
    self.layer.borderWidth = 3.0f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.cornerRadius = 5.0f;
}

/*
- (void)drawRect:(CGRect)rect
{
}
*/

@end
