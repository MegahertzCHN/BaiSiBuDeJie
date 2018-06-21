//
//  SLSubTagCell.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/11.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLSubTagCell.h"
#import "SLSubTagItem.h"
#import <UIImageView+WebCache.h>
#import "UIImage+Antialias.h"
@interface SLSubTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *numView;

@end

@implementation SLSubTagCell

/*
    1.头像变成圆角 1.设置头像的圆角 2.裁剪图片 (生成新的图片  -> 图形上下文才能够生成新的图片)
    2.处理数字
 */
- (void)setFrame:(CGRect)frame
{
    NSLog(@"%@", NSStringFromCGRect(frame));
    // 才是真正的去给cell赋值
    frame.size.height -= 1;
    [super setFrame:frame];
}


- (void)setItem:(SLSubTagItem *)item
{
    _item = item;
    
    // 判断有没有>=10000
    [self resolveNum];
    
    self.nameView.text = item.theme_name;
    
    // 设置头像
    [self.iconView zh_setHeader:item.image_list];
}

// 处理订阅数字
- (void)resolveNum
{
    // 判断有没有>10000
    NSString *numStr = [NSString stringWithFormat:@"%@人订阅", _item.sub_number];
    NSInteger num = _item.sub_number.integerValue;
    if (num > 1000) {
        CGFloat numF = num / 10000.0;
        numStr = [NSString stringWithFormat:@"%.1f万人订阅", numF];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    self.numView.text = numStr;
}

// 从xib加载就会调用 就只会调用一次
- (void)awakeFromNib {
    [super awakeFromNib];
    // 设置圆角头像 iOS9苹果修复卡顿
    _iconView.layer.cornerRadius = 30;
    _iconView.layer.masksToBounds = YES;
    
    // self.layoutMargins = UIEdgeInsetsZero;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
