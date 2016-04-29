//
//  collectionCell.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/21.
//  Copyright (c) 2015年 SU. All rights reserved.
///Users/notbadboy/Desktop/work/百购宿州/ShoppingSuzhou0529/ShoppingSuzhou/Controller/我的/我的/我的收藏/collectionCell.h

#import <UIKit/UIKit.h>

@interface collectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UIImageView *pattern;
@property (weak, nonatomic) IBOutlet UILabel *moneyNumber;
@property (strong, nonatomic) IBOutlet UILabel *moneyNoNumber;

@property (weak, nonatomic) IBOutlet UIView *evaluateView;
@property (weak, nonatomic) IBOutlet UILabel *evaluateNumber;
@property (weak, nonatomic) IBOutlet UILabel *soldNumber;

@property (strong, nonatomic) IBOutlet UIImageView *moneyNoNumberImage;
@property (strong, nonatomic) IBOutlet UILabel *collectionAdress;

@end
