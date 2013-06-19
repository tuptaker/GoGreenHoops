//
//  PlayerStatsCell.h
//  GoGreen
//
//  Created by admin mac on 1/28/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerStatsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *gamesPlayedLabel;
@property (weak, nonatomic) IBOutlet UILabel *gamesStartedLabel;
@property (weak, nonatomic) IBOutlet UILabel *plusMinusLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *ppgLabel;
@property (weak, nonatomic) IBOutlet UILabel *apgLabel;
@property (weak, nonatomic) IBOutlet UILabel *rpgLabel;
@property (weak, nonatomic) IBOutlet UILabel *spgLabel;
@property (weak, nonatomic) IBOutlet UILabel *bpgLabel;
@property (weak, nonatomic) IBOutlet UILabel *fgpctLabel;
@property (weak, nonatomic) IBOutlet UILabel *ftpctLabel;
@property (weak, nonatomic) IBOutlet UILabel *ptsLabel;
@property (weak, nonatomic) IBOutlet UILabel *assistsLabel;
@property (weak, nonatomic) IBOutlet UILabel *rebLabel;
@property (weak, nonatomic) IBOutlet UILabel *stealsLabel;
@property (weak, nonatomic) IBOutlet UILabel *blocksLabel;
@property (weak, nonatomic) IBOutlet UILabel *fgmLabel;
@property (weak, nonatomic) IBOutlet UILabel *ftmLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeptmLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeptpctLabel;
@end
