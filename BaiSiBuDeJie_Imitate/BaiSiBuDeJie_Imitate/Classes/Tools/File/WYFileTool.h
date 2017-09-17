//
//  WYFileTool.h
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/17.
//  Copyright © 2017年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYFileTool : NSObject

/**
 根据文件夹路径计算文件尺寸

 @param directory  文件夹路径
 @param completion 计算完成后的回调
 */
+ (void)getFileSize:(NSString *)directory completion:(void(^)(NSInteger totalSize))completion;

#pragma mark - 删除文件夹下的全部文件

/**
 删除文件夹下的全部文件

 @param directoryPath 文件夹路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;

@end
