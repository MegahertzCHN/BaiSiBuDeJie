//
//  SLEssenceViewController.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/9/29.
//  Copyright © 2016年 SL. All rights reserved.
//

// 联动


/*
 参数名字叫做attributes并且是NSDirctionary *类型的参数，它的key一般都有以下规律
 1.iOS7 开始：
 1> 所有的key都来源于： NSAttributedString.h
 2> 格式基本都是： NS***AttributeName
 
 2.iOS7 之前
 1> 所有的key都来源于： UIStringDrawing.h
 2> 格式基本都是： UITextAttribute***
 */

/*
 cell的全屏穿透效果：
 1.tableView的尺寸必须要占据整个屏幕
 2.通过设置tableview的contentInset（内边距），防止挡住导航栏或者tabBar，而不是ScrollView的内边距
 */


#import "SLEssenceViewController.h"
#import "SLTitleButton.h"

#import "SLAllViewController.h"
#import "SLVideoViewController.h"
#import "SLVoiceViewController.h"
#import "SLPictureViewController.h"
#import "SLWordViewController.h"

#import "SLTopic.h"

@interface SLEssenceViewController ()<UIScrollViewDelegate>
/// 用来存放所有子控制器view的ScrollView
@property (nonatomic, strong) UIScrollView *scrollView;
/// 标题栏
@property (nonatomic, strong) UIView *titleView;
/// 记录上一次点击的标题按钮
@property (nonatomic, weak) UIButton *previousClickedTitleButton;
/// 下划线
@property (nonatomic, strong) UIView *titleUnderLine;
@end

@implementation SLEssenceViewController
// UIBarButtonItem: 描述按钮具体是什么内容
// navigationItem: 设置导航条上的内容(左边 右边 中间)
// UITabBarItem: 用来设置tabBar按钮上的内容(tabBarButton)

/*
    一、按钮的状态
    1.UIControlStateNormal
    1> 除开UIControlStateHighlighted,UIControlStateDisabled,UIControlStateSelected以外的其他情况,其他的都是normal
    2> 这种状态下的按钮【可以】接受点击事件
 
    2.UIControlStateHighlighted
    1> 【当按住【按钮】不松开时】或者【highlighted = YES】 时就可以达到这种状态
    2> button.highlighted = YES;
    3> 这种状态下的按钮【可以】接受点击事件
 
    3.UIControlStateDisabled
    1> 【button.enabled = NO】时就可以达到这种状态
    2> 这种状态下的按钮【无法】接受点击事件
 
    4.UIControlStateSelected
    1> 【titleBtn.selected = YES】 时就可以达到这种状态
    2> 这种状态下的按钮【可以】接受点击事件
 
    二、让按钮无法点击的2种状态
    1.button.enabled = NO; 
    【会】进入UIControlStateDisabled状态
    2.button.userInteractionEnabled = NO;  
    【不会】进入UIControlStateDisabled状态，继续保持当前状态
 */



#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    // 初始化子控制器
    [self setupAllChildVcs];
    
    
    [self setupNavBar];
    
    // scrollView
    [self setupScrollView];
    
    // 标题栏
    [self setupTitlesView];
    
    // 添加第0个子控制器的View
    [self addChildVcViewIntoScrollView:0];
}

/// 初始化子控制器
- (void)setupAllChildVcs
{
    [self addChildViewController:[[SLAllViewController alloc] init]];
    [self addChildViewController:[[SLVideoViewController alloc] init]];
    [self addChildViewController:[[SLVoiceViewController alloc] init]];
    [self addChildViewController:[[SLPictureViewController alloc] init]];
    [self addChildViewController:[[SLWordViewController alloc] init]];
    
//    SLAllViewController *all = [[SLAllViewController alloc] init];
//    all.type = ZHTopicTypeAll;
//    [self addChildViewController:all];
//    
//    SLVideoViewController *video = [[SLVideoViewController alloc] init];
//    video.type = ZHTopicTypeVideo;
//    [self addChildViewController:video];
//    
//    SLVoiceViewController *voice = [[SLVoiceViewController alloc] init];
//    voice.type = ZHTopicTypeVoice;
//    [self addChildViewController:voice];
//    
//    SLPictureViewController *picture = [[SLPictureViewController alloc] init];
//    picture.type = ZHTopicTypePicture;
//    [self addChildViewController:picture];
//    
//    SLWordViewController *word = [[SLWordViewController alloc] init];
//    word.type = ZHTopicTypeWord;
//    [self addChildViewController:word];
}


