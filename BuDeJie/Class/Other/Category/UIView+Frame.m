//
//  UIView+Frame.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/8.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
- (void)setZh_height:(CGFloat)zh_height
{
    CGRect rect = self.frame;
    rect.size.height = zh_height;
    self.frame = rect;
}

- (CGFloat)zh_height{
    return self.frame.size.height;
}

- (void)setZh_width:(CGFloat)zh_width
{
    CGRect rect = self.frame;
    rect.size.width = zh_width;
    self.frame = rect;
}

- (CGFloat)zh_width
{
    return self.frame.size.width;
}

- (void)setZh_x:(CGFloat)zh_x
{
    CGRect rect = self.frame;
    rect.origin.x = zh_x;
    self.frame = rect;
}

- (CGFloat)zh_x
{
    return self.frame.origin.x;
}

- (void)setZh_y:(CGFloat)zh_y
{
    CGRect rect = self.frame;
    rect.origin.y = zh_y;
    self.frame = rect;
}

- (CGFloat)zh_y
{
    return self.frame.origin.y;
}

- (void)setZh_centerX:(CGFloat)zh_centerX
{
    CGPoint center = self.center;
    center.x = zh_centerX;
    self.center = center;
}

- (CGFloat)zh_centerX
{
    return self.center.x;
}

- (void)setZh_centerY:(CGFloat)zh_centerY
{
    CGPoint center = self.center;
    center.y = zh_centerY;
    self.center = center;
}

- (CGFloat)zh_centerY
{
    return self.center.y;
}


+ (instancetype)zh_viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

@end
