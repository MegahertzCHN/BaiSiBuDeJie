//
//  UIImage+Image.h
//  BuDeJie
//
//  Created by 赵鹤 on 2016/9/29.
//  Copyright © 2016年 SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
// 快速生成一个没有渲染的图片
+ (UIImage * )imgeOriginalWithName:(NSString *)imageName;

/**
 快速生成圆形图片
 */
- (instancetype)zh_circleImage;
+ (instancetype)zh_circleImageNamed:(NSString *)name;


@end
