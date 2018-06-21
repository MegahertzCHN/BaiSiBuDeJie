//
//  SLTopicCell.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/26.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLTopicCell.h"
#import <UIImageView+WebCache.h>
#import "UIImage+Antialias.h"
#import "SLTopicPictureView.h"
#import "SLTopicVideoView.h"
#import "SLTopicVoiceView.h"
#import "SLTopic.h"

@interface SLTopicCell ()
// 控件命名 -> 功能 + 控件类型
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;


/**
 中间控件
 */

/** 视频控件 */
@property (nonatomic, weak) SLTopicVideoView *videoView;
/** 音频控件 */
@property (nonatomic, weak) SLTopicVoiceView *voiceView;
/** 视频控件 */
@property (nonatomic, weak) SLTopicPictureView *pictureView;

@end
// finder->前往->按住shift->显示资源库
/*
    Xcode插件安装路径：
    旧版本路径：1./Users/zhaohe/Library/Application Support/Developer/Shared/Xcode/Plug-ins(旧)
    新版本路径：2./Users/zhaohe/Library/Developer/Xcode/Plug-ins（新）
 */


@implementation SLTopicCell


- (SLTopicVideoView *)videoView
{
    if (!_videoView) {
        SLTopicVideoView* videoView = [SLTopicVideoView zh_viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}
- (SLTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        SLTopicVoiceView *voiceView = [SLTopicVoiceView zh_viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}
- (SLTopicPictureView *)pictureView
{
    if (!_pictureView) {
        SLTopicPictureView *pictureView = [SLTopicPictureView zh_viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setTopic:(SLTopic *)topic
{
    _topic = topic;
    
    // 设置顶部和底部控件的具体数据
    [self.profileImageView zh_setHeader:topic.profile_image];
    
    
    
    _nameLabel.text = topic.name;
    _passtimeLabel.text = topic.passtime;
    _text_label.text = topic.text;
    
    // 按钮底部文字
    [self setupButtonTitle:_dingButton number:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:_caiButton number:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:_repostButton number:topic.repost placeholder:@"转发"];
    [self setupButtonTitle:_commentButton number:topic.comment placeholder:@"评论"];
    
    // 最热评论
    if (topic.top_cmt.count) { // 最热评论
        self.topCmtView.hidden = NO;
        
        NSDictionary *cmt = topic.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if (content.length == 0) {
            content = @"【语音评论】";
        }
        
        NSString *username = cmt[@"user"][@"username"];
        
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@：%@", username, content];
    } else {
        self.topCmtView.hidden = YES;
    }
    
    // 中间内容
    if (topic.type == ZHTopicTypePicture) { // 图片
        
        [self.contentView addSubview:self.pictureView];
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = NO;
        
        self.pictureView.topic = topic;
        
    } else if (topic.type == ZHTopicTypeVoice) { // 声音

        [self.contentView addSubview:self.voiceView];
        self.videoView.hidden = YES;
        self.voiceView.hidden = NO;
        self.pictureView.hidden = YES;
        
        self.voiceView.topic = topic;
    } else if (topic.type == ZHTopicTypeVideo) { // 视频
        
        [self.contentView addSubview:self.videoView];
        self.videoView.hidden = NO;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
        self.videoView.topic = topic;
        
    } else if (topic.type == ZHTopicTypeWord) { // 段子
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }

}


/*
 [[SLVideoViewController alloc] init]
 1.SLVideoViewController.xib
 2.SLVideoView.xib
 
 
 报错信息： '-[UIViewController _loadViewFromNibNamed:bundle:] loaded the "SLVideoView" nib but the view outlet was not set.'
 错误原因：在使用xib创建View时，并没有通过File‘s Owner设置控制器View属性
 解决方案：通过File‘s Owner设置控制器View属性为某一个View
 
 报错信息：'-[UITableViewController loadView] loaded the "SLVideoView" nib but didn't get a UITableView.'
 报错原因： 在使用xib创建TableViewController的View时，并没有设置控制器的View为一个TableView
 解决方案：通过File‘s Owner设置控制器View属性为某一个TableView

 */

- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder
{
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%ld", number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 10;
    
    [super setFrame:frame];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 中间内容
    if (_topic.type == ZHTopicTypePicture) { // 图片
        _pictureView.frame = self.topic.middleFrame;
    } else if (_topic.type == ZHTopicTypeVoice) { // 声音
        _voiceView.frame = self.topic.middleFrame;
    } else if (_topic.type == ZHTopicTypeVideo) { // 视频
        _videoView.frame = self.topic.middleFrame;
    } else if (_topic.type == ZHTopicTypeWord) { // 段子

    }

    
}

@end
