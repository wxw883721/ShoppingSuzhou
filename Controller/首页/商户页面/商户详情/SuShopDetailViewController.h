//
//  SuShopDetailViewController.h
//  ShoppingSuzhou
//
//  Created by apple on 15/7/31.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "DesViewController.h"

@interface SuShopDetailViewController : DesViewController

@property (strong,nonatomic) NSString* store_id;
@property (nonatomic, strong) UIWebView *phoneCallWebView;
@property (copy,nonatomic)  NSString *backRootVC;

@end
