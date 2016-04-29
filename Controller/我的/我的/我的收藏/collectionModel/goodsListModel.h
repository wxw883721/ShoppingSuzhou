//
//  goodsListModel.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/15.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "BaseModel.h"

@interface goodsListModel : BaseModel

@property (nonatomic,strong) NSString *goods_id;
@property (nonatomic,copy) NSString *goods_name;
@property (nonatomic,copy) NSString *goods_image;
@property (nonatomic,strong) NSString *goods_price;
@property (nonatomic,strong) NSString *goods_marketprice;
@property (nonatomic,strong) NSString *goods_salenum;
@property (nonatomic,strong) NSString *evaluation_good_star;
@property (nonatomic,strong) NSString *evaluation_count;
@property (strong,nonatomic) NSString *store_id;
@property (copy,nonatomic) NSString *collect_type;


@end
