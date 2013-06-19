//
//  SelectedPlayerImgViewController.h
//  GoGreen
//
//  Created by admin mac on 3/12/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedPlayerImgViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *selectedPlayerImgView;
@property (strong, nonatomic) IBOutlet NSString *playerName;
@property (strong, nonatomic) NSManagedObjectContext *childCtx;
@property (strong, nonatomic) NSString *shortenedAppStoreLink;
@end
