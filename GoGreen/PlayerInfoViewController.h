//
//  PlayerInfoViewController.h
//  GoGreen
//
//  Created by admin mac on 1/28/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "PlayerImageView.h"
@interface PlayerInfoViewController : UICollectionViewController <PlayerImageViewDelegate>
@property (nonatomic, strong) Player* player;
@property (nonatomic, strong) UIImageView *currentPlayerImageToAdd;
@property (nonatomic, strong) NSManagedObjectContext *childCtx;
- (void) refreshCurrentPlayerImage;
@end
