//
//  UIImageView+Download.h
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/21.
//  Copyright © 2017年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface UIImageView (Download)


/**
 根据网络情况加载相应的图片

 @param originImageUrl    原图的URL
 @param thumbnailImageUrl 缩略图的URL
 @param placeholderImage  占位图片
 */
- (void)setOriginImage:(NSString *)originImageUrl thumbnailImage:(NSString *)thumbnailImageUrl placeholderImage:(UIImage *)placeholderImage completed:(SDWebImageCompletionBlock)completedBlock;

@end
