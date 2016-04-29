//
//  userLoginVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface userLoginVC : UIViewController
{
    MBProgressHUD *m_hud;
}
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)forgotPassword:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)registered:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *registered;



@end
