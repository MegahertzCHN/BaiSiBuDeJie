//
//  SLTopicVoiceView.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/29.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLTopicVoiceView.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import "SLTopic.h"
#import "SLSeeBigImageViewController.h"

@interface SLTopicVoiceView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voiceTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;

@end

@implementation SLTopicVoiceView


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigImage)]];
}



- (void)setTopic:(SLTopic *)topic
{
    _topic = topic;
    
    // 设置图片
    self.placeholderView.hidden = NO;
    [self.imageView zh_setOriginImageWithUrl:topic.image1 thumbnailImageWithUrl:topic.image0 placeholder:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        
        self.placeholderView.hidden = YES;
    }];
    
    // 播放数量
    if (topic.playcount >= 10000) {
         self.playCountLabel.text = [NSString stringWithFormat:@"%.1f万播放", topic.playcount / 10000.0];
    } else {
        self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    }
    // %04 : 占据4位，多余的用0填补
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", topic.voicetime / 60, topic.voicetime % 60];
}

- (void)seeBigImage
{
    SLSeeBigImageViewController *seeBigVc = [[SLSeeBigImageViewController alloc] init];
    seeBigVc.topic = _topic;
    [self.window.rootViewController presentViewController:seeBigVc animated:YES completion:nil];
}
@end
