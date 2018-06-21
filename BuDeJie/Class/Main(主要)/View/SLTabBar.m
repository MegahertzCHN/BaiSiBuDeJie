//
//  SLTabBar.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/8.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLTabBar.h"

@interface SLTabBar ()
@property (nonatomic, weak) UIButton *plusButton;
/// 上一次点击的按钮
@property (nonatomic, weak) UIControl *previousClickedtabBarButton;
@end

@implementation SLTabBar

- (UIButton *)plusButton
{
    if (!_plusButton) {
        UIButton * plusButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:(UIControlStateNormal)];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:(UIControlStateHighlighted)];
        
        // 根据按钮内容自适应
        [plusButton sizeToFit];
        
        _plusButton = plusButton;
        
        [self addSubview:_plusButton];
    }
    return _plusButton;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.items.count + 1;
    CGFloat btnW = self.zh_width / count;
    CGFloat btnH = self.zh_height;
    CGFloat btnX = 0;
    CGFloat btnY = 0;

    // 布局tabBarbutton
    NSInteger i = 0;
    for (UIControl *tabBarBtn in self.subviews) {
        // 用苹果私有的类 只能将类名字符串转化为该类
        if ([tabBarBtn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {

            // 设置previousClickedtabBarButton默认为最前面的按钮
            if (i == 0 && self.previousClickedtabBarButton == nil) {
                self.previousClickedtabBarButton = tabBarBtn;
            }
            
            if (i == 2) {
                i += 1;
            }
            btnX = i * btnW;
            tabBarBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            i++;
            
            // 监听点击
            // UIControlEventTouchDownRepeat 短时间内连续点击按钮
            [tabBarBtn addTarget:self action:@selector(tabBarBurronClick:) forControlEvents:UIControlEventTouchUpInside];

            
        }
    }
    // 设置加号按钮center
    self.plusButton.center = CGPointMake(self.zh_width * 0.5, self.zh_height * 0.5);
}

/// tabBar的点击
- (void)tabBarBurronClick:(UIControl *)tabBarButton
{
    if (self.previousClickedtabBarButton == tabBarButton) {
        // 发出通知，告知外界，tabBar被重复点击了
        
        // UIKeyboardWillShowNotification;
        // UIKeyboardWillHideNotification;
        // UIKeyboardDidShowNotification;
        // 前缀 + 主体 + Did、Will + 动词 + Notification
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SLTabBarBarTemDidRepeatClickedNotification object:nil];
    }
    self.previousClickedtabBarButton = tabBarButton;
}


@end
