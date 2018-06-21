//
//  SLTopicsViewController.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/21.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLTopicsViewController.h"
#import <AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "SLTopic.h"
#import <SVProgressHUD.h>
#import "SLTopicCell.h"
#import <SDImageCache.h>
#import "SLRefreshHeader.h"
#import "SLShaLouGifHeader.h"
#import "SLDuanZiRefrshGifHeader.h"

@interface SLTopicsViewController ()

/** 用来缓存cell高度（key：模型数据 value：cell高度） */
//@property (nonatomic, strong) NSMutableDictionary *cellHeightDict;

/// 所有的帖子数据
@property (nonatomic, strong) NSMutableArray<SLTopic *> *topics;
/// 页码
@property (nonatomic, assign) NSUInteger page;
/// 当前最后一条帖子数据的描述信息，专门用来加载下一页数据
@property (nonatomic, copy) NSString *maxtime;

/** 请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation SLTopicsViewController

static NSString * const SLTopicCellId = @"SLTopicCellId";


/**  在这里实现type方法，仅仅是为了消除警告  */
- (ZHTopicType)type  {return 0;}

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZHColor(206, 206, 206);
    self.tableView.contentInset = UIEdgeInsetsMake(ZHNavMaxY + ZHTitleViewH, 0, ZHTabBarH, 0);
    self.tableView.scrollIndicatorInsets  = self.tableView.contentInset;
    self.tableView.rowHeight = 200;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([SLTopicCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:SLTopicCellId];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarBottomDidRepeatClick) name:SLTabBarBarTemDidRepeatClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBottomDidRepeatClick) name:SLTittleButtonDidRepeatClickedNotification object:nil];
    
    [self setupRefresh];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setupRefresh
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 0, 30);
    label.text = @"广告";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = label;
    
    
    // header
//    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    SLDuanZiRefrshGifHeader *gifHeader = [SLDuanZiRefrshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    self.tableView.mj_header = gifHeader;
    // 让header进入自动刷新
    [self.tableView.mj_header beginRefreshing];
    
    

    
    // footer
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

#pragma mark - 监听
/// 监听tabBarButton重复点击
- (void)tabBarBottomDidRepeatClick
{
    //  if (重复点击的不是精华) return
    if (self.view.window == nil) return;
    
    // if（显示正中间的不是SLTopicsViewController）return;
    if (self.tableView.scrollsToTop == NO) return;
    
    // 进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

/// 监听titleButton重复点击
- (void)titleBottomDidRepeatClick
{
    [self tabBarBottomDidRepeatClick];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 根据数据数量来显示或隐藏footer
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLTopicCell *cell =  [tableView dequeueReusableCellWithIdentifier:SLTopicCellId];
    cell.topic = self.topics[indexPath.row];
    return cell;
}



#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.topics[indexPath.row].cellHeight;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 清除内存中的缓存
    [[SDImageCache sharedImageCache] clearMemory];
}


/// 发送请求给服务器，下拉刷新数据
- (void)loadNewTopics
{

    // 1.取消之前的请求
    // [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // [self endFooterRefreshing];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // 2.拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type); // 这里发送@1也是可以的
    
    
//    NSString *myString = [self dictionaryToJson:parameters];
    NSString *str = @"http://debug.yikuaihai.cn";
    
    
    
    [self.manager POST:str parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    // 3.发送请求
    [self.manager GET:SLCommonUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数据
        self.topics = [SLTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        
        NSLog(@"%@", error);
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}




/// 发送请求给服务器，上拉加载更多
- (void)loadMoreTopics
{
    // 1. 取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 2.拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type); // 这里发送@1也是可以的
    parameters[@"maxtime"] = self.maxtime;

    
    // 3.发送请求
    [self.manager GET:SLCommonUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数据
        NSMutableArray *moreTopics = [SLTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 累加到旧数组的后面
        [self.topics addObjectsFromArray:moreTopics];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
//        if (self.topics.count >= 60) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        } else {
            [self.tableView.mj_footer endRefreshing];
//        }
     
        
        // 清楚之前计算的高度
        // [self.cellHeightDict removeAllObjects];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) { // 并非是取消任务导致的error，其他的问题导致的error
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试..."];
        }
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

@end
