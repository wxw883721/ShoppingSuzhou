//
//  ModifyLoginPassVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/10.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "ModifyLoginPassVC.h"
#import "Size.h"
#import "codeButton.h"

@interface ModifyLoginPassVC ()
{
    codeButton *codeBtn;
    
}

@end

@implementation ModifyLoginPassVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    [self builtBtnUI];
}

-(void)createUI
{

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改登录密码";
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    self.ModifyLoginMobileView.layer.borderWidth = 1.0;
    self.ModifyLoginMobileView.layer .borderColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0].CGColor;
    
    self.ModifyLoginPassView.layer.borderWidth = 1.0;
    self.ModifyLoginPassView.layer.borderColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0].CGColor;


    self.ModifyMobile.placeholder = self.mobile;
}

-(void)builtBtnUI
{
   
    codeBtn = [[codeButton alloc]initWithFrame:CGRectMake(0, 0,self.ModifyObtainCode.frame.size.width , self.ModifyObtainCode.frame.size.height)];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [codeBtn setBackgroundColor: [UIColor clearColor]];
    codeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Small];
    codeBtn.backgroundColor = kColor;
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    codeBtn.layer.cornerRadius = 5.0;
    codeBtn.timeOut = 59 ;
    [self.ModifyObtainCode addSubview:codeBtn];
    [codeBtn addTarget:self action:@selector(codeMobileClick:) forControlEvents:UIControlEventTouchUpInside];
    

    self.ModifyAllLogin .backgroundColor = kColor;
    self.ModifyAllLogin.layer.cornerRadius = 5.0;
    [self.ModifyAllLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ModifyAllLogin setTitle:@"修 改" forState:UIControlStateNormal];
    self.ModifyAllLogin.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Big];
    [self.ModifyAllLogin addTarget:self action:@selector(ModifyAllLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    

}

-(void)ModifyAllLoginClick:(UIButton *)btn
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSString *dycode = self.ModifyCode.text;
    NSString *old_passwd = self.ModifyOldLogin.text;
    NSString *new_passwd = self.ModifyNewLogin.text;
    NSString *new_password_confirm = self.ModifyAgainLogin.text;
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",dycode,@"dycode",old_passwd,@"old_passwd",new_passwd,@"new_passwd",new_password_confirm,@"new_password_confirm", nil];
    
    [WXAFNetwork postRequestWithUrl:kChangePassword parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
     {
         //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
         
         if (isSuccessed) {
             
             NSNumber *code = [responseObject objectForKey:kCode];
             NSDictionary *data = [responseObject objectForKey:kData];
             
             if ([code integerValue] == 200) {
                 //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 [MBProgressHUD showSuccess:@"修改密码成功"];
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else
             {
             
                 [MBProgressHUD showError:[data objectForKey:kMessage]];
             }
         }
     else
     {
     
         [MBProgressHUD showError:kError];
     }
      
  }
     ];

}


-(void)codeMobileClick:(UIButton *)btn
{

    NSString *phone = self.mobile;
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", nil];
    [WXAFNetwork getRequestWithUrl:kOtherCodeUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription) {
        
        NSLog(@"%@",kCodeUrl);
        
        
        if (isSuccessed) {
            NSLog(@"验证码：%@",responseObject);
            
            NSNumber *code = [responseObject objectForKey:kCode];
            NSDictionary *data = [responseObject objectForKey:kData];
            
            if ([code integerValue] == 200) {
            
                [codeBtn startCountDown];
                [MBProgressHUD showSuccess:@"验证码已发送"];
                
                NSLog(@"发送成功");
            }
            else
            {
                [MBProgressHUD showError:[data objectForKey:kMessage]];
            }
            
        }
        else
        {
            [MBProgressHUD showError:kError];
            
        }
    }
     ];


}



-(void)touchBtn:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
