//
//  makeSureOrderCell.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/24.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class makeSureOrderCell;

@protocol makeSureOrderCellDelegate <NSObject>


@end

@interface makeSureOrderCell : UITableViewCell

@property (strong,nonatomic)  UIButton *voucherBtn;

@property (nonatomic,retain) NSDictionary *clickDic;

@property (nonatomic,assign)id<makeSureOrderCellDelegate>delegate;

-(void)configCellWith:(NSDictionary *)dic;

@end
