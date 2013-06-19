//
//  PlayerInfoCarousel.h
//  GoGreen
//
//  Created by admin mac on 2/12/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerInfoThumbScrollView.h"

@interface PlayerInfoCarousel : UICollectionReusableView

@property (weak, nonatomic) IBOutlet PlayerInfoThumbScrollView *playerThumbScrollView;

@end