/// 设置导航条
- (void)setupNavBar
{
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(game)];
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:nil action:nil];
    // titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}



/// ScrollView
- (void)setupScrollView
{
    // 不允许自动修改ScrollView内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor greenColor];
    scrollView.frame = self.view.bounds;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.scrollsToTop = NO;  // 点击状态栏的时候，这个scrollView不会滚动到最顶部
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    
    NSUInteger count = self.childViewControllers.count;
    CGFloat scrollViewW = scrollView.zh_width;
//    CGFloat scrollViewH = scrollView.zh_height;
//    
//    for (NSUInteger i = 0; i < count; i++) {
//        // 取出i位置子控制器的View
//        UIView *childVcView = self.childViewControllers[i].view;
//        childVcView.frame = CGRectMake(scrollViewW * i, 0, scrollViewW, scrollViewH);
//        [scrollView addSubview:childVcView];
//        
//        ZHLog(@"%@", NSStringFromCGRect(childVcView.frame));
//    }
    
    scrollView.contentSize = CGSizeMake(scrollViewW * count, 0);
}

/// 标题栏
- (void)setupTitlesView
{
    UIView *titlesView = [[UIView  alloc] init];
    // 设置半透明背景色
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    titlesView.frame = CGRectMake(0, 64, self.view.zh_width, 35);
    [self.view addSubview:titlesView];
    self.titleView = titlesView;
    
    // 标题栏按钮
    [self setupTitleButton];
    
    // 标题栏下划线
    [self setupTitleUnderline];
}

/// 标题栏按钮
- (void)setupTitleButton
{
    // 文字
    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    NSUInteger count = titles.count;
    
    // 标题按钮的尺寸 宽高
    CGFloat titleBtnW = self.titleView.zh_width / 5;
    CGFloat titleBtnH = self.titleView.zh_height;
    
    // 创建5个标题按钮
    for (NSUInteger i = 0; i < count; i++) {
        SLTitleButton *titleBtn = [SLTitleButton buttonWithType:UIButtonTypeCustom];
        [self.titleView addSubview:titleBtn];
        [titleBtn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        // frame
        titleBtn.frame = CGRectMake(titleBtnW * i, 0, titleBtnW, titleBtnH);
        // 背景色
        // titleBtn.backgroundColor = ZHRandomColor;
        // 文字
        [titleBtn setTitle:titles[i] forState:UIControlStateNormal];
    }
}

/// 标题下划线
- (void)setupTitleUnderline
{
    // 标题按钮
    SLTitleButton *firstTitleButton = self.titleView.subviews.firstObject;
    
    // 下划线
    UIView *titleUnderLine = [[UIView alloc] init];
    titleUnderLine.zh_height = 2;
    titleUnderLine.zh_y = self.titleView.zh_height - titleUnderLine.zh_height;
    titleUnderLine.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    [self.titleView addSubview:titleUnderLine];
    self.titleUnderLine = titleUnderLine;
    
    // 默认点击最前面的按钮
    [firstTitleButton.titleLabel sizeToFit];    // 让label根据文字内容计算尺寸
    // [self titleButtonClick:firstTitleButton];
    
    // 切换按钮状态
    firstTitleButton.selected = YES;
    self.previousClickedTitleButton = firstTitleButton;
    
    self.titleUnderLine.zh_width = firstTitleButton.titleLabel.zh_width + 10;
    self.titleUnderLine.zh_centerX = firstTitleButton.zh_centerX;
}


#pragma mark - 监听
- (IBAction)titleButtonClick:(SLTitleButton *)titleBtn
{
    // 监听按钮的是否重复点击
    if (self.previousClickedTitleButton == titleBtn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SLTittleButtonDidRepeatClickedNotification object:nil];
    }
    
    // 处理标题按钮点击
    [self dealTitleButtonClick:titleBtn];
}

/**
  处理标题按钮点击
 */
