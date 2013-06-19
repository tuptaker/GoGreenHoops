//
//  PlayerCell.h
//  GoGreen
//
//  Created by admin mac on 1/27/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNumberLabel;
@end
