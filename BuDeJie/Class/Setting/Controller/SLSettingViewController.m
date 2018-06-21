//
//  SLSettingViewController.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/9.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLSettingViewController.h"
#import <SDImageCache.h>
#import "SLFileTool.h"
#import <SVProgressHUD.h>
#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]


@interface SLSettingViewController ()
@property (nonatomic, assign) NSInteger totalSize;
@end

@implementation SLSettingViewController

static NSString * const ID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"title" style:0 target:self action:@selector(jump)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    [SVProgressHUD showWithStatus:@"正在计算缓存数据"];
    
    [SLFileTool getFileSize:CachePath completion:^(NSInteger totalSize) {
        
        NSLog(@"%@", [NSThread currentThread]);
        _totalSize = totalSize;
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    }] ;
}

- (void)jump
{
    UIViewController *VC = [[UIViewController alloc] init];
    VC.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 计算缓存数据, 计算整个应用程序缓存数据 => 沙盒(cache) => 获取cache文件夹
    
    // 获取Caches文件夹路径
    NSString *cachePath = CachePath;
    
    // 获取缓存尺寸字符串
    cell.textLabel.text = [self sizeStr:cachePath];
    
    return cell;
}

// 点击cell就会调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 清空缓存
    // 删除文件夹里面的文件
    [SLFileTool removeDirectoryPath:CachePath];
    
    _totalSize = 0;
    
    [self.tableView reloadData];
}

// 获取缓存尺寸字符串
- (NSString *)sizeStr:(NSString *)cachePath
{
    NSString *sizeStr = @"清除缓存";
    NSInteger totalSize = _totalSize;
    // MB KB B
    if (totalSize > 1000 * 1000) {
        // MB
        CGFloat sizeF = totalSize / (1000.0 * 1000.0);
        sizeStr = [NSString stringWithFormat:@"%@ %.1fMB", sizeStr, sizeF];
    } else if (totalSize > 1000) {
        // KB
        CGFloat sizeF = totalSize / (1000.0);
        sizeStr = [NSString stringWithFormat:@"%@ %.1fKB", sizeStr, sizeF];
    } else if (totalSize > 0) {
        // B
        sizeStr = [NSString stringWithFormat:@"%@ %ldB", sizeStr, totalSize];
    }
    return sizeStr;
}

/*
    1.业务类: 以后开发中专门处理某件事情,网络请求,缓存处理
    
 
 */


@end
