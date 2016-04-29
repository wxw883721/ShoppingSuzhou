//
//  orderDetailCell.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/1.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class orderDetailCell;

@protocol orderDetailCellDelegate <NSObject>



@end

@interface orderDetailCell : UITableViewCell


@property (assign,nonatomic)id <orderDetailCellDelegate>delegate;

-(void)configDetailOrder:(NSDictionary *)dic;

@end
