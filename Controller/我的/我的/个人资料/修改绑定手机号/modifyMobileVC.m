//
//  modifyMobileVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/9.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "modifyMobileVC.h"
#import "personalMessageVC.h"
#import "Size.h"
#import "codeButton.h"


@interface modifyMobileVC ()
{

    codeButton *codeBtn;
}


@end

@implementation modifyMobileVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createUI];
    [self builtView];
}


-(void)createUI
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改绑定手机号";
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    self.modifyMobile.placeholder = self.mobile;
    //self.modifyMobile.tintColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1];
    
    self.modifyView.layer.borderColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1].CGColor;
    self.modifyView.layer.borderWidth = 1.0;
    
}

-(void)builtView
{
    
    codeBtn = [[codeButton alloc]initWithFrame:CGRectMake(0, 0,self.validationCode.frame.size.width , self.validationCode.frame.size.height)];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [codeBtn setBackgroundColor: [UIColor clearColor]];
    codeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Small];
    codeBtn.backgroundColor = kColor;
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    codeBtn.layer.cornerRadius = 5.0;
    codeBtn.timeOut = 59 ;
    [self.validationCode addSubview:codeBtn];
    [codeBtn addTarget:self action:@selector(codeMessageClick:) forControlEvents:UIControlEventTouchUpInside];

    
    
    self.submitMobile.layer.cornerRadius = 5.0;
    self.submitMobile.backgroundColor =kColor;
    [self.submitMobile setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitMobile setTitle:@"确认修改" forState:UIControlStateNormal];
    self.submitMobile.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Big];
    
    [self.submitMobile addTarget:self action:@selector(submitMobileClick:) forControlEvents:UIControlEventTouchUpInside];

}


-(void)codeMessageClick:(UIButton *)btn
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


-(void)submitMobileClick:(UIButton *)btn
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSString *submit = @"ok";
    NSString *dycode = self.inputnCode.text;
    NSString *new_phone = self.inputNewMobile.text;
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",submit,@"submit",dycode,@"dycode",new_phone,@"new_phone", nil];
    [WXAFNetwork postRequestWithUrl:kBindMobile parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
     {
        // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
         if (isSuccessed) {
             
             NSNumber *code = [responseObject objectForKey:kCode];
             NSDictionary *data = [responseObject objectForKey:kData];
             
             if ([code integerValue] == 200) {
                 //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 [MBProgressHUD showSuccess:[data objectForKey:kMessage]];
                 
                 
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
     
     }];

}

-(void)touchBtn:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
