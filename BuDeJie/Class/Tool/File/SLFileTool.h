//
//  SLFileTool.h
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/18.
//  Copyright © 2016年 SL. All rights reserved.
//  处理文件缓存

#import <Foundation/Foundation.h>

@interface SLFileTool : NSObject

/**
 *  获取文件夹尺寸
 * 
 *  @pragam directoryPath 文件夹路径
 *
 */
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger))completion;

// 清除缓存
/**
 *  删除文件夹里面所有的文件
 *
 *  @pragam directoryPath 文件夹路径
 *
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;
@end
