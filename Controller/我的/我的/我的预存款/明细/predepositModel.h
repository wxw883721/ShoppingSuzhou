//
//  predepositModel.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/8.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "BaseModel.h"

@interface predepositModel : BaseModel

@property (nonatomic,retain) NSString *lg_id;
@property (nonatomic,retain) NSString *lg_member_id;
@property (nonatomic,retain) NSString *lg_member_name;
@property (nonatomic,retain) NSString *lg_av_amount;
@property (nonatomic,retain) NSString *lg_freeze_amount;
@property (nonatomic,retain) NSString *lg_add_time;
@property (nonatomic,retain) NSString *lg_desc;

@end
