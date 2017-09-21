//
//  UIImage+Image.h
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/8.
//  Copyright © 2017年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)

/**
 快速生成不被渲染的图片
 
 @param imageNamed 图片名称
 
 @return 不被渲染的图片
 */
+ (UIImage *)imageOriginalWithNamed:(NSString *)imageNamed;

/**
 裁剪圆形图片
 
 @param image 需要裁剪的图片
 
 @return 返回裁剪后的圆形图片
 */
+ (UIImage *)circleImageWithImage:(UIImage *)image;

@end
