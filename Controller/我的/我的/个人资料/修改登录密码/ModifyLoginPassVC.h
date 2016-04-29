//
//  ModifyLoginPassVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/10.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyLoginPassVC : UIViewController
@property (strong, nonatomic) IBOutlet UIView *ModifyLoginPassView;
@property (strong, nonatomic) IBOutlet UIView *ModifyLoginMobileView;

@property (strong, nonatomic) IBOutlet UITextField *ModifyOldLogin;
@property (strong, nonatomic) IBOutlet UITextField *ModifyNewLogin;
@property (strong, nonatomic) IBOutlet UITextField *ModifyAgainLogin;
@property (strong, nonatomic) IBOutlet UITextField *ModifyMobile;
@property (strong, nonatomic) IBOutlet UITextField *ModifyCode;


@property (strong, nonatomic) IBOutlet UIButton *ModifyObtainCode;
@property (strong, nonatomic) IBOutlet UIButton *ModifyAllLogin;

@property (copy,nonatomic) NSString *mobile;

@end
