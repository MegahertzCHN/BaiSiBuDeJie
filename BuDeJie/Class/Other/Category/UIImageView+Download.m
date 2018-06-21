//
//  UIImageView+Download.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/11/1.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "UIImageView+Download.h"
#import <AFNetworking.h>
#import "UIImage+Antialias.h"
@implementation UIImageView (Download)
- (void)zh_setOriginImageWithUrl:(NSString *)originImageUrl
           thumbnailImageWithUrl:(NSString *)thumbnailImageUrl
                     placeholder:(UIImage *)placeholder
                       completed:(SDWebImageCompletionBlock)completedBlock
{
//    [[SDWebImageManager sharedManager] setCacheKeyFilter:^(NSURL *url){
//        return @"123";
//        // 所有缓存图片的key后面都有-xmg后缀
//        return [NSString stringWithFormat:@"%@-xmg", url.absoluteString];
//    }];
    
    // 根据网络状态来加载图片
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // url 字符串  -- UIImage
    
    // 获得原图（大图）（SDWebImage缓存图片是用url字符串作为key）
    // SDWebImage沙盒文件找url首先会在内存中去找，再去沙盒里面去找
    UIImage *originImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originImageUrl];
    if (originImage) { // 原图已经被下载过
//        self.image = originImage;
//        completedBlock(originImage, nil, 0, [NSURL URLWithString:originImageUrl]);
        [self sd_setImageWithURL:[NSURL URLWithString:originImageUrl] placeholderImage:placeholder completed:completedBlock];
    } else { // 原图没有被下载过
        if (mgr.isReachableViaWiFi) {
            [self sd_setImageWithURL:[NSURL URLWithString:originImageUrl] placeholderImage:placeholder completed:completedBlock];
        } else if (mgr.reachableViaWWAN){
#warning downOriginImageWhen3GOr4G配置项 需要从沙盒里面获取
            // 3G/4G是否要下载高清大图
            BOOL downOriginImageWhen3GOr4G = YES;
            if (downOriginImageWhen3GOr4G) {
                [self sd_setImageWithURL:[NSURL URLWithString:originImageUrl] placeholderImage:placeholder completed:completedBlock];
            } else {
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageUrl] placeholderImage:placeholder completed:completedBlock];
            }
        } else { // 没有网络
            UIImage *thumbnail = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailImageUrl];
            if (thumbnail) {// 小图下载过
                self.image = thumbnail;
                completedBlock(thumbnail, nil, 0, [NSURL URLWithString:originImageUrl]);

            } else { // 显示占位
                // 占位图片;
                self.image = placeholder; // 如果没有占位图片，清空循环利用过来的图片
            }
        }
    }
}

- (void)zh_setHeader:(NSString *)headerUrl;
{
    UIImage *placeholder = [[UIImage zh_circleImageNamed:@"defaultUserIcon"] zh_circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 图片下载失败 直接返回，显示占位视图
        if (!image) return;
        
        image = [image zh_circleImage];
        
        // 抗锯齿
        self.image = [image imageAntialias];
    }];
}

@end
