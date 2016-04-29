//
//  shoppingCarCell.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/17.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shoppingCartListModel.h"


@class shoppingCarCell;

@protocol shoppingCarCellDelegate <NSObject>

- (void)editBtnPress:(NSString *)editProductId;
//- (void)circleBtnPress:(NSDictionary*)dic;
//选中某个产品
- (void)selecteItem:(NSDictionary *)selectedItem isSelected:(BOOL)isSelected;
//点击某个编辑
-(void)clickItem:(NSDictionary *)selectedItem isSelected:(BOOL)isSelected;
//数量变化委托
-(void)changeNum:(NSString *)totalNum changeSum:(NSString *)totalSum andChangeItemDic:(NSDictionary *)dic ;


@end

@interface shoppingCarCell : UITableViewCell

@property (retain, nonatomic)  UILabel *shoppingStoreName;
@property (retain, nonatomic)  UIButton *shoppingSelectBtn;
@property (retain, nonatomic)  UIImageView *shoppingImage;
@property (retain, nonatomic)  UILabel *shoppingShopName;
@property (retain, nonatomic)  UILabel *shoppingFications;
@property (retain, nonatomic)  UILabel *shoppingNum;
@property (retain, nonatomic)  UILabel *shoppingPrice;
@property (retain, nonatomic)  UIButton *shoppingEditor;
@property (retain,nonatomic)   UILabel *shoppingTotalNum;
@property (retain, nonatomic)  UILabel *shoppingTotalPrice;


@property (retain, nonatomic)  UIImageView *shoppingLineImage;
@property (retain, nonatomic)  UIButton *reductionBtn;
@property (retain, nonatomic)  UIButton *addBtn;
@property (retain, nonatomic)  UILabel *shoppingAddNumLabel;

@property (nonatomic,strong)NSDictionary *selectedDic;
@property (nonatomic,retain) NSString *editBtnName;

//点击加减
@property (nonatomic,retain) NSString *shopBtnTotalNum;
@property (nonatomic,retain) NSString *shopBtnTotalPrice;

@property (nonatomic,assign)id<shoppingCarCellDelegate>delegate;

@property (retain,nonatomic) UIView *view;

//点击编辑
@property (assign,nonatomic)BOOL  onClick;
//是否全部编辑
@property (assign,nonatomic)BOOL isEditor;

//点击圆
@property (assign,nonatomic)BOOL circleClick;
@property (assign,nonatomic)BOOL isSelectedAll;


@property (nonatomic,retain) NSMutableArray *calculateArr;

//- (void)configCellWith:(shoppingCartListModel*)model;
- (void)configCellWith:(NSDictionary*)dic;


@end
