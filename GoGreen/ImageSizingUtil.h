//
//  ImageSizingUtil.h
//  GoGreen
//
//  Created by admin mac on 3/20/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageSizingUtil : NSObject
+ (CGRect) calculateRectForImage:(UIImageView *)imageView withMaxHeight:(float)height andWithMaxWidth:(float)width;
@end
