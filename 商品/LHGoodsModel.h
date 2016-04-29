//
//  LHGoodsModel.h
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/3.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "RootModel.h"

@interface LHGoodsModel : RootModel

@property (copy,nonatomic) NSString* goods_id;
@property (copy,nonatomic) NSString* gc_id;
@property (copy,nonatomic) NSString* goods_name;
@property (copy,nonatomic) NSString* goods_price;
@property (copy,nonatomic) NSString* goods_marketprice;
@property (copy,nonatomic) NSString* goods_image;
@property (copy,nonatomic) NSString* goods_salenum;
@property (copy,nonatomic) NSString* goods_collect;

@property (copy,nonatomic) NSString* evaluation_good_star;
@property (copy,nonatomic) NSString* evaluation_count;

@property (copy,nonatomic) NSString* xianshi_flag;
@property (copy,nonatomic) NSString* goods_image_url;
@end
