//
//  SLNewViewController.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/9/29.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLNewViewController.h"
#import "SLSubTagViewController.h"
@interface SLNewViewController ()

@end

@implementation SLNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    [self setupNavBar];
}

#pragma mark - 设置导航条
- (void)setupNavBar
{
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"MainTagSubIcon"] highImage:[UIImage imageNamed:@"MainTagSubIconClick"] target:self action:@selector(tagClick)];
    // titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}

#pragma mark - 点击订阅标签
- (void)tagClick
{
    // 进入推荐标签页面
    SLSubTagViewController *subTagVc = [[SLSubTagViewController alloc] init];
    [self.navigationController pushViewController:subTagVc animated:YES];
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
