//
//  forgotPasswordVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/28.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "forgotPasswordVC.h"
#import "Size.h"
#import "codeButton.h"
#import "changePasswordVC.h"

@interface forgotPasswordVC ()
{
    codeButton *codeBtn;
    
}

@end

@implementation forgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self builtForgetView];
    [self createCodeButton];
}

-(void)createUI
{
   
   
    self.title = @"忘记密码";
    //self.view.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];
    //导航条字体颜色,大小
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;


}

-(void)builtForgetView
{
    self.forgotPasswordMobile.placeholder = @"请输入手机号";
    self.forgotPasswordCode.placeholder = @"请输入输入验证码";
    [self.forgotPasswordMobile setValue:[UIFont boldSystemFontOfSize:Text_Big] forKeyPath:@"placeholderLabel.font"];
    [self.forgotPasswordCode setValue:[UIFont boldSystemFontOfSize:Text_Big] forKeyPath:@"placeholderLabel.font"];
    
    self.fogotPasswordDetermine.backgroundColor = kColor;
    self.fogotPasswordDetermine.layer.cornerRadius = 5.0;
}

-(void)createCodeButton
{
    codeBtn = [[codeButton alloc]initWithFrame:CGRectMake(0, 0,self.obtainCodeView.frame.size.width , self.obtainCodeView.frame.size.height)];
    [codeBtn setTitle:@"获取手机验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [codeBtn setBackgroundColor: [UIColor clearColor]];
    codeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Small];
    codeBtn.backgroundColor = kColor;
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    codeBtn.layer.cornerRadius = 5.0;
    codeBtn.timeOut = 59 ;
    [self.obtainCodeView addSubview:codeBtn];
    [codeBtn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //button点击事件
    [self.fogotPasswordDetermine addTarget:self action:@selector(determineBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)touchBtn:(UIButton *)btn
{
  [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)determineBtn:(UIButton *)btn
{
    if (self.forgotPasswordMobile.text == 0) {
        [MBProgressHUD showError:@"请输入手机号"];
    }
    else if (self.forgotPasswordCode.text == 0)
    {
        [MBProgressHUD showError:@"请输入验证码"];
    }
    else
    {
    
    NSString *submit = @"ok";
    NSString *phone = self.forgotPasswordMobile.text;
    NSString *dycode = self.forgotPasswordCode.text;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:submit,@"submit",phone,@"phone",dycode,@"dycode", nil];
    [WXAFNetwork postRequestWithUrl:kOneChangeUrl parameters:parameters resultBlock:^(BOOL isSuccessed,id resultObject,NSString *errorDescription)
     {
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (isSuccessed) {
             NSNumber *code = [resultObject objectForKey:kCode];
             if ([code integerValue] == 200) {
                 
                 NSDictionary *data = [resultObject objectForKey:kData];
                 
                 changePasswordVC *vc = [[changePasswordVC alloc]init];
                 vc.member_id = [data objectForKey:@"member_id"];
                 self.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:vc animated:YES];
                 
                 NSLog(@"成功");
             }
             else
             {
                 [MBProgressHUD showError:[resultObject objectForKey:kMessage]];
             
             }
         }
     
     }
     ];
    }

}

-(void)codeBtnClick:(UIButton *)btn
{
    
    if (self.forgotPasswordMobile.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号"];
    }
    else
    {
        [codeBtn startCountDown];
        
        NSString *phone = self.forgotPasswordMobile.text;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", nil];
        [WXAFNetwork getRequestWithUrl:kOtherCodeUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription) {
            
            NSLog(@"%@",kCodeUrl);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (isSuccessed) {
                NSLog(@"验证码：%@",responseObject);
                
                NSNumber *code = [responseObject objectForKey:kCode];
                 NSDictionary *data = [responseObject objectForKey:kData];
                
                if ([code integerValue] == 200) {
                    
                    
                    [MBProgressHUD showSuccess:@"发送成功"];

                    NSLog(@"发送成功");
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
