//
//  myMessVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myMessCell.h"

@interface myMessVC : UIViewController<UITableViewDataSource,UITableViewDelegate,myMessCellDelegate>

@property (nonatomic,retain) UITableView *customTableView;
@property (nonatomic,retain) NSMutableArray *myMessageArr;

@property (nonatomic,retain) NSMutableArray *selectedArr;

//点击全选
@property (nonatomic,assign) BOOL isAll;
//点击编辑
@property (nonatomic,assign) BOOL isEditor;

@end
