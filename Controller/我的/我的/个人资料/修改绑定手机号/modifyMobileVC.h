//
//  modifyMobileVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/9.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface modifyMobileVC : UIViewController


@property (strong, nonatomic) IBOutlet UIView *modifyView;
@property (strong, nonatomic) IBOutlet UITextField *inputNewMobile;
@property (strong, nonatomic) IBOutlet UIButton *validationCode;
@property (strong, nonatomic) IBOutlet UITextField *modifyMobile;

@property (strong, nonatomic) IBOutlet UITextField *inputnCode;
@property (strong, nonatomic) IBOutlet UIButton *submitMobile;

@property (copy,nonatomic) NSString *mobile;

@end
