//
//  orderEvaluationVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/26.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TQStarRatingView.h"

@interface orderEvaluationVC : UIViewController<UITextViewDelegate,StarRatingViewDelegate>


@property (nonatomic,retain) NSArray *evaluationArr;

@property (nonatomic,retain) NSArray *evalCellArr;

@property (nonatomic,retain) NSString *goods_id;

@property (nonatomic,retain) NSString *anony;
@property (nonatomic,retain) NSString *score;

@property (nonatomic,retain) NSString *evaGoods;
@property (nonatomic,retain) NSString *store_comment;

@property (nonatomic,retain) NSMutableArray *dataSourceArr;

@end
