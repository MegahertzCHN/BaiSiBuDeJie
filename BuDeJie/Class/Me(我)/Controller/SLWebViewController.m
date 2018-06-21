//
//  SLWebViewController.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/17.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLWebViewController.h"
#import <WebKit/WebKit.h>

@interface SLWebViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, weak) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@end

@implementation SLWebViewController
// 前进
- (IBAction)goForward:(id)sender {
    [_webView goBack];
}

// 后退
- (IBAction)goBack:(id)sender {
    [_webView goForward];
}

// 刷新
- (IBAction)refresh:(id)sender {
    [_webView reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 添加webView
    WKWebView *webView = [[WKWebView alloc] init];
    _webView = webView;
    [self.contentView addSubview:webView];
    _webView.backgroundColor = [UIColor grayColor];
    
    // 展示网页
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    [webView loadRequest:request];
    
    // KVO 监听属性改变
    /*
        Observer: 观察者
        KeyPath: 观察webView哪些属性
        options: NSKeyValueObservingOptionNew: 观察他的新的值的改变
     
        KVO注意点: 一定要移除
     */
    [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    // 进度条
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"canGoForward"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

// 只要观察的对象属性有新值就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"%d, %d", self.webView.canGoForward, self.webView.canGoBack);
    
    self.backItem.enabled = self.webView.canGoBack;
    self.forwardItem.enabled = self.webView.canGoForward;
    self.title = self.webView.title;
    self.progressView.progress = self.webView.estimatedProgress;
    self.progressView.hidden = self.webView.estimatedProgress >= 1;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _webView.frame = self.contentView.bounds;
}


@end
