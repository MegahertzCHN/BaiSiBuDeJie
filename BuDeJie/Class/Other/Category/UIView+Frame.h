//
//  UIView+Frame.h
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/8.
//  Copyright © 2016年 SL. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
    写分类: 一定要注意不要和其他的开发者起重名
    解决办法: 加前缀
 
 */


@interface UIView (Frame)
@property CGFloat zh_width;
@property CGFloat zh_height;
@property CGFloat zh_x;
@property CGFloat zh_y;
@property CGFloat zh_centerX;
@property CGFloat zh_centerY;

+ (instancetype)zh_viewFromXib;

@end
