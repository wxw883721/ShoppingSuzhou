//
//  voucherModel.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/17.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "BaseModel.h"

@interface voucherModel : BaseModel

@property (nonatomic,copy) NSString *store_id;
@property (nonatomic,copy) NSString *store_name;
@property (nonatomic,copy) NSString *voucher_owner_id;
@property (nonatomic,copy) NSString *voucher_t_id;
@property (nonatomic,copy) NSString *voucher_price;
@property (nonatomic,copy) NSString *voucher_limit;
@property (nonatomic,copy) NSString *voucher_start_date;
@property (nonatomic,copy) NSString *voucher_end_date;
@property (nonatomic,copy) NSString *voucher_t_img;
@property (nonatomic,copy) NSString *voucher_state;
@property (nonatomic,copy) NSString *voucher_state_mean;

@end
