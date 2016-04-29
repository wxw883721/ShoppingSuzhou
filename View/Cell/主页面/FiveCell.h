//
//  FiveCell.h
//  ShoppingSuzhou
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FiveCell : UITableViewCell

@property (nonatomic, strong) NSArray *array;

@property (strong,nonatomic)  UIView *myView1;
@property (strong,nonatomic)  UIImageView *pic1;
@property (strong,nonatomic)  UILabel *titleLabel1;

@property (strong,nonatomic)  UIView *myView2;
@property (strong,nonatomic)  UIImageView *pic2;
@property (strong,nonatomic)  UILabel *titleLabel2;


@property (strong,nonatomic)  UILabel *priceLabel1;
@property (strong,nonatomic)  UILabel *priceLabel2;


@end
