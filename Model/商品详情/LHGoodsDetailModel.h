//
//  LHGoodsDetailModel.h
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/15.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "RootModel.h"

@interface LHGoodsDetailModel : RootModel

@property (strong,nonatomic) NSString* goods_name;
@property (strong,nonatomic) NSString* store_id;
@property (strong,nonatomic) NSString* store_name;


@property (strong,nonatomic) NSString* goods_price;
@property (strong,nonatomic) NSString* goods_marketprice;

@property (strong,nonatomic) NSString* goods_salenum;
@property (strong,nonatomic) NSString* evaluation_good_star;
@property (strong,nonatomic) NSString* evaluation_count;

@property (strong,nonatomic) NSString* goods_image;

@property (strong,nonatomic) NSString *goods_fav;

@property (strong,nonatomic) NSString *goods_discount;


@end
