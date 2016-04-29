//
//  shoppingCartListModel.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/20.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "BaseModel.h"

@interface shoppingCartListModel : BaseModel

@property (nonatomic,retain) NSString *cart_id;
@property (nonatomic,retain) NSString *buyer_id;
@property (nonatomic,retain) NSString *store_id;
@property (nonatomic,retain) NSString *store_name;
@property (nonatomic,retain) NSString *goods_id;
@property (nonatomic,retain) NSString *goods_name;
@property (nonatomic,retain) NSString *goods_price;
@property (nonatomic,retain) NSString *goods_num;
@property (nonatomic,retain) NSString *goods_image;
@property (nonatomic,retain) NSString *bl_id;
@property (nonatomic,retain) NSString *goods_image_url;
@property (nonatomic,retain) NSString *goods_sum;
@property (nonatomic,retain) NSString *spec_value;
@property (nonatomic,retain) NSString *spec_name;

@end
