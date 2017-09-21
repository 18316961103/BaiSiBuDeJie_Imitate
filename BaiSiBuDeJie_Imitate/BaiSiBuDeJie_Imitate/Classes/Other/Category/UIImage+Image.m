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


/**
 裁剪圆形图片

 @param image 需要裁剪的图片

 @return 返回裁剪后的圆形图片
 */
+ (UIImage *)circleImageWithImage:(UIImage *)image {
    
    // 最后一个参数scale：比例因数，点与像素的比例，0会自适配
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    // 描述裁剪区域
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    // 设置裁剪区域
    [bezierPath addClip];
    // 画图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    // 获取裁剪后的图片
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return circleImage;
}

@end
