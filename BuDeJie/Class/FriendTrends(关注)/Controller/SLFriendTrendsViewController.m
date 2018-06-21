//
//  SLFriendTrendsViewController.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/9/29.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLFriendTrendsViewController.h"
#import "SLLoginRegisterViewController.h"
@interface SLFriendTrendsViewController ()

@end

@implementation SLFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
}

#pragma mark - 设置导航条
- (void)setupNavBar
{
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"friendsRecommentIcon"] highImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(friendsRecomment)];
    // titleView
    self.navigationItem.title = @"我的关注";
}

// 点击登录注册就会调用
- (IBAction)clickLoginRegister:(UIButton *)sender {
    SLLoginRegisterViewController *loginVc = [[SLLoginRegisterViewController alloc] init];
    [self presentViewController:loginVc animated:YES completion:nil];
}

// 推荐关注
- (void)friendsRecomment
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
