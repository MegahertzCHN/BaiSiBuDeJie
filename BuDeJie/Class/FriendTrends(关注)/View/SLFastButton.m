//
//  SLFastButton.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/17.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLFastButton.h"

@implementation SLFastButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片位置
    self.imageView.zh_y = 0;
    self.imageView.zh_centerX = self.zh_width * 0.5;
    
    // 设置title位置
    self.titleLabel.zh_y = self.zh_height - self.titleLabel.zh_height;
    // 计算文字宽度
    [self.titleLabel sizeToFit];
    self.titleLabel.zh_centerX = self.zh_width * 0.5;
    

}

@end
