//
//  integralMallModel.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/30.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "BaseModel.h"

@interface integralMallModel : BaseModel

@property (nonatomic,copy) NSString *pgoods_id;
@property (nonatomic,copy) NSString *pgoods_name;
@property (nonatomic,copy) NSString *pgoods_price;
@property (nonatomic,copy) NSString *pgoods_points;
@property (nonatomic,copy) NSString *pgoods_image;
@property (nonatomic,copy) NSString *pgoods_serial;
@property (nonatomic,copy) NSString *pgoods_storage;
@property (nonatomic,copy) NSString *pgoods_salenum;
@property (nonatomic,copy) NSString *pgoods_add_time;

@end
