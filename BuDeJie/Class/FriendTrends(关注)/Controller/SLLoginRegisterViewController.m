//
//  SLLoginRegisterViewController.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/12.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLLoginRegisterViewController.h"
#import "SLLoginRegisterView.h"

#import "SLFastLoginView.h"
@interface SLLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadCons;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation SLLoginRegisterViewController
- (IBAction)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickRegister:(UIButton *)sender {
    sender.selected = !sender.selected;
    
     // 平移中间View
    _leadCons.constant = _leadCons.constant == 0 ?- self.middleView.zh_width * 0.5 : 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 1.划分结构(顶部 中间 底部)  // 2.一个结构一个结构
// 越复杂的界面 越要去封装(复用)
- (void)viewDidLoad {
    [super viewDidLoad];
    /*
        屏幕适配:
        1.一个view从xib加载,需不需要再重新固定尺寸 一定要再确认一下
     
        2.在viewDidLoad设置控件frame好不好? 不好=> 开发中一般在viewDidLayoutSubviews布局子控件
     */
        
    // 创建loginView
    SLLoginRegisterView *loginView = [SLLoginRegisterView loginView];
    // 添加到中间View
    [self.middleView addSubview:loginView];
    
    // 创建loginView
    SLLoginRegisterView *registerView = [SLLoginRegisterView registerView];
    // 添加到中间View
    [self.middleView addSubview:registerView];
    
    
    SLFastLoginView *fastLoginView = [SLFastLoginView fastLoginView];
    [self.bottomView addSubview:fastLoginView];
    
    NSLog(@"%@", NSStringFromCGRect(self.middleView.frame));
}


// viewDidLayoutSubviews才会根据布局 调整控件的尺寸
- (void)viewDidLayoutSubviews
{
    // 一定要调用super
    [super viewDidLayoutSubviews];
    
    SLLoginRegisterView *loginView = self.middleView.subviews[0];
    loginView.frame = CGRectMake(0, 0, self.middleView.zh_width * 0.5, self.middleView.zh_height);
    
    SLLoginRegisterView *registerView = self.middleView.subviews[1];
    registerView.frame = CGRectMake(self.middleView.zh_width * 0.5, 0, self.middleView.zh_width * 0.5, self.middleView.zh_height);
    
    SLFastLoginView *fastLoginView = self.bottomView.subviews.firstObject;
    fastLoginView.frame = CGRectMake(0, 0, self.bottomView.zh_width, self.bottomView.zh_height);

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
