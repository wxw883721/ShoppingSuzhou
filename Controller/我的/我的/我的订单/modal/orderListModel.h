//
//  orderListModel.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/11.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "BaseModel.h"

@interface orderListModel : BaseModel

@property (strong,nonatomic) NSArray *extent_order_goods;

@property (strong,nonatomic) NSString *order_id;
@property (copy,nonatomic) NSString *order_sn;
@property (copy,nonatomic) NSString *pay_sn;
@property (strong,nonatomic) NSString *store_id;
@property (copy,nonatomic) NSString *store_name;
@property (strong,nonatomic) NSString *buyer_id;
@property (copy,nonatomic) NSString *buyer_name;
@property (copy,nonatomic) NSString *add_time;
@property (copy,nonatomic) NSString *payment_code;
@property (copy,nonatomic) NSString *payment_time;
@property (copy,nonatomic) NSString *finnshed_time;
@property (strong,nonatomic) NSString *goods_amount;
@property (strong,nonatomic) NSString *order_amount;
@property (strong,nonatomic) NSString *evaluation_state;
@property (strong,nonatomic) NSString *order_state;
@property (strong,nonatomic) NSString *refund_state;
@property (strong,nonatomic) NSString *lock_state;
@property (strong,nonatomic) NSString *refund_amount;
@property (copy,nonatomic) NSString *delay_time;
@property (copy,nonatomic) NSString *order_from;
@property (strong,nonatomic) NSNumber *is_delete;
@property (copy,nonatomic) NSString *state_desc;
@property (copy,nonatomic) NSString *payment_name;
@property (copy,nonatomic) NSString *payment_bank;

@property (copy,nonatomic) NSString *is_cancel;
@property (copy,nonatomic) NSString *if_lock;

@end
