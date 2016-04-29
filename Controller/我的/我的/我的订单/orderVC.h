//
//  orderVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/26.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderListModel.h"
#import "orderGoodsModel.h"
#import "orderTicket.h"
#import "orderModel.h"
#import "orderCell.h"
#import "Payment.h"

@interface orderVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,PaymentDelegate,orderCellDelegate>


@property (nonatomic,retain) UITableView *customTableView;
//@property (nonatomic,retain) UITableView *codeTableView;
//@property (nonatomic,retain) UITableView *goodsTableView;

//@property (nonatomic,retain) orderModel *model;
//@property (nonatomic,retain) orderListModel *listModel;
@property (nonatomic,retain) orderGoodsModel *goodsModel;

@property (nonatomic,retain) NSString *order_id;
@property (nonatomic,retain) NSString *goods_id;
@property (nonatomic,retain) NSString *order_state;

@property (nonatomic,retain) NSMutableArray *orderArr;
//@property (nonatomic,retain) NSMutableArray *goodsArr;
@property (nonatomic,retain) NSMutableArray *orderListArr;

@property (nonatomic,assign) int cellHeight;

@property(nonatomic,retain) NSMutableArray  *RefundArr;
@property (nonatomic,retain) NSMutableArray *deleteArr;

@property (nonatomic,retain) NSString *isOrderState;

@property (nonatomic,assign) NSInteger btnTag;


@end
