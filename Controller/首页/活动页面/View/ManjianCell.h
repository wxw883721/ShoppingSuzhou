//
//  ManjianCell.h
//  ShoppingSuzhou
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StarView;
@interface ManjianCell : UITableViewCell

@property (strong,nonatomic)  UIImageView *iconView;

@property (strong,nonatomic)  UILabel *titleLabel;

@property (strong,nonatomic)  UILabel *addressLabel;

@property (strong,nonatomic)  StarView *starView;

@property (strong,nonatomic)  UILabel *contentLabel;

@property (strong,nonatomic)  UILabel *descriptionLabel;

@property (strong,nonatomic)   UILabel *saleNumLbl;
@end
