//
//  LHRecommendViewController.h
//  ShoppingSuzhou
//
//  Created by YQ on 15/5/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "LHRootViewController.h"
#import "DesViewController.h"

@interface LHRecommendViewController : DesViewController


@property (strong,nonatomic)  NSString *store_id;
@property (nonatomic,strong) UITableView *tableView;

@end
