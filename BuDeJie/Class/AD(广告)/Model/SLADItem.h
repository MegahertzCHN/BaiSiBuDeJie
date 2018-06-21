//
//  SLADItem.h
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/10.
//  Copyright © 2016年 SL. All rights reserved.
//

#import <Foundation/Foundation.h>
// (w_picurl, ori_curl, w, h)
@interface SLADItem : NSObject

/*广告的地址*/
@property (nonatomic, strong) NSString *w_picurl;

/// 点击广告跳转的界面
@property (nonatomic, strong) NSString *ori_curl;


/// 图片的宽度
@property (nonatomic, assign) CGFloat w;


/// 图片的高度
@property (nonatomic, assign) CGFloat h;



@end
