//
//  LLHTenantCell.h
//  ShoppingSuzhou
//
//  Created by lifei on 15/6/25.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StarView;
@class LHTenantModel;

@interface LLHTenantCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) StarView *starView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *pingjiaLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *jiliLabel;

@property (nonatomic, strong) LHTenantModel *tenantModel;
//+ (LLHTenantCell *)cellWithtableView:(UITableView *)table;
@end