- (void)dealTitleButtonClick:(SLTitleButton *)titleBtn
{
    // 切换按钮状态
    self.previousClickedTitleButton.selected = NO;
    titleBtn.selected = YES;
    self.previousClickedTitleButton = titleBtn;
    
    NSUInteger index = [self.titleView.subviews indexOfObject:titleBtn];
    [UIView animateWithDuration:0.25 animations:^{
        // 处理下划线
        self.titleUnderLine.zh_width = titleBtn.titleLabel.zh_width + 10;
        self.titleUnderLine.zh_centerX = titleBtn.zh_centerX;
        
        // 滚动scrollView
        NSUInteger index = [self.titleView.subviews indexOfObject:titleBtn];
        CGFloat offSetX = self.scrollView.zh_width * index;
        self.scrollView.contentOffset = CGPointMake(offSetX, self.scrollView.contentOffset.y);
    }completion:^(BOOL finished) {
        [self addChildVcViewIntoScrollView:index];
    }];
    
    
    // 设置index位置对应的tableView.scrollsToTop = YES; 其他的都是NO
    for (NSUInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVc = self.childViewControllers[i];
        // 如果View还没有创建，就不用处理
        if (!childVc.isViewLoaded) continue;
        
        UIScrollView *scrollView = (UIScrollView *)childVc.view;
        if (![scrollView isKindOfClass:[UIScrollView class]]) continue;
        scrollView.scrollsToTop = (i == index);
    }

}


#pragma mark - <UIScrollViewDelegate>
/// 当用户松开scrollView滑动结束时，调用这个代理方法（scrollView停止滚动）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 求出对应标题按钮的索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.zh_width;
    
    // 点击对应的标签按钮
    // SLTitleButton *titleBtn = [self.titleView.subviews objectAtIndex:index];
    SLTitleButton *titleBtn = self.titleView.subviews[index];
    // [self titleButtonClick:titleBtn];
    [self dealTitleButtonClick:titleBtn];
}

/// 当用户松开scrollView调用这个代理方法（结束拖拽）
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    ZHFunc
//}

- (void)game
{
    ZHFunc
    
    /*
        什么是内容？ 内容包括什么？
        1.cell
        2.tableHeaderView/tableFooterView
        3.sectionHeaderView/sectionFooterView
     
        contentSize.height: 所有内容总高度
        contentInset： 在内容周围额外增加的间距（内边距），始终粘着内容
        contectOffset: 内容距离frame矩形框，偏移了多少
     
        frame:是以父控件内容的左上角为坐标原点{0，0}
        bounds:是以自身内容的左上角为坐标原点{0，0}
    
    // contentOffset.y == frame顶部 和 contentSize顶部 的差值
    */
}

#pragma mark - 其他
/// 添加第index个控制器的View到scrollView中
- (void)addChildVcViewIntoScrollView:(NSUInteger)index
{
    UIViewController *childVc = self.childViewControllers[index];
    // 如果view已经被加载过，就直接返回
    if (childVc.isViewLoaded) return;
        
    
    CGFloat scrollViewW = self.scrollView.zh_width;
    CGFloat scrollViewH = self.scrollView.zh_height;
    // 1.取出对应位置的子控制器
    UIView *childVcView = self.childViewControllers[index].view;
    // 如果view已经被加载过，就直接返回
    // if(childVcView.superview) return;
    // if(childVcView.window) return;
    
    // 设置子控制器view的frame
    childVcView.frame = CGRectMake(scrollViewW * index, 0, scrollViewW, scrollViewH);
    // 添加子控制器的view到scrollView中
    [self.scrollView addSubview:childVcView];
}


/*
 @implementation UIView
 
 - (UIView *)viewWithTag:(NSInteger)tag
 {
 // 如果自己的tag符合条件，就返回自己
 if (self.tag == tag) return self;
 // 便利子控件， （甚至是子控件的子控件） 直到找到符合条件的子控件为止
 for (UIView *subView in self.subviews) {
 // if (subView.tag == tag) return subView;
 
 
 UIView *reslutView = [subView viewWithTag:tag];
 if (reslutView) return reslutView;
 
 }
 return nil;
 }
 
 @end
 
 */


@end

