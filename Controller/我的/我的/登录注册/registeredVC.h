//
//  registeredVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registeredVC : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *registeredUserField;
@property (strong, nonatomic) IBOutlet UITextField *registerVerificationField;
@property (strong, nonatomic) IBOutlet UITextField *registerPasswordField;
@property (strong, nonatomic) IBOutlet UITextField *ConfirmPasswordField;

@property (strong, nonatomic) IBOutlet UIView *codeView;
- (IBAction)registerBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *registerBtn;



@end
