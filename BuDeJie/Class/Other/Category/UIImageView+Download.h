//
//  UIImageView+Download.h
//  BuDeJie
//
//  Created by 赵鹤 on 2016/11/1.
//  Copyright © 2016年 SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

@interface UIImageView (Download)

/**
 通过网络状态来选择不同服务器地址的图片

 @param originImageUrl    高清图片
 @param thumbnailImageUrl 小图片
 @param placeholder       占位视图
 */
- (void)zh_setOriginImageWithUrl:(NSString *)originImageUrl
           thumbnailImageWithUrl:(NSString *)thumbnailImageUrl
                     placeholder:(UIImage *)placeholder
                       completed:(SDWebImageCompletionBlock)completedBlock;


/**
 通过SDWebImage，生成圆形头像图片

 @param headerUrl 图片的网络地址
 */
- (void)zh_setHeader:(NSString *)headerUrl;

@end
