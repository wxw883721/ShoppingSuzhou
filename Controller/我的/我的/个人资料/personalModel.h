//
//  personalModel.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/9.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "BaseModel.h"

@interface personalModel : BaseModel

@property (copy,nonatomic) NSString *uid;
@property (copy,nonatomic) NSString *username;
@property (copy,nonatomic) NSString *nickname;
@property (copy,nonatomic) NSString *password;
@property (copy,nonatomic) NSString *uphone;
@property (copy,nonatomic) NSString *email;
@property (copy,nonatomic) NSString *area_id;
@property (copy,nonatomic) NSString *areainfo;
@property (copy,nonatomic) NSString *key;
@property (copy,nonatomic) NSString *avatar;

@end
