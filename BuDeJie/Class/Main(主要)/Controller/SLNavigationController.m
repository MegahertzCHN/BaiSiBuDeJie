//
//  SLNavigationController.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/9.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLNavigationController.h"

@interface SLNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation SLNavigationController

+ (void)load
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 只要通过模型设置,都是通过富文本设置
    // 设置导航条标题 => navigationBar
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [navBar setTitleTextAttributes:attr];
    
    // 设置导航条的背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    
}

// <_UINavigationInteractiveTransition: 0x7f8370d0cc70>
// UIPanGestureRecognizer 全屏滑动手势
// UIScreenEdgePanGestureRecognizer 导航控制器滑动手势
// <UIScreenEdgePanGestureRecognizer: 0x7f8370e08ae0; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7f8370d0ef50>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7f8370e056c0>)>>

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    
    // 假死状态: 程序还在运行,但是界面死了
    // 控制手势,什么时候去触发(只有在非根控制器的时候才能触发)
    pan.delegate = self;
    
    // 禁止之前的手势 delegate不能少
    self.interactivePopGestureRecognizer.enabled = NO;
    
    /*
        1.为什么导航控制器手势不是全屏滑动 =>
        2.
     
     */
    //    self.interactivePopGestureRecognizer.delegate = self;
 
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 非根控制器
        // 恢复滑动返回功能 -> 分析:把系统的返回按钮覆盖 -> 1.手势失效(1.手势被清空了 2.可能手势的代理做一些事情,导致手势失效)
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(back) tittle:@"返回"];
        
    }
    

    
    // 真正的跳转
    [super pushViewController:viewController animated:animated];
}


#pragma mark - 返回按钮
- (void)back
{
    [self popViewControllerAnimated:YES];
}



#pragma mark - UIGestureRecognizerDelegate
// 决定是否触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.childViewControllers.count > 1;
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
