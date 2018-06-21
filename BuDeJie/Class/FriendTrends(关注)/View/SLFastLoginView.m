//
//  SLFastLoginView.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/15.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLFastLoginView.h"

@implementation SLFastLoginView

+ (instancetype)fastLoginView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
@end
