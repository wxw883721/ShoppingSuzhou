//
//  ShangpinEvaluationModel.h
//  ShoppingSuzhou
//
//  Created by lifei on 15/6/29.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "RootModel.h"

@interface ShangpinEvaluationModel : RootModel

@property (nonatomic, copy) NSString *geval_scores;
@property (nonatomic, copy) NSString *geval_content;
@property (nonatomic, copy) NSString *geval_addtime;
@property (nonatomic, copy) NSString *geval_frommemberid;
@property (nonatomic, copy) NSString *geval_frommembername;
@property (nonatomic, copy) NSString *geval_explain;
@property (nonatomic, copy) NSString *geval_image;
@property (nonatomic, copy) NSString *geval_remark;
@property (nonatomic, copy) NSString *geval_isanonymous;
@property (nonatomic, strong) NSString *geval_storecontent;

@end
