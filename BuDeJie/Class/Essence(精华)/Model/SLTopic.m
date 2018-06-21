//
//  SLTopic.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/25.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLTopic.h"

@implementation SLTopic
- (CGFloat)cellHeight
{
    // 如果已经计算过，就直接返回
    if (_cellHeight) return _cellHeight;
    
    _cellHeight = 0;
    
    // 文字的Y值
    _cellHeight += 55;
    
    // 文字的高度
    CGSize textMaxSize = CGSizeMake(SLScreenW - ZHMargin * 2, MAXFLOAT);
    _cellHeight += [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + ZHMargin;
    
    // 中间的内容
    if (self.type != ZHTopicTypeWord) { // 中间有内容（图片、声音、视频）
        CGFloat middleW = textMaxSize.width;
        CGFloat middleH = self.height * middleW / self.width;
        CGFloat middleX = ZHMargin;
        CGFloat middleY = _cellHeight;
        
        if (middleH >= SLScreenH) { // 现实的高度超过屏幕高度
            middleH = 200;
            self.isBigPicture = YES;
        }
        
        self.middleFrame = CGRectMake(middleX, middleY, middleW, middleH);
        
        _cellHeight += middleH + ZHMargin;
    }
    
    
    // 最热评论
    if (self.top_cmt.count) { // 最热评论
        // 标题
        _cellHeight += 21;
        
        // 内容
        NSDictionary *cmt = self.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        NSString *username = cmt[@"user"][@"username"];
        if (content.length == 0) {
            content = @"【语音评论】";
        }
        NSString *cmtText = [NSString stringWithFormat:@"%@：%@", username, content];

        _cellHeight += [cmtText boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + ZHMargin;

    } else {
        
    }
    
    
    // 底部工具条
    _cellHeight += 35 + ZHMargin;
    
    return _cellHeight;
}
@end
