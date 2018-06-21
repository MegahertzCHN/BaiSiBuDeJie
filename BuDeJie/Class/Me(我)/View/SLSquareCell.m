//
//  SLSquareCell.m
//  BuDeJie
//
//  Created by 赵鹤 on 2016/10/15.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SLSquareCell.h"
#import <UIImageView+WebCache.h>
@interface SLSquareCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end


@implementation SLSquareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(SLSquareItem *)item
{
    _item = item;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_item.icon] placeholderImage:nil];
    
    _label.text = _item.name;
}

@end
