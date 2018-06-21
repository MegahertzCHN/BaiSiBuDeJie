//
//  SLTopicPictureView.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/29.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLTopicPictureView.h"
#import <UIImageView+WebCache.h>
#import "SLTopic.h"
#import "SLSeeBigImageViewController.h"
@interface SLTopicPictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
@end

@implementation SLTopicPictureView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigImage)]];
    
    // 控制按钮内部的子控件对齐，不使用contentMode，是用以下两个属性
//    UIButton *btn;
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//    
//    // 控制按钮内部子控件之间的间距
//    btn.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
//    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
}

- (void)seeBigImage
{
    SLSeeBigImageViewController *seeBigVc = [[SLSeeBigImageViewController alloc] init];
    seeBigVc.topic = _topic;
    [self.window.rootViewController presentViewController:seeBigVc animated:YES completion:nil];
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:seeBigVc animated:YES completion:nil];
}

- (void)setTopic:(SLTopic *)topic
{
    _topic = topic;
    
    // 设置图片
    self.placeholderView.hidden = NO;
    [self.imageView zh_setOriginImageWithUrl:topic.image1 thumbnailImageWithUrl:topic.image0 placeholder:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        
        self.placeholderView.hidden = YES;
        
        // 处理厂超长图片的大小
        if (topic.isBigPicture) {
            CGFloat middleW = topic.middleFrame.size.width;
            CGFloat middleH = middleW * topic.height / topic.width;
            CGSize size = CGSizeMake(middleW, middleH);
            
            // 开启上下文
            UIGraphicsBeginImageContext(size);
            // 绘制图片到上下文中
            [self.imageView.image drawInRect:CGRectMake(0, 0, middleW, middleH)];
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            // 关闭上下文
            UIGraphicsEndImageContext();
        }

    }];
    
    // gif
    // 忽略字符串里面的大小写
//    if ([topic.image1.lowercaseString hasSuffix:@"gif"]) {
//    if ([topic.image1.pathExtension.lowercaseString hasSuffix:@"gif"]) {
//        self.gifView.hidden = NO;
//    } else {
//        self.gifView.hidden = YES;
//    }
    
    self.gifView.hidden = !topic.is_gif;
    
    // 点击查看大图
    if (topic.isBigPicture) { // 超长图片
        self.seeBigButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
    } else {
        self.seeBigButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
    
    

}

@end
