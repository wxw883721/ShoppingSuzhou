//
//  XianshiModel.h
//  ShoppingSuzhou
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "RootModel.h"

@interface XianshiModel : RootModel

@property (copy,nonatomic)  NSString *goods_id;
@property (copy,nonatomic)  NSString *store_id;
@property (copy,nonatomic)  NSString *goods_name;
@property (copy,nonatomic)  NSString *goods_price;
@property (copy,nonatomic)  NSString *cur_price;
@property (copy,nonatomic)  NSString *discount;
@property (copy,nonatomic)  NSString *goods_image;
@property (copy,nonatomic)  NSString *start_time;
@property (copy,nonatomic)  NSString *end_time;
//添加 星星属性
@property (nonatomic,copy) NSString * star;

@end
