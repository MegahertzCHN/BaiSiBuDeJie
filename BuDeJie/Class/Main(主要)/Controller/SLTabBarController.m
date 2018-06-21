//
//  SLTabBarController.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/9/29.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLTabBarController.h"
#import "SLEssenceViewController.h"
#import "SLFriendTrendsViewController.h"
#import "SLMeViewController.h"
#import "SLPublishViewController.h"
#import "SLNewViewController.h"
#import "UIImage+Image.h"
#import "SLTabBar.h"
#import "SLNavigationController.h"

@interface SLTabBarController ()<UITabBarDelegate>

@end

@implementation SLTabBarController
// 只会调用一次
+ (void)load
{
    /*
     appearance:
     1.只要遵守UIAppearance协议,还要实现协议方法.
     2.哪些属性可以通过appearance设置,只有被UI_APPEARANCE_SELECTOOR宏修饰的属性,才能设置
     3.appearance:只能在控件显示之前设置,才有用.
     
     */
    
    
    
    // 获取整个应用程序下的UITabBarItem
    // UITabBarItem *item = [UITabBarItem appearance];
    
    // 获取那个类中的UITabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    
    // 创建一个描述文本属性的字典
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    // 设置按钮选中标题的颜色; 富文本:描述一个文字的颜色,字体,阴影,空心, 图文混排
    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    // 设置字体尺寸:只有正常状态下,才有效果.
    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
    attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    // 设置按钮选中标题的颜色; 富文本:描述一个文字的颜色,字体,阴影,空心, 图文混排
    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
}

// 注意:可能会调用多次
//+ (void)initialize
//{
//    if (self == [SLTabBarController class])
//    {
//        
//    }
//}



/*
 问题:
    1. 选中按钮的图片被渲染 --->iOS7以后 默认tabBar上的按钮都会被渲染 1.直接修改图片 2.通过代码 ✅
    2. 选中按钮的标题的颜色是黑色 标题字体大 -> 对应的子控制器的tabBarItem属性 ✅
    3. 发布的按钮显示不出来 => 图片能够显示出来,但是图片的位置不对 => 调整位置以后,发现图片不能够高亮的显示状态 => 加号按钮应该是普通按钮,高亮状态 => 
 
 
 
    4. 最终方案: 调整系统tabBar上按钮的位置,平均分成5等份,再把加号按钮显示在中间
    调整系统自带控件的子控件的位置 => 自定义tabBar
 
 
 
    解决:不能修改图片尺寸, 效果:让发布图片居中
 */

#pragma mark -  生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // 2.1添加子控制器(5) --> 自定义控制器 --> 划分项目文件结构
    [self setupAllChildViewController];
    
    // 2.2 设置tabBar上按钮内容 --> 又对应的子控制器的tabBarItem的属性
    [self setupAllButtonTitle];
    
    
    // 2.3 自定义tabBar
    [self setTabBar];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    NSLog(@"%@", self.tabBar.subviews);
//}

/// 自定义tabBar
- (void)setTabBar
{
    SLTabBar *tabBar = [[SLTabBar alloc] init];
    
    
    // 因为是readOnly, 所以我们需要等到更改 1.runtime 2.kvc
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    
    // self.tabBar.delegate = self;
    
}

/*
 'Changing the delegate of a tab bar managed by a tab bar controller is not allowed.'
 被TabBarController所管理的UITabBar的delegate是不被允许的
 */


#pragma mark - 添加所有的子控制器
- (void)setupAllChildViewController
{
    // 精华
    SLEssenceViewController *essenceVc = [[SLEssenceViewController alloc] init];
    // initWithRootViewController:push 放到栈顶
    SLNavigationController *nav = [[SLNavigationController alloc] initWithRootViewController:essenceVc];
    // tabBarVC:默认会把第0个子控制器的View添加去
    [self addChildViewController:nav];
    
    // 新帖
    SLNewViewController *newVc = [[SLNewViewController alloc] init];
    SLNavigationController *nav1 = [[SLNavigationController alloc] initWithRootViewController:newVc];
    // tabBarVC:默认会把第1个子控制器的View添加去
    [self addChildViewController:nav1];
    
//    // 发布
//    SLPublishViewController *publishVc = [[SLPublishViewController alloc] init];
//    // tabBarVC:默认会把第2个子控制器的View添加去
//    [self addChildViewController:publishVc];
    
    // 关注
    SLFriendTrendsViewController *friendTrendsVc = [[SLFriendTrendsViewController alloc] init];
    SLNavigationController *nav3 = [[SLNavigationController alloc] initWithRootViewController:friendTrendsVc];
    // tabBarVC:默认会把第3个子控制器的View添加去
    [self addChildViewController:nav3];
    
    // 我
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([SLMeViewController class]) bundle:nil];
    // 加载箭头指向控制器
    SLMeViewController *meVc = [storyBoard instantiateInitialViewController];
    SLNavigationController *nav4 = [[SLNavigationController alloc] initWithRootViewController:meVc];
    // tabBarVC:默认会把第4个子控制器的View添加去
    [self addChildViewController:nav4];
    
    
}
/*
    1.改插件 -> 如何寻找插件 ->插件开发知识 -> 插件代码肯定有个地方指定安装在什么地方
    1.打开插件 2.搜索plug 3.就能找到安装的路径
 */

// 设置tabBar上所有按钮的内容
- (void)setupAllButtonTitle
{
    // 2.2 设置tabBar上按钮内容 --> 又对应的子控制器的tabBarItem的属性
    // 0:nav
    UINavigationController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"精 华";
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    // 快速生成一个没有渲染的图片
    nav.tabBarItem.selectedImage = [UIImage imgeOriginalWithName:@"tabBar_essence_click_icon"];
    
    // 1:nav1
    UINavigationController *nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"新 帖";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    nav1.tabBarItem.selectedImage = [UIImage imgeOriginalWithName:@"tabBar_new_click_icon"];
    
    // 2:publish 发布
    UIViewController *publishVc = [[UIViewController alloc] init];
    publishVc.tabBarItem.image = [UIImage imgeOriginalWithName:@"tabBar_publish_icon"];
    publishVc.tabBarItem.selectedImage = [UIImage imgeOriginalWithName:@"tabBar_publish_click_icon"];
    
    publishVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    // 3:nav3 关注
    UINavigationController *nav3 = self.childViewControllers[2];
    nav3.tabBarItem.title = @"关 注";
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    nav3.tabBarItem.selectedImage = [UIImage imgeOriginalWithName:@"tabBar_friendTrends_click_icon"];
    
    // 4:nav4 我
    UINavigationController *nav4 = self.childViewControllers[3];
    nav4.tabBarItem.title = @"我";
    nav4.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    nav4.tabBarItem.selectedImage = [UIImage imgeOriginalWithName:@"tabBar_me_click_icon"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
