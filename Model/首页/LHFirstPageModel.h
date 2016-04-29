//
//  LHFirstPageModel.h
//  ShoppingSuzhou
//
//  Created by YQ on 15/5/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "RootModel.h"

@interface LHFirstPageModel : RootModel

//轮播model
@property (copy,nonatomic) NSString* id;
@property (copy,nonatomic) NSString* img;
@property (copy,nonatomic) NSString* title;

//推荐商品
@property (copy,nonatomic) NSString* goods_id;
@property (copy,nonatomic) NSString* goods_image;
@property (copy,nonatomic) NSString* goods_name;
@property (copy,nonatomic) NSString* goods_price;

//活动街
@property (copy,nonatomic) NSString* url;

//新闻
@property (nonatomic, copy) NSString *news_title;

@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *store_cover;
@property (nonatomic, copy) NSString *store_label;

@end
