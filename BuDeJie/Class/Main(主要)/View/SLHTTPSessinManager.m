//
//  SLHTTPSessinManager.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/11/12.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLHTTPSessinManager.h"

@implementation SLHTTPSessinManager

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    // 每次发请求的时候都会带着请求头的信息
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:[UIDevice currentDevice].model forHTTPHeaderField:@"Phone"];
        [self.requestSerializer setValue:[UIDevice currentDevice].systemVersion forHTTPHeaderField:@"OS"];
    }
    return self;
}

@end
