//
//  DazheModel.h
//  ShoppingSuzhou
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "RootModel.h"

@interface DazheModel : RootModel

@property (nonatomic,strong) NSString *cur_price;
@property (nonatomic,strong) NSString *discount;
@property (nonatomic,strong) NSString *end_time;
@property (nonatomic,strong) NSString *goods_id;
@property (nonatomic,strong) NSString *goods_image;
@property (nonatomic,strong) NSString *goods_name;
@property (nonatomic,strong) NSString *goods_price;
@property (nonatomic,strong) NSString *start_time;
@property (nonatomic,strong) NSString *store_id;

//  星星
@property (nonatomic ,copy) NSString *star;

@end
