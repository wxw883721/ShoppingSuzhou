//
//  LHShopDetail2TableViewCell.h
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/15.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StarView;
@class LHImageView;

@interface LHShopDetail2TableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *fengshuLabel;

@property (strong, nonatomic)  LHImageView *tuImage;
@property (strong, nonatomic)  UILabel *numberLabel;
@property (strong, nonatomic)  LHImageView *reduceImage;
/** 第5行cell*/
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *intoLabel;

/** 第六行cell*/
@property (nonatomic, strong) StarView *pingjiaImage;

+ (LHShopDetail2TableViewCell *)cellWithTableView:(UITableView *)tableView;
@end
