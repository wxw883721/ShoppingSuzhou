//
//  IntegralMallVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/25.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralMallVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView *customTableView;
@property (nonatomic,retain) NSMutableArray *integralArr;

@property (nonatomic,copy) NSString *pgoods_id;

@end
