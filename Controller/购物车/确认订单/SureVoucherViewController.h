//
//  SureVoucherViewController.h
//  ShoppingSuzhou
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 SU. All rights reserved.
//

@protocol sureVoucherDelegae <NSObject>

-(void)cellDidClick:(NSDictionary *)voucherDic andRow:(NSString *)row;

@end

#import <UIKit/UIKit.h>

@interface SureVoucherViewController : UIViewController

@property (strong,nonatomic)  NSArray *voucherArr;
@property (strong,nonatomic)  NSString *row;

@property (nonatomic,weak) id<sureVoucherDelegae>my_delegate;

@end
