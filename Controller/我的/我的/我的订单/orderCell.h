//
//  orderCell.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/26.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderGoodsModel.h"

@class orderCell;

@protocol orderCellDelegate <NSObject>

//评价点击事件
-(void)clickBtn:(NSMutableArray *)arr;

//刷新
-(void)setRefresh;


@end

@interface orderCell : UITableViewCell


@property (assign,nonatomic)id <orderCellDelegate>delegate;

@property (nonatomic,retain) NSMutableArray *goodsArr;
@property (nonatomic,retain) NSMutableArray *ticketArr;

@property (nonatomic,assign) int height;

@property (assign,nonatomic) int tickerHeight;

@property (retain,nonatomic) NSMutableArray *orderArr;

-(void)configFication:(NSMutableArray *)arr andOrderSectionArr:(NSMutableArray *)orderSectionArr;


@end
