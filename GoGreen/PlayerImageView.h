//
//  PlayerImageView.h
//  GoGreen
//
//  Created by admin mac on 3/7/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerImageViewDelegate;

@interface PlayerImageView : UIImageView
@property id <PlayerImageViewDelegate> delegate;
@end

@protocol PlayerImageViewDelegate <NSObject>
@optional
- (void) playerImageViewTapped:(PlayerImageView *)playerImgView;
@end


