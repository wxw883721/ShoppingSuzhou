//
//  forgotPasswordVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/28.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^forgotBlock)(NSString *member_id);

@interface forgotPasswordVC : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *forgotPasswordMobile;
@property (strong, nonatomic) IBOutlet UITextField *forgotPasswordCode;
@property (strong, nonatomic) IBOutlet UIButton *fogotPasswordDetermine;


@property (strong, nonatomic) IBOutlet UIView *forgetPasswordMobileView;
@property (strong, nonatomic) IBOutlet UIView *forgetPasswordCodeView;
@property (strong, nonatomic) IBOutlet UIView *obtainCodeView;

@end
