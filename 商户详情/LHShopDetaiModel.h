//
//  LHShopDetaiModel.h
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/8.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "RootModel.h"

@interface LHShopDetaiModel : RootModel

@property (strong,nonatomic ) NSNumber *store_fav;
@property (nonatomic, strong) NSString *store_id;
@property (strong,nonatomic ) NSString * store_name;
@property (strong,nonatomic ) NSString * store_address;
@property (strong,nonatomic ) NSString * store_tel;
@property (strong,nonatomic ) NSString * store_sales;
@property (strong,nonatomic ) NSString * praise_rate;
@property (strong,nonatomic ) NSString * goods_count;
@property (strong,nonatomic ) NSString * store_label;
@property (strong,nonatomic ) NSString * store_cover;
@property (strong,nonatomic ) NSNumber * store_juli;
@property (nonatomic, strong) NSString *seval_num;
@property (nonatomic, strong) NSString *seval_total;



@property (strong,nonatomic) NSString* goods_id;
@property (strong,nonatomic) NSString* goods_image;
@property (strong,nonatomic) NSString* goods_name;
@property (strong,nonatomic) NSString* goods_price;
@property (nonatomic, strong) NSString *nc_distinct;

@property (copy,nonatomic)  NSString *store_x;
@property (copy,nonatomic)  NSString *store_y;

@end
