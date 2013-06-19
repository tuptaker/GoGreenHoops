//
//  DownloadProgressBar.h
//  GoGreen
//
//  Created by admin mac on 2/3/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadProgressBar : UIView
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@end
