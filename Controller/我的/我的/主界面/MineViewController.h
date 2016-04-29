//
//  MineViewController.h
//  ShoppingSuzhou
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *customTableView;

@property (retain,nonatomic) NSArray *titleArr;
@property (retain,nonatomic) NSArray *pictureArr;

@end
