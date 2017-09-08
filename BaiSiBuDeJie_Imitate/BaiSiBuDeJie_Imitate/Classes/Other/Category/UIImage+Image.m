//
//  UIImage+Image.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/8.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)


/**
 快速生成不被渲染的图片

 @param imageNamed 图片名称

 @return 不被渲染的图片
 */
+ (UIImage *)imageOriginalWithNamed:(NSString *)imageNamed {
    
    UIImage *image = [UIImage imageNamed:imageNamed];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
