//
//  detailOrderGoodsModel.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/25.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "BaseModel.h"

@interface detailOrderGoodsModel : BaseModel

@property (nonatomic,copy) NSString *rec_id;
@property (nonatomic,copy) NSString *order_id;
@property (nonatomic,copy) NSString *goods_id;
@property (nonatomic,copy) NSString *goods_name;
@property (nonatomic,copy) NSString *goods_price;
@property (nonatomic,copy) NSString *goods_num;
@property (nonatomic,copy) NSString *goods_image;
@property (nonatomic,copy) NSString *goods_pay_price;
@property (nonatomic,copy) NSString *store_id;
@property (nonatomic,copy) NSString *buyer_id;
@property (nonatomic,copy) NSString *goods_type;
@property (nonatomic,copy) NSString *promotions_id;
@property (nonatomic,copy) NSString *commis_rate;
@property (nonatomic,copy) NSString *color_id;
@property (nonatomic,copy) NSString *goods_spec;
@property (nonatomic,copy) NSString *spec_name;

@end
