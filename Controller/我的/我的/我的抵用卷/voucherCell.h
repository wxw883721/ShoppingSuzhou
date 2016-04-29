//
//  voucherCell.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/16.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface voucherCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *voucherView;
@property (weak, nonatomic) IBOutlet UIImageView *voucherImage;
@property (weak, nonatomic) IBOutlet UILabel *voucherStoreName;
@property (weak, nonatomic) IBOutlet UILabel *voucherPrice;
@property (weak, nonatomic) IBOutlet UILabel *voucherTime;
@property (weak, nonatomic) IBOutlet UIImageView *voucherStateImage;


@end
