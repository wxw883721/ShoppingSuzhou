//
//  myMessCell.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class myMessCell  ;

@protocol myMessCellDelegate <NSObject>

//选中某个消息
-(void)selectItem:(NSDictionary *)selectItem isSelected:(BOOL)isSelected;

@end

@interface myMessCell : UITableViewCell


@property (nonatomic,retain) id<myMessCellDelegate>delegate;

@property (nonatomic,strong) NSDictionary *selectedDic;

//是否全选
@property (assign,nonatomic) BOOL isSelectAll;
//点击选择
@property (assign,nonatomic) BOOL isSelect;

//是否编辑
@property (assign,nonatomic) BOOL isEditor;

@property (retain,nonatomic) UIButton *selectBtn;

-(void)createCell:(NSDictionary *)dic;

@end
