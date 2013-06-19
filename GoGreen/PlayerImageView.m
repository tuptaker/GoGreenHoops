//
//  PlayerImageView.m
//  GoGreen
//
//  Created by admin mac on 3/7/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import "PlayerImageView.h"

@implementation PlayerImageView

@synthesize delegate;

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

#pragma mark UIResponder

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate playerImageViewTapped:self];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

@end
