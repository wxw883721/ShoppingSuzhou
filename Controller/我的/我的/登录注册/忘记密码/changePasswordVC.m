//
//  changePasswordVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/3.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "changePasswordVC.h"
#import "Size.h"
#import "forgotPasswordVC.h"
#import "MineViewController.h"

@interface changePasswordVC ()

@property(weak,nonatomic) forgotPasswordVC *forget;

@end

@implementation changePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self builtTitleView];
}

-(void)createUI
{
    self.title = @"忘记密码";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;


}

-(void)builtTitleView
{
   self.changeNewPassword.placeholder = @"请输入6-16位新密码";
   self.confirmNewPassword.placeholder = @"请再次输入新密码";

    //[self.changeNewPassword setValue:[UIFont boldSystemFontOfSize:17.0] forKey:@"placeholderLabel.font"];
    //[self.confirmNewPassword setValue:[UIFont boldSystemFontOfSize:17.0] forKey:@"placeholderLabel.font"];
   
    self.changePasswordConfirm.layer.cornerRadius = 5.0;
    self.changePasswordConfirm.backgroundColor = kColor;
    [self.changePasswordConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.changePasswordConfirm.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Big];
    [self.changePasswordConfirm addTarget:self action:@selector(changePasswordConfirm:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)changePasswordConfirm:(UIButton *)btn
{
        if (self.changeNewPassword.text.length == 0) {
            [MBProgressHUD showError:@"请输入密码"];
        }
        else if (![self.confirmNewPassword.text isEqualToString:self.changeNewPassword.text])
        {
            [MBProgressHUD showError:@"确认密码与新密码不相符"];
        
        }
        else
        {
        NSString *member_id = self.member_id;
        NSString *submit = @"sure";
        NSString *passwd = self.changeNewPassword.text;
        NSString *password_confirm = self.confirmNewPassword.text;
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:submit,@"submit",member_id,@"member_id",passwd,@"passwd",password_confirm,@"password_confirm", nil];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WXAFNetwork postRequestWithUrl:kTwoChangeUrl parameters:parameters resultBlock:^(BOOL isSuccessed,id resultObject,NSString *errorDescription)
         
         {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if (isSuccessed) {
                 NSNumber *code = [resultObject objectForKey:kCode];
                 
                 if ([code integerValue] == 200) {
                     
                     [MBProgressHUD showSuccess:@"密码修改成功"];
                     MineViewController *VC = [[MineViewController alloc]init];
                     [self.navigationController pushViewController:VC animated:NO];
                     
                 }
                 else
                 {
                     [MBProgressHUD showError:@"修改失败"];
                 }
             }
         else
         {
             [MBProgressHUD showError:kError];
         }
         
         
         }];
    
  
      }
}
-(void)touchBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.changeNewPassword resignFirstResponder];
    [self.confirmNewPassword resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
