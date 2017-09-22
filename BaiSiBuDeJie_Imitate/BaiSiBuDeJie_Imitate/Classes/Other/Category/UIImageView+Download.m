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
       
        // 不能直接设置图片，防止cell循环引起图片错乱，因为如果当前图片还没下载完，但是当前cell又进入了缓存池，重新显示的时候，会显示新的图片，但是如果这时候之前的图片的下载完了，就会覆盖了新的图片
//        self.image = originImage;
//        
//        completedBlock(originImage,nil,0,[NSURL URLWithString:originImageUrl]);
        // 使用SDWebImage设置图片，就会把之前的下载请求取消，所以就不会引起图片覆盖错乱的问题
        [self sd_setImageWithURL:[NSURL URLWithString:originImageUrl] placeholderImage:placeholderImage completed:completedBlock];

    } else { // 原图没有被下载过
        
        if (manager.isReachableViaWiFi) { // WiFi状态下，加载原图
            
            [self sd_setImageWithURL:[NSURL URLWithString:originImageUrl] placeholderImage:placeholderImage completed:completedBlock];
            
        } else if (manager.isReachableViaWWAN) { // 手机网络状态下，加载缩略图
            
            [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageUrl] placeholderImage:placeholderImage completed:completedBlock];
            
        } else { // 没有可用网络
            // 看看沙盒是否已经加载过缩略图
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailImageUrl];
            
            if (thumbnailImage) { // 有加载过缩略图直接显示
                // 不能直接设置图片，防止cell循环引起图片错乱，因为如果当前图片还没下载完，但是当前cell又进入了缓存池，重新显示的时候，会显示新的图片，但是如果这时候之前的图片的下载完了，就会覆盖了新的图片
//                self.image = thumbnailImage;
//                
//                completedBlock(thumbnailImage,nil,0,[NSURL URLWithString:thumbnailImageUrl]);
                
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageUrl] placeholderImage:placeholderImage completed:completedBlock];

            } else { // 没有加载过就显示占位图
                
//                self.image = placeholderImage;
                
                [self sd_setImageWithURL:nil placeholderImage:placeholderImage completed:completedBlock];

            }
        }
    }
}

@end
