//
//  LHShopCarModel.h
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/16.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "RootModel.h"

@interface LHShopCarModel : RootModel

@property (strong,nonatomic) NSString* cart_id;
@property (strong,nonatomic) NSString* buyer_id;
@property (strong,nonatomic) NSString* store_id;
@property (strong,nonatomic) NSString* store_name;
@property (strong,nonatomic) NSString* goods_id;
@property (strong,nonatomic) NSString* goods_name;
@property (strong,nonatomic) NSString* goods_price;
@property (strong,nonatomic) NSString* goods_num;
@property (strong,nonatomic) NSString* goods_image_url;
@property (strong,nonatomic) NSString* goods_sum;
@property (strong,nonatomic) NSString* spec_value;
@property (strong,nonatomic) NSString* spec_name;

@property (strong,nonatomic) NSString* sum;

@end
