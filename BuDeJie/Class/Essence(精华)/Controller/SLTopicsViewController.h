//
//  SLTopicsViewController.h
//  BuDeJie
//
//  Created by 赵鹤 on 2016/11/9.
//  Copyright © 2016年 SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLTopic.h"

@interface SLTopicsViewController : UITableViewController

/**
 帖子的类型
 */
//@property (nonatomic, assign) NSInteger type;
- (ZHTopicType)type;
@end
