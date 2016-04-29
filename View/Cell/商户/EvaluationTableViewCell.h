//
//  EvaluationTableViewCell.h
//  ShoppingSuzhou
//
//  Created by lifei on 15/6/26.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StarView;
@class EvaluationModel;
@class ShangpinEvaluationModel;

@interface EvaluationTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *storeContent;
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) StarView *stareView;

@property (nonatomic, strong) EvaluationModel *mymodel;
@property (nonatomic, strong) ShangpinEvaluationModel *shangpinModel;

+ (EvaluationTableViewCell *)cellWithTableView:(UITableView *)tableView;

- (CGFloat)getCellHeightWith:(EvaluationModel *)mymodel;

@end
