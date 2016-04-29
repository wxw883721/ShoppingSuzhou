//
//  orderGoodsModel.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/11.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "BaseModel.h"

@interface orderGoodsModel : BaseModel

@property (strong,nonatomic) NSNumber *rec_id;
@property (strong,nonatomic) NSNumber *order_id;
@property (strong,nonatomic) NSNumber *goods_id;
@property (copy,nonatomic) NSString *goods_name;
@property (strong,nonatomic) NSNumber *goods_price;
@property (strong,nonatomic) NSNumber *goods_num;
@property (strong,nonatomic) NSString *goods_pay_price;
@property (strong,nonatomic) NSNumber *store_id;
@property (strong,nonatomic) NSNumber *buyer_id;
@property (strong,nonatomic) NSString *goods_type;
@property (strong,nonatomic) NSNumber *promotions_id;
@property (strong,nonatomic) NSNumber *commis_rate;
@property (copy,nonatomic) NSString *goods_spec;
@property (copy,nonatomic) NSString *spec_name;

//@property (retain,nonatomic) NSArray *order_ticket;

@property (copy,nonatomic) NSString *goods_image_url;

@end
