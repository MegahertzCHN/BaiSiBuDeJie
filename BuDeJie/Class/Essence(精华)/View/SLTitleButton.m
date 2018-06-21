//
//  SLTitleButton.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/19.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLTitleButton.h"

/*
 特定构造方法
 1> 后面带有NS_DESIGNATED_INITIALIZER的方法， 就是特定构造方法
 
 2> 子类如果重写了【父类的构造方法】，就必须用【super】调用父类的【特定构造方法】，不然会出现警告
 */

/*
 警告信息：Designated initializer missing a 'super' call to a designated initializer of the super class
 意思：【特定构造方法】缺少super去调用父类的【特定构造方法】
*/



@implementation SLTitleButton

// 自定义控件
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    return self;
}


- (void)setHighlighted:(BOOL)highlighted
{ // 只要重写这个方法，按钮就无法进入highlighted状态
    
}

@end
