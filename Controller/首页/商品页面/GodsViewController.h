//
//  GodsViewController.h
//  ShoppingSuzhou
//
//  Created by apple on 15/5/21.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "LHSecondViewController.h"

@interface GodsViewController : LHSecondViewController

@property (nonatomic, strong) NSString *okwords;
@property (nonatomic, strong) NSString *order;
@property (nonatomic, strong) NSString *gc_id_1;
@property (nonatomic, strong) NSString *gc_id_2;

@property (nonatomic,retain) UITableView *oneCustomTableView;
@property (nonatomic,retain) UITableView *twoCustomTableView;

@property (nonatomic,retain) UITableView *businessCustomTableView;

@property (nonatomic,retain) UIButton *classificationBtn;

@property (nonatomic,retain) UIButton *businessBtn;

@property (nonatomic,retain) UILabel *classificationLabel;
@property (nonatomic,retain) UILabel *businessLabel;

@property (nonatomic,retain) NSMutableArray *classificationArr;
@property (nonatomic,retain) NSArray *businessArr;

@property (nonatomic,retain) NSString *gc_id;

@property (nonatomic,retain) NSMutableArray *classificationArr2;



@end
