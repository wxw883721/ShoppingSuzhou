//
//  SushopViewController.h
//  ShoppingSuzhou
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "DesViewController.h"

@interface SushopViewController : UIViewController

+ (NSArray *)FindLeftSource1:(NSArray *)leftSource;
+ (NSArray *)FindLeftSource2:(NSArray *)leftSource andScID:(NSString *)sc_id;

+ (NSArray *)FindRightSource1:(NSArray *)rightSource;
+ (NSArray *)FindRightSource2:(NSArray *)rightSource andRingID:(NSString *)ring_id;

@end
