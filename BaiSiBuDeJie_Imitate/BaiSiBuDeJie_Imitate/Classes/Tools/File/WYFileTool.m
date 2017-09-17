//
//  WYFileTool.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/17.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "WYFileTool.h"

@implementation WYFileTool

#pragma mark - 根据文件路径计算文件尺寸
+ (void)getFileSize:(NSString *)directory completion:(void(^)(NSInteger totalSize))completion {
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    BOOL isExist = [fileMgr fileExistsAtPath:directory isDirectory:&isDirectory];
    
    // 如果文件不存在或者不是文件夹要抛出异常
    if (!isExist || !isDirectory) {
        
        NSException *exception = [NSException exceptionWithName:@"pathError" reason:@"需要传入的是文件夹路径，并且路径要存在！" userInfo:nil];
        
        [exception raise];
    }
    
    // 开启异步线程计算，防止文件太大计算太久阻塞线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 获取文件夹下所有的文件路径，包括全部子路径
        NSArray *subPaths = [fileMgr subpathsAtPath:directory];
        
        WYLog(@"%@",subPaths);
        
        NSInteger totalSize = 0;
        // 遍历所有文件，计算文件大小
        for (NSString *subPath in subPaths) {
            
            // 拼接文件全路径
            NSString *filePath = [directory stringByAppendingPathComponent:subPath];
            
            // 如果包含DS隐藏文件则跳过不计算
            if ([filePath containsString:@".DS"]) continue;
            
            // 判断文件是否是文件夹
            BOOL isDirectory;
            BOOL isExist = [fileMgr fileExistsAtPath:filePath isDirectory:&isDirectory];
            // 如果文件不存在或者是文件夹也要跳过不计算
            if (!isExist || isDirectory) continue;
            // 获取文件属性
            NSDictionary *attr = [fileMgr attributesOfItemAtPath:filePath error:nil];
            
            NSInteger size = [attr fileSize];
            
            totalSize += size;
        }
        
        // 回到主线程刷新UI
        dispatch_sync(dispatch_get_main_queue(), ^{
           
            if (completion) {
                completion(totalSize);
            }
            
        });
        
    });
}

#pragma mark - 删除文件夹下的全部文件
+ (void)removeDirectoryPath:(NSString *)directoryPath {
    
    NSFileManager *mgr = [NSFileManager defaultManager];

    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    // 如果文件不存在或者不是文件夹要抛出异常
    if (!isExist || !isDirectory) {
        
        NSException *exception = [NSException exceptionWithName:@"pathError" reason:@"需要传入的是文件夹路径，并且路径要存在！" userInfo:nil];
        
        [exception raise];
    }
    
    // 获取到cache文件夹下面的子文件路径，不包括二级路径
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *subPath in subPaths) {
        // 拼接全路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        // 删除文件
        [mgr removeItemAtPath:filePath error:nil];
    }
    
}

@end
