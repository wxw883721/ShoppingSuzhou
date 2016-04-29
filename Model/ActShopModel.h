//
//  ActShopModel.h
//  ShoppingSuzhou
//
//  Created by lifei on 15/7/3.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "RootModel.h"

@interface ActShopModel : RootModel
@property (nonatomic, copy) NSString *activity_id;
@property (nonatomic, copy) NSString *activity_title;
@property (nonatomic, copy) NSString *activity_start_date;
@property (nonatomic, copy) NSString *activity_end_date;

@property (nonatomic, copy) NSString *activity_detail_sort;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_price;
@property (nonatomic, copy) NSString *goods_image;
@property (nonatomic, copy) NSString *goods_marketprice;
@property (nonatomic, copy) NSString *goods_salenum;
@property (nonatomic, copy) NSString *evaluation_good_star;
@property (nonatomic, copy) NSString *evaluation_count;

@end
