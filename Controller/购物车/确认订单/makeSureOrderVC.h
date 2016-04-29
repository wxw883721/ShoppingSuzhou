//
//  makeSureOrderVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/24.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "makeSureOrderCell.h"

@interface makeSureOrderVC : UIViewController<UITableViewDataSource,UITableViewDelegate,makeSureOrderCellDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSDictionary *selectedDic;
@property (nonatomic,retain) UITableView *customTableView;

@property (nonatomic,strong) NSString *ifcart;

@property (nonatomic,strong) NSMutableArray *payMessageArray;

@end
