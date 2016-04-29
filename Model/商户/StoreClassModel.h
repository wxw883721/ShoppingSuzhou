//
//  StoreClassModel.h
//  ShoppingSuzhou
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "RootModel.h"

@interface StoreClassModel : RootModel

@property (copy,nonatomic)  NSString *sc_id;
@property (copy,nonatomic)  NSString *sc_name;
@property (copy,nonatomic)  NSString *sc_parent_id;
@property (copy,nonatomic)  NSString *sc_sort;

@end
