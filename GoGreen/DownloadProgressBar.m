//
//  DownloadProgressBar.m
//  GoGreen
//
//  Created by admin mac on 2/3/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import "DownloadProgressBar.h"
#import <QuartzCore/QuartzCore.h>

@implementation DownloadProgressBar

@synthesize statusLabel;
@synthesize progressBar;

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
    self.progressBar.trackTintColor = [UIColor colorWithRed:0.000 green:0.380 blue:0.149 alpha:1.000];
    //self.layer.borderWidth = 2.0f;
    //self.layer.borderColor = [UIColor colorWithRed:0.627 green:0.769 blue:0.682 alpha:1.000].CGColor;
    self.layer.cornerRadius = 5.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
}

/*
- (void)drawRect:(CGRect)rect
{

}
*/

@end
