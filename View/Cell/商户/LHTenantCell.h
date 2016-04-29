//
//  LHTenantCell.h
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/3.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StarView;

@interface LHTenantCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *juliLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinjiaLabel;
@property (nonatomic, strong) StarView *starView;

@end
