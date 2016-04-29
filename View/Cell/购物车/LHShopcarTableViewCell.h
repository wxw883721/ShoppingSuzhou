//
//  LHShopcarTableViewCell.h
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/12.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHShopcarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *godName;
@property (weak, nonatomic) IBOutlet LHImageView *selectedImage;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *totalNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tasteLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet LHImageView *reduceImage;
@property (weak, nonatomic) IBOutlet LHImageView *addImage;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
