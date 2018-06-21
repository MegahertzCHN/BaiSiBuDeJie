//
//  SLMeViewController.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/9/29.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLMeViewController.h"
#import "SLSettingViewController.h"
#import <AFNetworking.h>
#import "SLSquareItem.h"
#import <MJExtension/MJExtension.h>
#import "SLSquareCell.h"
#import <SafariServices/SafariServices.h>
#import "SLWebViewController.h"
/*
    搭建基本结构 -> 设置底部条 -> 设置顶部条 -> 设置顶部条标题字体 -> 处理导航控制器的业务逻辑(跳转)
 
 
 */


@interface SLMeViewController () <UICollectionViewDelegate, UICollectionViewDataSource >
@property (nonatomic, strong) NSMutableArray *squareItems;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

static NSString * const ID = @"item";
static NSInteger cols = 4;
static CGFloat margin = 1;
#define itemWH (SLScreenW - (cols - 1) * margin) / cols

@implementation SLMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
    [self setupNavBar];
    
    // 设置tableView底部视图
    [self setupFooterView];
    
    // 展示方块内容 -> 请求数据
    [self loadData];
    
    /*
        跳转细节
        1. collectionView高度需要从新计算 ==> collectionView高度需要内容去计算  ==> 有数据 需要重新计算下高度
        2. collectionView不需要滚动
     */
    
    // 处理cell间距 默认tableView分组样式,有头部和尾部的间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = ZHMargin;
    self.tableView.contentInset = UIEdgeInsetsMake(ZHMargin - 35, 0, 0, 0);
    
    // 隐藏导航栏
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
}

// 打印cell的y值
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // NSLog(@"%@", NSStringFromCGRect(cell.frame));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarBottomDidRepeatClick) name:SLTabBarBarTemDidRepeatClickedNotification object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听
/// 监听tabBarButton重复点击
- (void)tabBarBottomDidRepeatClick
{
    if (self.view.window == nil) return;
    ZHFunc
}

// 请求数据
- (void)loadData
{
    // 1.创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    // 3.发送请求
    [mgr GET:SLCommonUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        [responseObject writeToFile:@"/Users/zhaohe/Desktop/Personal/Personal_Learn/iOS_File/OC_File/06-OC项目/Day-01/03-环境部署/me.plist" atomically:YES];
        
        NSArray *dicArr = responseObject[@"square_list"];
        
        // 字典数组 转换为 模型数组
        _squareItems = [SLSquareItem mj_objectArrayWithKeyValuesArray:dicArr];
        
        // 处理数据
        [self resloveData];
        
        // 设置collectionView高度 计算collectionView高度 = rows * itemWH
        // rows = (count - 1) / cols + 1
        NSInteger rows = (_squareItems.count - 1) / cols + 1;
        // 设置collectionView高度
        self.collectionView.zh_height = rows * itemWH + 2;
        
        // 设置Tableview的滚动范围
        //        self.tableView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.collectionView.frame));
        self.tableView.tableFooterView = self.collectionView;
        
        // 刷新表格
        [_collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - 处理请求完成的数据
- (void)resloveData
{
    // 判断下缺几个
    // 3 % 4 = 3   cols - 3 = 1;
    // 5 % 4 = 1   cols - 1 = 3;
    NSInteger count = self.squareItems.count;
    NSInteger exter = count % cols;
    if (exter) {
        exter = cols - exter;
        for (int i = 0; i < exter; i++) {
            SLSquareItem *item = [[SLSquareItem alloc] init];
            [self.squareItems addObject:item];
        }
    }
    
}

#pragma mark - 设置tableView底部视图
- (void)setupFooterView
{
    /*
     1.初始化要设置流水布局
     2.cell要自定义
     3.cell要自定义
     */
    // 创建布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置cell尺寸
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    
    // 默认有行间距,调整行间距
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    
    // 创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:layout];
    collectionView.backgroundColor = self.tableView.backgroundColor;
    self.tableView.tableFooterView = collectionView;
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    collectionView.scrollEnabled = NO;
    
    _collectionView = collectionView;
    
    // 注册
    // [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    
    [collectionView registerNib:[UINib nibWithNibName:@"SLSquareCell" bundle:nil] forCellWithReuseIdentifier:ID];
}

#pragma mark - UICollectionView的delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 跳转界面 push 界面
    /*
        1.Safari openURL:自带很多功能(进度条, 刷新, 前进, 倒退), 必须跳出当前应用
        2.UIWebView(没有功能):在当前应用打开网页,并且有safari,自己实现,UIWebView不能实现进度条
        3.SFSafariViewController: 专门用来展示网页 需求:既想要在当前应用展示网页,又想要safari的功能 iOS9才能使用
        4.WKWebView: iOS8 (UIWebView升级版本,添加功能 1.监听进度 2.缓存)
        4.1 导入:#import <WebKit/WebKit.h>

     1.导入#import <SafariServices/SafariServices.h>
     */

    SLSquareItem *item = _squareItems[indexPath.row];
    if (![item.url containsString:@"http"]) return;
    NSURL *url = [NSURL URLWithString:item.url];
    
    // SFSafariViewController 推荐我们使用Modal
//    SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:url];
//    self.navigationController.navigationBarHidden = YES;
//    safariVc.delegate = self;
//    [self.navigationController pushViewController:safariVc animated:YES];
//    [self.navigationController presentViewController:safariVc animated:YES completion:nil];
    
    SLWebViewController *webVc = [[SLWebViewController alloc] init];
    webVc.url = url;
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma mark - SFSafariViewControllerDelegate
//- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller
//{
////    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - UICollectionView的dateSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _squareItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 从缓存池中取
    SLSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.item = _squareItems[indexPath.row];
    return cell;
}


#pragma mark - 设置导航条
- (void)setupNavBar
{
    // 设置
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(setting)];
    // 夜间
    UIBarButtonItem *nightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night:)];

    
    self.navigationItem.rightBarButtonItems = @[settingItem, nightItem];
    // titleView
    self.navigationItem.title = @"我的";
    

}

// 夜间模式
- (void)night:(UIButton *)button
{
    button.selected = !button.selected;
}

// 设置按钮
- (void)setting
{
    // 跳转到设置界面
    SLSettingViewController *settingVC = [[SLSettingViewController alloc] init];
    // 必须要在跳转之前去设置
    settingVC.hidesBottomBarWhenPushed = YES;
    
    
    [self.navigationController pushViewController:settingVC animated:YES];
    
    
    /*
        1.底部导航条没有隐藏
        2.处理返回按钮样式 1.去设置控制器界面
     */
    
}


@end
