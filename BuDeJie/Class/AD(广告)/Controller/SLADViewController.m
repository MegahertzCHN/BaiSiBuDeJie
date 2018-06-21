//
//  SLADViewController.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/9.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLADViewController.h"
#import <AFNetworking.h>
#import "SLADItem.h"
#import <MJExtension/MJExtension.h>
#import <UIImageView+WebCache.h>
#import "SLTabBarController.h"

#define code2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"

@interface SLADViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) UIImageView *adView;
@property (nonatomic, strong) SLADItem *item;
@property (nonatomic, weak) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *jump;
@end

@implementation SLADViewController

- (UIImageView *)adView
{
    if (_adView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        [self.containView addSubview:imageView];
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [imageView addGestureRecognizer:tap];
        
        _adView = imageView;
    }
    return _adView;
}

// 点击广告界面
- (void)tap
{
    // 跳转到界面 => safari
    NSURL *url = [NSURL URLWithString:_item.ori_curl];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置启动图片
    [self setupLaunchImageView];
    
    // 加载广告数据 => 拿到活的数据 => 服务器 => 接口文档 1.判断接口对不对 2.解析数据(w_picurl, ori_curl, w, h) => 请求数据(AFN)
    
    // 导入AFN框架: cocoapods
    // cocoapods: 管理第三方库  cocoapods做的事情: 导入一个框架,就会这个框架所有依赖的所有的框架都会导入
    // cocoapods:
    // 1.profile:描述,需要导入哪些框架 touch podfile(cd 工程文件路径有蓝色小图标 ls -l 进入到当前文件夹 然后 touch podfile)
    // 2.打开podfile 描述: open podfile
    // 3.搜索需要导入框架的描述: pod search
    // 4.安装第三方框架: pod install
    // 5.只能用BuDeJie.xcworkspace打开
    
    // --no-repo-update:   Skip running `pod repo update` before install
    // Podfile.lock: 第一次Pod就会自动生成这个文件, 用来描述当前导入框架的版本号
    // pod install:  根据Podfile.lock去加载. 第一次会根据Podfile文件去加载.
    // pod update:   去查看之前导入的框架有没有新的版本,如果有新的版本就回去加载,并且更新Podfile.lock
    // pod repo:     管理第三方仓库的索引,去寻找框架有没有最新的版本,有就记录下来
    
    
    [self loadAdData];
    
    
    // 创建定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerChange) userInfo:nil repeats:YES];
    
}

- (void)timerChange
{
    ZHFunc;
    // 倒计时
    static int i = 3;
    
    if (i == 0) {
        [self clickJump:nil];
    }
    // 设置跳转按钮
    // 按钮存在一闪一闪的现象,将按钮的类型从system改成Custom
    [_jump setTitle:[NSString stringWithFormat:@"跳过 (%d)", i] forState:UIControlStateNormal];
    
    i--;
}

// 点击按钮跳过做的事情
- (IBAction)clickJump:(UIButton *)sender {
    // 销毁广告界面,进入主框架界面 1.push 2.model 3.修改窗口根控制器
    SLTabBarController *tabBar = [[SLTabBarController alloc] init];
    [UIApplication sharedApplication] .keyWindow.rootViewController = tabBar;
    // 销毁定时器
    [_timer invalidate];
}

/*
    1.以后添加东西,首先想到的是加多少次
 */

#pragma mark - 加载广告数据
- (void)loadAdData
{
    // unacceptable content-type: text/html 响应头
    
    // http请求: 请求头+请求体
    // 请求头: 告诉服务器,客户端支持哪些可视,json,html
    // 请求体: post请求
    
    
    // 相应: 响应头, 相应体
    // 响应头: content-type: 描述服务器给你数据的格式
    // 响应体: 数据
    
    
    // 1. 创建会话请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code2"] = code2;
    // 2. 发送请求
    [mgr  GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        // 请求数据 -> 解析数据(写成plist文件) -> 设计模型 -> 字典转模型 -> 展示数据
        
        [responseObject writeToFile:@"/Users/zhaohe/Desktop/Personal/Personal_Learn/iOS_File/OC_File/06-OC项目/Day-01/03-环境部署/ad.plist" atomically:YES];
        
        
        // 获取字典
        NSMutableDictionary *adDic = [responseObject[@"ad"] lastObject];
        
        // 字典转模型
        _item = [SLADItem mj_objectWithKeyValues:adDic];
        
        
        
        // 创建UIImageView展示图片
        CGFloat h = SLScreenW / _item.w * _item.h;
        self.adView.frame = CGRectMake(0, 0, SLScreenW, h);
        
        // 加载广告数据
        [self.adView sd_setImageWithURL:[NSURL URLWithString:_item.w_picurl]];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    
}

// 设置启动图片
- (void)setupLaunchImageView
{
    // 6p:LaunchImage-800-Portrait-736h@3x
    // 6:LaunchImage-800-667h@2x
    // 5:LaunchImage-568h@2x
    // 4:LaunchImage@2x
    
    if (iPhone6p) { // 6p
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    } else if (iPhone6) { // 6
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-667h@2x"];
    } else if (iPhone5) { // 5
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-568h@2x"];
    } else if (iPhone4) { // 4
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage@2x"];
    }
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
