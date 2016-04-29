//
//  changePasswordVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/3.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface changePasswordVC : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *changeNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *confirmNewPassword;

@property (strong, nonatomic) IBOutlet UIButton *changePasswordConfirm;

@property (nonatomic,retain) NSString *member_id;

@end
