//
//  TowCell.h
//  ShoppingSuzhou
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TowCell : UITableViewCell

@property (strong,nonatomic)  UIView *view1;
@property (strong,nonatomic)  UIView *view2;
@property (strong,nonatomic)  UIView *view3;
@property (strong,nonatomic)  UIView *view4;
@property (strong,nonatomic)  UIView *view5;
@property (nonatomic, strong) UIView *backView;

@property (strong,nonatomic)  UILabel *actionLabel;
@property (strong,nonatomic)  UIImageView *actionView;
@property (strong,nonatomic)  UILabel *actionTitle;

@property (strong,nonatomic)  UILabel *gods1Label;
@property (strong,nonatomic)  UIImageView *gods1;
@property (strong,nonatomic)  UILabel *gods1Title;

@property (strong,nonatomic)  UILabel *gods2Label;
@property (strong,nonatomic)  UIImageView *gods2;
@property (nonatomic, strong) UILabel *gods2Title;

@property (strong,nonatomic)  UILabel *gods3Label;
@property (strong,nonatomic)  UIImageView *gods3;
@property (nonatomic, strong) UILabel *god3Title;

@property (strong,nonatomic)  UILabel *newsTitle;
@property (nonatomic, strong) UIView *newsView;

@property (nonatomic, strong) NSArray *newsArray;
@property (nonatomic, strong) NSArray *actArray;
@property (strong,nonatomic)  NSArray *actmodeArray;

@end
