//
//  PlayerInfoThumbScrollView.m
//  GoGreen
//
//  Created by admin mac on 3/5/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import "PlayerInfoThumbScrollView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PlayerInfoThumbScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(Class) layerClass {
    
    return [CAGradientLayer class];
}

- (void) awakeFromNib {
    CAGradientLayer *gradientLayer = (CAGradientLayer *) self.layer;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[UIColor colorWithRed:0.000 green:0.380 blue:0.149 alpha:1.000].CGColor, (id)[UIColor colorWithRed:0.192 green:0.498 blue:0.314 alpha:1.000].CGColor, nil]];
    self.layer.opacity = 0.9f;
    self.layer.cornerRadius = 5.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 3.0f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.cornerRadius = 5.0f;
    
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
