//
//  LHSecondViewController.h
//  ShoppingSuzhou
//
//  Created by YQ on 15/5/29.
//  Copyright (c) 2015年 SU. All rights reserved.
//
//所有有tableview的 类  都可以继承这个类
#import "DesViewController.h"

@class RootModel;
@interface LHSecondViewController : DesViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) UITableView* tableView;

//定义表格起始的Y点
@property (assign,nonatomic) NSInteger y;
//记录高度
@property (assign,nonatomic) NSInteger foot;

//是否隐藏标签栏
@property (assign,nonatomic) BOOL HideTarbar;

//记录cell的标志
@property (strong,nonatomic) NSString* identifer;
//记录cell高度
@property (assign,nonatomic) NSInteger height;
//记录表格头的view
@property (strong,nonatomic) UIView* headerView;
//记录表格头高度
@property (assign,nonatomic) NSInteger headerHeight;

//获取cell高度
- (void)getHeight:(NSInteger)height;


//注册cell
- (void)registCellWithNibName:(NSString*)nibName identifer:(NSString*)identifer;

- (void)registCellWithClass:(Class )className identifer:(NSString *)identifer;

//填充数据  交给子类实现
- (void)updataWithCell:(UITableViewCell*)cell WithModel:(RootModel*)model;

@end
