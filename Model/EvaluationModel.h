//
//  EvaluationModel.h
//  ShoppingSuzhou
//
//  Created by lifei on 15/6/26.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "RootModel.h"

@interface EvaluationModel : RootModel

@property (nonatomic, strong) NSString *total_score;

@property (nonatomic, strong) NSString *seval_content;
@property (nonatomic, strong) NSString *seval_addtime;
@property (nonatomic, strong) NSString *seval_memberid;
@property (nonatomic, strong) NSString *seval_membername;
@property (nonatomic, strong) NSString *seval_isanonymous;
@property (nonatomic, strong) NSString *seval_total;
@property (nonatomic, strong) NSString *seval_storecontent;

@end
