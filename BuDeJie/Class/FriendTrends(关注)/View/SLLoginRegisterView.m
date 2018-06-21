//
//  SLLoginRegisterView.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/12.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLLoginRegisterView.h"

@interface SLLoginRegisterView ()
@property (weak, nonatomic) IBOutlet UIButton *loginRegisterBtn;

@end

@implementation SLLoginRegisterView


+ (instancetype)loginView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

+ (instancetype)registerView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

// 加载xib就会调用
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIImage *image = _loginRegisterBtn.currentBackgroundImage;
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    // 让按钮的图片不要拉伸
    [_loginRegisterBtn setBackgroundImage:image forState:UIControlStateNormal];
}

@end
