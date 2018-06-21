//
//  SLFileTool.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/18.
//  Copyright © 2016年 SL. All rights reserved.
//  处理文件缓存 

#import "SLFileTool.h"



@implementation SLFileTool

+ (void)removeDirectoryPath:(NSString *)directoryPath
{
    // 获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 判断是否是文件夹
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isDirectory || !isExist){
        // 抛异常
        // Name: 异常名称
        // reason: 报错原因
        NSException *excep = [NSException exceptionWithName:@"pathError" reason:@"需要传入文件夹路径, 并且路径要存在" userInfo:nil];
        // 抛出异常
        [excep raise];
    }
    
    // 获取cache文件夹下所有文件 不包括子路径下的子路径
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
    NSLog(@"%@", subPaths);
    
    for (NSString *subPath in subPaths) {
        // 拼接完整的全路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        
        // 删除路径
        [mgr removeItemAtPath:filePath error:nil];
    }
}



// 自己计算SDWebImage做的缓存大小
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger))completion
{
    // NSFileManager
    // attributesOfItemAtPath : 指定文件路径 就能获取文件属性
    // 把所有文件尺寸加起来
    
    // 获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 判断是否是文件夹
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isDirectory || !isExist){
        // 抛异常
        // Name: 异常名称
        // reason: 报错原因
        NSException *excep = [NSException exceptionWithName:@"pathError" reason:@"需要传入文件夹路径, 并且路径要存在" userInfo:nil];
        // 抛出异常
        [excep raise];
    }
    
    // 子线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 获取文件夹下的子路径, 包括文件夹下的子路径的子路径
        NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
        
        NSInteger totalSize = 0;
        
        // 遍历文件夹所有的文件, 一个一个全加起来
        for (NSString *subPath in subPaths) {
            // 获取文件全路径
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            
            // 判断是否是隐藏文件
            if ([filePath containsString:@".DS"]) continue;
            
            // 判断是否是文件夹
            BOOL isDirectory;
            BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (isDirectory || !isExist) continue;
            
            // 获取文件属性
            // attributesOfItemAtPath: 获取文件夹不对, 只能获取文件尺寸
            NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
            
            // default尺寸
            NSInteger fileSize = [attr fileSize];
            
            totalSize += fileSize;
        }
        

        // 主线程
        dispatch_sync(dispatch_get_main_queue(), ^{
            // 计算完成 回调 block
            if (completion) {
                completion(totalSize);
            }
        });
    });
    
    
}



@end
