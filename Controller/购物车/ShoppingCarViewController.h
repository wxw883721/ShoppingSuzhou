//
//  ShoppingCarViewController.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/17.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shoppingCarCell.h"

@interface ShoppingCarViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,shoppingCarCellDelegate>
{
    NSMutableArray *m_selectedItemArray;
    
    NSMutableArray *editStateArray;
    BOOL  isSelectedAll;
    BOOL isEditState;
}

@property (nonatomic,retain) UITableView *customTableView;
@property (nonatomic,retain) UIButton *button;
@property (nonatomic, assign) BOOL isPop;

@end
