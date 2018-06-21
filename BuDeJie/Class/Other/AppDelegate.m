//
//  AppDelegate.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/9/28.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "AppDelegate.h"
#import "SLTabBarController.h"
#import "SLADViewController.h"
#import <AFNetworking.h>

/*
    刚把Xcode更新到最新的8，一运行发现好多log输出，根据如下操作可以关掉这些log日志，点击项目
    Edit Scheme - Run - Arguments - Environment Variables里添
    Name:OS_ACTIVITY_MODE  Value：disable
 */

/*
    优先级:LaunchScreen > LainchImage
    在Xcode中配置了,不起作用, 1.清空缓存, 2.直接删掉程序,重新运行(更换模拟器)
    如果是通过LaunchImage设置启动界面,那么屏幕的可视范围有图片决定
    注意:如果使用LaunchImage,必须让设计师提供各种尺寸的启动图片
 
 
    LaunchScreen:Xcode6开始才有
    LaunchScreen优点:1.自动识别当前模拟器或真机的尺寸 
                    2.只要让设计师提供一个可拉伸的图片
                    3.展示更多的东西
 
    LaunchScreen底层实现:把LaunchScreen截屏,生成一张图片,作为启动界面
 */

/*
    项目架构(结构)搭建: 主流结构(UITabBarController + 导航控制器)
    -->项目开发方式:1.storyBoard, 2.纯代码
    UI层(展示层,业务层)  数据层  请求层
 */

// 每次程序启动的时候进入广告界面
// 1.启动的时候,去广告界面
// 2.启动完成的时候,加上广告界面(展示了启动图片)
/*
    1.程序一启动就进入广告界面,窗口的根控制器设置为广告控制器
    2.直接往窗口上再加上广告界面,等过几秒以后,将广告界面移除
 */

@interface AppDelegate ()

@end

@implementation AppDelegate

// 指定一个类:1.管理自己的业务
// 封装:谁的事情谁管理 == 方便以后去维护代码


#pragma mark - 监听点击状态栏
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches.anyObject locationInView:nil].y <= 20) {
        ZHLog(@"点击了状态栏");
    }
}

#pragma mark - <UIApplicationDelegate>
// 程序启动的时候就会调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 2.创建根控制器
//    SLADViewController *adVc = [[SLADViewController alloc] init];
    // init -> initWithNibName 1.首先判断有没有指定nibName 2.判断有没有和类名同名xib
    
//    SLTabBarController *tabBarVC = [[SLTabBarController alloc] init];
//    self.window.rootViewController = adVc;
    self.window.rootViewController = [[SLTabBarController alloc] init];
    

    
    
    // 3.显示窗口
    // 3.1 成为UIApplication主窗口
    // 3.2
    [self.window makeKeyAndVisible];
    
    // 4.开始监控网络状况
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 5.每次启动应用程序，都清除过期的图片
    [[SDImageCache sharedImageCache] cleanDisk];

    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
