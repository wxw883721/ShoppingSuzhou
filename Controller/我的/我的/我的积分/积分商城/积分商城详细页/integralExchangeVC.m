//
//  integralExchangeVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/6.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "integralExchangeVC.h"

#import "integralSuccessVC.h"

@interface integralExchangeVC ()

@end

@implementation integralExchangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createMessage];
}

-(void)createUI
{
    self.title = @"积分商城";
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    self.integralExchangePhone.layer.borderWidth = 1.0;
    self.integralExchangePhone.layer.borderColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0].CGColor;
    self.integralExchangePhone.layer.cornerRadius = 5.0;
    
    self.integralExchangePhone.keyboardType = UIKeyboardTypeNumberPad;
    
    self.integralExchangeBtn.backgroundColor = kColor;
    [self.integralExchangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.integralExchangeBtn setTitle:@"我要兑换" forState:UIControlStateNormal];
    self.integralExchangeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Big];
    self.integralExchangeBtn.layer.cornerRadius = 5.0;
    [self.integralExchangeBtn addTarget:self action:@selector(integralExchangeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)createMessage
{
    
    self.integralExchangeMessage.text = [NSString stringWithFormat:@"你将要使用【%d】积分兑换【%@】",[[self.exchangeDict objectForKey:@"pgoods_pointall"]intValue] ,self.model.pgoods_name];
    self.integralExchangeAdress.text = [NSString stringWithFormat:@"兑换地址:%@",self.model.pgoods_address];
    self.integralExchangePrompt.text = @"*请确保手机号的正确性，我们将发送兑换码至您的手机。";
    self.integralExchangePrompt.numberOfLines = 0;
    self.integralExchangePrompt.lineBreakMode = NSLineBreakByCharWrapping;
    
}

-(void)integralExchangeBtn:(UIButton *)btn
{
    NSString *name = self.model.pgoods_name;
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSString *phone = self.integralExchangePhone.text;
    // NSLog(@"%@",self.cartModel);
 
    NSString *code = [self.exchangeDict objectForKey:@"order_sn"];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",code,@"code",key,@"key",phone,@"phone", nil];
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WXAFNetwork getRequestWithUrl:kSendMsg parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
     {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (isSuccessed) {
             
             NSNumber *code1 = [resultObject objectForKey:kCode];
             NSDictionary *data = [resultObject objectForKey:kData];
             
             if ([code1 integerValue] == 200) {
                 
                 
                 //[MBProgressHUD showSuccess:[data objectForKey:kMessage]];
                 integralSuccessVC *vc = [[integralSuccessVC alloc]init];
                 self.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:vc animated:NO];
                 
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
