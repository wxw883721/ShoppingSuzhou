//
//  registeredVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "registeredVC.h"
#import "codeButton.h"
#import "Size.h"

@interface registeredVC ()
{
    codeButton *codeBtn;

}

@property (nonatomic,copy) NSString *token;

@end

@implementation registeredVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createCodeButton];
    
}

-(void)createUI
{
    self.title = @"注册";
    self.view.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];
    //导航条字体颜色,大小
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
 
    self.registerPasswordField.secureTextEntry = YES;
    self.ConfirmPasswordField.secureTextEntry = YES;
    //注册按钮
    self.registerBtn.layer.cornerRadius = 5.0;
    self.registerBtn.backgroundColor = kColor;
    self.registerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    //[self.registerBtn setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
}

-(void)createCodeButton
{
    codeBtn = [[codeButton alloc]initWithFrame:CGRectMake(0, 0,self.codeView.frame.size.width-10 , self.codeView.frame.size.height)];
    [codeBtn setTitle:@"获取手机验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [codeBtn setBackgroundColor: [UIColor clearColor]];
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:Text_Small];
    codeBtn.timeOut = 59 ;
    [self.codeView addSubview:codeBtn];
    [codeBtn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}


-(void)touchBtn:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];

}



- (IBAction)registerBtn:(id)sender {
    
    if (self.registeredUserField.text.length == 0) {
        [MBProgressHUD showError:@"用户名不能为空"];
    }
    else if(self.registerVerificationField.text.length == 0 )
    {
        [MBProgressHUD showError:@"验证码不能为空"];
    
    }
    else if (self.registerPasswordField.text.length == 0)
    {
        [MBProgressHUD showError:@"密码不能为空"];
    }
    else if (self.ConfirmPasswordField.text == 0)
    {
      
        [MBProgressHUD showError:@"请再次输入密码"];
    }
    else if(![self.registerPasswordField.text isEqualToString:self.ConfirmPasswordField.text])
    {
        [MBProgressHUD showError:@"输入的密码不一致"];
    }
    else
    {
        NSString *username = self.registeredUserField.text;
        NSString *password = self.registerPasswordField.text;
        NSString *password_confirm = self.ConfirmPasswordField.text;
        NSString *phone = self.registeredUserField.text;
        NSString *dycode = self.registerVerificationField.text;
        NSString *client = @"ios";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:username,@"username",password,@"password",password_confirm,@"password_confirm",phone,@"phone",dycode,@"dycode",client,@"client", nil];
        [WXAFNetwork postRequestWithUrl:kRedistUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if (isSuccessed) {
                 NSNumber *code = [responseObject objectForKey:kCode];
                 NSDictionary *data = [responseObject objectForKey:kData];
                 
                 if ([code integerValue] == 200) {
                     //设置注册成功后的方法
                     
                     [MBProgressHUD showSuccess:@"注册成功"];
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
    
}


//获取验证码
-(void)codeBtnClick:(UIButton *)sender
{
    if (self.registeredUserField.text.length == 0) {
        [MBProgressHUD showError:@"请输入用户名"];
    }
   else
   {
       [codeBtn startCountDown];
       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       NSString *phone = self.registeredUserField.text;
       NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", nil];
       [WXAFNetwork getRequestWithUrl:kCodeUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription) {
           
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
           if (isSuccessed) {
               NSLog(@"验证码：%@",responseObject);
               
               NSNumber *code = [responseObject objectForKey:kCode];
               NSDictionary *data = [responseObject objectForKey:kData];
               if ([code integerValue] == 200) {
                   
                   [MBProgressHUD showSuccess:@"已发送验证码"];
                   
               }
               else
               {
                   if (self.view == nil) self.view = [[UIApplication sharedApplication].windows lastObject];
                   // 快速显示一个提示信息
                   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                   hud.detailsLabelText = [NSString stringWithFormat:@"%@",[data objectForKey:kMessage]];
                   
                   // 再设置模式
                   hud.mode = MBProgressHUDModeCustomView;
                   
                   // 隐藏时候从父控件中移除
                   hud.removeFromSuperViewOnHide = YES;
                   
                   // 1秒之后再消失
                   [hud hide:YES afterDelay:0.7];
               
               }
               
           }
           else
           {
               [MBProgressHUD showError:kError];
           
           }
       }
        ];
   
   }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
