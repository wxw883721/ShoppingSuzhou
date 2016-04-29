//
//  GoodsCell.h
//  ShoppingSuzhou
//
//  Created by lifei on 15/6/29.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LHGoodsModel;
@class StarView;

@interface GoodsCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *marketPriceLabel;
@property (nonatomic, strong) StarView *starView;
@property (nonatomic, strong) UILabel *evaluationLabel;
@property (nonatomic, strong) UILabel *saleCountLabel;

@property (nonatomic, strong) LHGoodsModel *goodsModel;

+ (GoodsCell *)cellWithTableView:(UITableView *)tableView;
@end
