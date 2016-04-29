//
//  addressSelectVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/8/18.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addressSelectCell.h"


@interface addressSelectVC : UIViewController<UITableViewDataSource,UITableViewDelegate,addressSelectCell>


@property (nonatomic,retain) UITableView *customTableView;

@property (nonatomic,retain) NSMutableArray *addressArr;

@property (nonatomic,retain) NSString *address;

@end
