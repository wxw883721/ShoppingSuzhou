//
//  XianshiCell.h
//  ShoppingSuzhou
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"

@interface XianshiCell : UITableViewCell

@property (strong,nonatomic)  UIImageView *iconView;

@property (strong,nonatomic)  UILabel *titleLabel;

@property (strong,nonatomic)  UILabel *priceLabel;

//@property (strong,nonatomic)  UILabel *oldPriceLabel;

@property (strong,nonatomic)  UILabel *addressLabel;

@property (strong,nonatomic)  UILabel *timeLabel;

@property (strong,nonatomic)  UILabel *saleCountLabel;

// 添加 星星属性
@property (strong,nonatomic)  StarView *starView;

@property (strong,nonatomic)  UILabel *discountLabel;

// 添加 删除线 属性
//@property (nonatomic,strong) UILabel * deleteLabel;


@end
