//
//  ActStreetModel.h
//  ShoppingSuzhou
//
//  Created by lifei on 15/7/2.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "RootModel.h"

@interface ActStreetModel : RootModel
@property (nonatomic, copy) NSString *activity_id;
@property (nonatomic, copy) NSString *activity_title;
@property (nonatomic, copy) NSString *activity_start_date;
@property (nonatomic, copy) NSString *activity_end_date;

@property (nonatomic, copy) NSString *activity_detail_sort;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *store_label;
@property (nonatomic, copy) NSString *store_cover;
@property (nonatomic, copy) NSString *store_sales;
@property (nonatomic, copy) NSString *praise_rate;
@end
