//
//  SLTopicCell.h
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/26.
//  Copyright © 2016年 SL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLTopic;

@interface SLTopicCell : UITableViewCell

/**
 模型数据
 */
@property (nonatomic, strong) SLTopic *topic;
@end
