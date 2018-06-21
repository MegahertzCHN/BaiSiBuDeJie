//
//  UIBarButtonItem+Item.h
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/9.
//  Copyright © 2016年 SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)
// 快速创建UIBarButtonItem对象的方法
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image
                         highImage:(UIImage *)highImage
                            target:(id)target
                            action:(SEL)action;

// 按钮高亮状态
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image
                          selImage:(UIImage *)selImage
                            target:(id)target
                            action:(SEL)action;

// 返回按钮
+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image
                             highImage:(UIImage *)highImage
                                target:(id)target
                                action:(SEL)action
                                tittle:(NSString *)title;

@end
