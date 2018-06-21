//
//  SLRefreshHeader.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/11/10.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLRefreshHeader.h"

@implementation SLRefreshHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 自动切换透明度
        self.automaticallyChangeAlpha = YES;
        // 隐藏时间
        self.lastUpdatedTimeLabel.hidden = YES;
        // 设置文字颜色
        self.stateLabel.textColor = [UIColor grayColor];
        [self setTitle:@"赶紧下拉刷新" forState:MJRefreshStateIdle];
        [self setTitle:@"松开🐎上刷新" forState:MJRefreshStatePulling];
        [self setTitle:@"正在拼命加载数据..." forState:MJRefreshStateRefreshing];
    }
    return self;
}

@end
