//
//  ImageSizingUtil.m
//  GoGreen
//
//  Created by admin mac on 3/20/13.
//  Copyright (c) 2013 Frabulon. All rights reserved.
//

#import "ImageSizingUtil.h"

@implementation ImageSizingUtil

+ (CGRect) calculateRectForImage:(UIImageView *)imageView withMaxHeight:(float)height andWithMaxWidth:(float)width {
    CGSize kMaxImageViewSize = {.width = height, .height = width};
    
    CGSize imageSize = imageView.image.size;
    CGFloat aspectRatio = imageSize.width / imageSize.height;
    
    CGRect currPlayerImgFrame = imageView.frame;
    if (kMaxImageViewSize.width / aspectRatio <= kMaxImageViewSize.height) {
        currPlayerImgFrame.size.width = kMaxImageViewSize.width;
        currPlayerImgFrame.size.height = currPlayerImgFrame.size.width / aspectRatio;
    } else {
        currPlayerImgFrame.size.height = kMaxImageViewSize.height;
        currPlayerImgFrame.size.width = currPlayerImgFrame.size.height * aspectRatio;
    }
    return currPlayerImgFrame;
}
@end
