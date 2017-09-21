//
//  UIImageView+Download.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/21.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "UIImageView+Download.h"


@implementation UIImageView (Download)

/**
 根据网络情况加载相应的图片
 
 @param originImageUrl    原图的URL
 @param thumbnailImageUrl 缩略图的URL
 @param placeholderImage  占位图片
 */
- (void)setOriginImage:(NSString *)originImageUrl thumbnailImage:(NSString *)thumbnailImageUrl placeholderImage:(UIImage *)placeholderImage completed:(SDWebImageCompletionBlock)completedBlock {
    
    // 监控网络状态，必须先调用startMonitoring方法，一般是在Appdelegate里面调用一次
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 首先判断沙盒是否有下载好原图
    UIImage *originImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originImageUrl];
    
    if (originImage) { // 原图已经下载过
       
        self.image = originImage;
        
        completedBlock(originImage,nil,0,[NSURL URLWithString:originImageUrl]);
        
    } else { // 原图没有被下载过
        
        if (manager.isReachableViaWiFi) { // WiFi状态下，加载原图
            
            [self sd_setImageWithURL:[NSURL URLWithString:originImageUrl] placeholderImage:placeholderImage completed:completedBlock];
            
        } else if (manager.isReachableViaWWAN) { // 手机网络状态下，加载缩略图
            
            [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageUrl] placeholderImage:placeholderImage completed:completedBlock];
            
        } else { // 没有可用网络
            // 看看沙盒是否已经加载过缩略图
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailImageUrl];
            
            if (thumbnailImage) { // 有加载过缩略图直接显示
                self.image = thumbnailImage;
                
                completedBlock(thumbnailImage,nil,0,[NSURL URLWithString:thumbnailImageUrl]);
                
            } else { // 没有加载过就显示占位图
                self.image = placeholderImage;
            }
        }
    }
}

@end
