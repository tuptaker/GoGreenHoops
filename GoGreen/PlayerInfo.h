//
//  PlayerInfo.h
//  GoGreen
//
//  Created by admin mac on 1/29/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerInfo : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dobLabel;
@property (weak, nonatomic) IBOutlet UILabel *collegeLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearsLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@end
