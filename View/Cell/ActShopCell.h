//
//  ActShopCell.h
//  ShoppingSuzhou
//
//  Created by lifei on 15/7/3.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ActShopModel;
@class StarView;

@interface ActShopCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) StarView *starView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *salesLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *marketPriceLabel;
@property (nonatomic, strong) UILabel *evaluationLabel;

@property (nonatomic, strong) ActShopModel *shopModel;

+ (ActShopCell *)cellWithTable:(UITableView *)tableView;
@end
