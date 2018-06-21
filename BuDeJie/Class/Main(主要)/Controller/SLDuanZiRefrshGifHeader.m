//
//  SLDuanZiRefrshGifHeader.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/11/11.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLDuanZiRefrshGifHeader.h"


@interface SLDuanZiRefrshGifHeader ()
@property (nonatomic, strong) UIView *backView;
@end

@implementation SLDuanZiRefrshGifHeader

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        [self insertSubview:_backView atIndex:0];
    }
    return _backView;
}



- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=1; i++) {
        UIImage *image = [UIImage imageNamed:@"short"];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *willRefreshingImages = [NSMutableArray array];
    for (NSUInteger i = 2; i<=2; i++) {
        UIImage *image = [UIImage imageNamed:@"long"];
        [willRefreshingImages addObject:image];
    }
    [self setImages:willRefreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=2; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.lastUpdatedTimeLabel.hidden = YES;
        self.stateLabel.hidden = YES;
        self.automaticallyChangeAlpha = YES;
    }
    return self;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.gifView.constraints.count) return;
    
    self.gifView.frame = self.bounds;
    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
        self.gifView.contentMode = UIViewContentModeBottom;
    } else {
        self.gifView.contentMode = UIViewContentModeRight;
        
        CGFloat stateWidth = self.stateLabel.mj_textWith;
        CGFloat timeWidth = 0.0;
        if (!self.lastUpdatedTimeLabel.hidden) {
            timeWidth = self.lastUpdatedTimeLabel.mj_textWith;
        }
        CGFloat textWidth = MAX(stateWidth, timeWidth);
        self.gifView.mj_w = self.mj_w * 0.5 - textWidth * 0.5 - self.labelLeftInset;
    }
    
    self.backView.frame = self.bounds;
//    self.backView.backgroundColor = [UIColor redColor];
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    self.backView.layer.cornerRadius = 30.00000000 * pullingPercent;
    NSLog(@"%f", pullingPercent);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(self.backView.zh_width  / pullingPercent, self.backView.zh_height / pullingPercent)];
    
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.backView.layer.mask = maskLayer;
    
    

}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    
//    UIColor * color = [UIColor redColor];//椭圆颜色
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, color.CGColor);
//    CGContextSetStrokeColorWithColor(context, color.CGColor);
//    
//    CGContextAddEllipseInRect(context, CGRectMake(0, -self.mj_h, self.bounds.size.width, 2*self.mj_h)); //椭圆
//    CGContextDrawPath(context, kCGPathFill);
//}







@end
