//
//  ActStreetCell.h
//  ShoppingSuzhou
//
//  Created by lifei on 15/7/2.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StarView;
@class ActStreetModel;

@interface ActStreetCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) StarView *starView;
@property (nonatomic, strong) UILabel *salesLabel;


@property (nonatomic, strong) ActStreetModel *actStreetModel;

+ (ActStreetCell *)cellWithTableView:(UITableView *)tableView;

@end
