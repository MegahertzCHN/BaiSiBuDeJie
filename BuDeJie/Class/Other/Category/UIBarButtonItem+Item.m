//
//  UIBarButtonItem+Item.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/9.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (Item)
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image
                         highImage:(UIImage *)highImage
                            target:(id)target
                            action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:image forState:(UIControlStateNormal)];
    [btn setBackgroundImage:highImage forState:(UIControlStateHighlighted)];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    // 把UIButton包装成UIBarButtonItem 就导致按钮的点击区域扩大
    return [[UIBarButtonItem alloc] initWithCustomView:containView];
}

+ (UIBarButtonItem *)itemWithImage:(UIImage *)image
                         selImage:(UIImage *)selImage
                            target:(id)target
                            action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:image forState:(UIControlStateNormal)];
    [btn setBackgroundImage:selImage forState:(UIControlStateSelected)];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    // 把UIButton包装成UIBarButtonItem 就导致按钮的点击区域扩大
    return [[UIBarButtonItem alloc] initWithCustomView:containView];
}

// 返回按钮
+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image
                             highImage:(UIImage *)highImage
                                target:(id)target
                                action:(SEL)action
                                tittle:(NSString *)title
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:highImage forState:UIControlStateHighlighted];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

@end
