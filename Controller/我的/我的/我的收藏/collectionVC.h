//
//  collectionVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/21.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface collectionVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,retain) UITableView *customTableView;

@property (nonatomic,retain) NSString *goods_id;
@end
