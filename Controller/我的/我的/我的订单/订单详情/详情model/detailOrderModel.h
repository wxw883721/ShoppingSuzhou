//
//  detailOrderModel.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/25.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "BaseModel.h"

@interface detailOrderModel : BaseModel

@property (nonatomic,copy) NSString *order_id;
@property (nonatomic,copy) NSString *order_sn;
@property (nonatomic,copy) NSString *pay_sn;
@property (nonatomic,copy) NSString *store_id;
@property (nonatomic,copy) NSString *store_name;
@property (nonatomic,copy) NSString *buyer_id;
@property (nonatomic,copy) NSString *buyer_name;
@property (nonatomic,copy) NSString *add_time;
@property (nonatomic,copy) NSString *payment_code;
@property (nonatomic,copy) NSString *payment_time;
@property (nonatomic,copy) NSString *finnshed_time;
@property (nonatomic,copy) NSString *goods_amount;
@property (nonatomic,copy) NSString *order_amount;
@property (nonatomic,copy) NSString *pd_amount;
@property (nonatomic,copy) NSString *evaluation_state;
@property (nonatomic,copy) NSString *order_state;
@property (nonatomic,copy) NSString *refund_state;
@property (nonatomic,copy) NSString *lock_state;
@property (nonatomic,copy) NSString *refund_amount;
@property (nonatomic,copy) NSString *delay_time;
@property (nonatomic,copy) NSString *order_from;
@property (nonatomic,copy) NSString *is_delete;

@end
