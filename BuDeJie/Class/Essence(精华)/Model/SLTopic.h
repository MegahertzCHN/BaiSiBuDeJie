//
//  SLTopic.h
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/25.
//  Copyright © 2016年 SL. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum {
//    /** 全部 */
//    ZHTopicTypeAll = 1,
//    /** 图片 */
//    ZHTopicTypePicture = 10,
//    /** 段子 */
//    ZHTopicTypeWord = 29,
//    /** 声音 */
//    ZHTopicTypeVoice = 31,
//    /** 视频 */
//    ZHTopicTypeVideo = 41
//} ZHTopicType;

typedef NS_ENUM(NSUInteger, ZHTopicType) {
    /** 全部 */
    ZHTopicTypeAll = 1,
    /** 图片 */
    ZHTopicTypePicture = 10,
    /** 段子 */
    ZHTopicTypeWord = 29,
    /** 声音 */
    ZHTopicTypeVoice = 31,
    /** 视频 */
    ZHTopicTypeVideo = 41
};


@interface SLTopic : NSObject
/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *passtime;

/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;


/** 帖子的类型 10为图片 29为段子 31为音频 41为视频*/
@property (nonatomic, assign) NSUInteger type;

/** 宽度(像素) */
@property (nonatomic, assign) NSUInteger width;

/** 高度(像素) */
@property (nonatomic, assign) NSUInteger height;

/** 最热评论 */
@property (nonatomic, strong) NSArray *top_cmt;

/** 额外增加的属性（并非服务器返回的属性 仅仅是为了提高开发效率）*/
/**
 根据当前模型计算出来的cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;


/**
 中间内容的frame
 */
@property (nonatomic, assign) CGRect middleFrame;

/** 小图 */
@property (nonatomic, copy) NSString *image0;
/** 中图 */
@property (nonatomic, copy) NSString *image2;
/** 大图 */
@property (nonatomic, copy) NSString *image1;

/** 音频时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 视频时长 */
@property (nonatomic, assign) NSInteger videotime;
/** 音频\视频的播放次数 */
@property (nonatomic, assign) NSInteger playcount;


/** 是不是gif图片 */  
@property (nonatomic, assign) BOOL is_gif;

/** 是否是大图片 */
@property (nonatomic, assign) BOOL isBigPicture;
@end
