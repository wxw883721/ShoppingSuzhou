//
//  orderDetailVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/1.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderDetailCell.h"


@interface orderDetailVC : UIViewController<UITableViewDataSource,UITableViewDelegate,orderDetailCellDelegate,UIAlertViewDelegate>

@property (nonatomic,retain) UITableView *customTableView;

@property (nonatomic ,retain) NSString *order_id;
@property (nonatomic,retain) NSString *store_id;

//@property (nonatomic,retain) NSString *order_state;
@property (nonatomic,retain) NSString *state_desc;
@property (nonatomic,retain) NSString *goods_id;
@property (nonatomic,assign) int indexPath;

@property(nonatomic,retain) NSString *totalNum;

@property (nonatomic,retain) NSArray *orderD_arr;


@end
