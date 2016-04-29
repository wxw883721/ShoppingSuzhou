//
//  DazheCell.h
//  ShoppingSuzhou
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StarView;

@interface DazheCell : UITableViewCell

@property (strong,nonatomic)  UIImageView *iconView;

@property (strong,nonatomic)  UILabel *titleLabel;

@property (strong,nonatomic)  UILabel *priceLabel;

@property (strong,nonatomic)  UILabel *oldPriceLabel;

@property (strong,nonatomic)  UILabel *dazheLabel;

@property (strong,nonatomic)  UILabel *saleCountLabel;

@property (strong,nonatomic)  StarView *starView;

@end
