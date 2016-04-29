//
//  orderModel.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/11.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "BaseModel.h"

@interface orderModel : BaseModel

@property (retain,nonatomic) NSArray *order_list;
@property (strong,nonatomic) NSString *pay_amount;
@property (copy,nonatomic) NSString *add_time;
@property (copy,nonatomic) NSString *pay_sn;
@property (strong,nonatomic) NSString *total_num;
@property (copy,nonatomic) NSString *message;


@end
