//
//  SLSubTagViewController.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/10.
//  Copyright © 2016年 SL. All rights reserved.
//




#import "SLSubTagViewController.h"
#import <AFNetworking.h>
#import "SLSubTagItem.h"
#import <MJExtension/MJExtension.h>
#import "SLSubTagCell.h"
#import <SVProgressHUD.h>
#import "SLRefreshHeader.h"
// 全局
static NSString * const ID = @"cell";

@interface SLSubTagViewController ()
@property (nonatomic, strong) NSMutableArray *subTags;
@property (nonatomic, weak) AFHTTPSessionManager *mgr;


@end

@implementation SLSubTagViewController
// 接口文档: 请求url(基本的url+请求的参数) 请求方式
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 展示标签数据 -> 请求数据(接口文档) -> 解析数据(写成Plist)( image_list, theme_name sub_number) -> 设计模型 -> 字典转模型 -> 展示数据
    
    [self loadData];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SLSubTagCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    
    self.title = @"推荐标签";
    
    // 处理分割线 1.自定义分割线(自定义View) 2.系统属性(iOS8才支持) 3.万能公式(重写cell的setFrame方法) 了解TableView的底层实现 1.取消系统自带分割线 2.把tableView背景色设置为分割线的背景色 3.重写setFrame
    // 2.系统属性
    // 1.清空tableView分割线内边距 2.清空cell约束的边缘
    // self.tableView.separatorInset = UIEdgeInsetsZero;
    
    // 3.tableView底层实现
    // 1.首先把所有的cell的位置全部计算好,保存起来
    // 2.当cell要显示的时候,就会拿到这个cell去设置frame cell.frame = self.frames[row]
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 220 220 221
    self.tableView.backgroundColor = ZHColor(220, 220, 221);
    
    // 提示用户当前正在加载数据 SVPro
    [SVProgressHUD showWithStatus:@"正在加载数据"];
    
    [self setupRefresh];
    
}

- (void)setupRefresh
{
    // header
    self.tableView.mj_header = [SLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    // 让header进入自动刷新
    [self.tableView.mj_header beginRefreshing];
    
    // footer
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        ZHLog(@"上拉加载更所数据...");
//    }];
}



#pragma mark - 请求数据
- (void)loadData
{
    // 1.创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    _mgr = mgr;
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tag_recommend";
    parameters[@"action"] = @"sub";
    parameters[@"c"] = @"topic";
    
    // 3.发送请求
    [mgr GET:SLCommonUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        [responseObject writeToFile:@"/Users/zhaohe/Desktop/Personal/Personal_Learn/iOS_File/OC_File/06-OC项目/Day-01/03-环境部署/tag.plist" atomically:YES];
        
        // 字典数据转换成模型数据
        _subTags =  [SLSubTagItem mj_objectArrayWithKeyValuesArray:responseObject];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
    
}



// 界面即将消失的时候
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    // 销毁计时器
    [SVProgressHUD dismiss];
    
    // 取消之前的请求
    [_mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _subTags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLSubTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    SLSubTagItem *item = _subTags[indexPath.row];
    cell.item = item;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
