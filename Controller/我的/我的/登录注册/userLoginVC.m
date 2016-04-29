//
//  userLoginVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "userLoginVC.h"
#import "Size.h"
#import "registeredVC.h"
#import "forgotPasswordVC.h"
#import "AFNetworking.h"
#import "AppDelegate.h"


@interface userLoginVC ()


@end

@implementation userLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createView];
}


-(void)createUI
{
    self.title = @"登录";
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
    
    
    
}

-(void)createView
{
    
    self.registered.layer.cornerRadius = 5.0;
    self.registered.layer.borderWidth = 1;
    self.registered.layer.borderColor = [UIColor colorWithRed:183.0/255.0 green:80.0/255.0 blue:81.0/255.0 alpha:1].CGColor;
    [self.registered setTitleColor:[UIColor colorWithRed:228.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    self.login.layer.cornerRadius = 5.0;
    self.login.backgroundColor = kColor;

    
}

-(void)touchBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//忘记密码
- (IBAction)forgotPassword:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    forgotPasswordVC *vc = [[forgotPasswordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)login:(id)sender {
    if (self.userField.text == 0) {
        [MBProgressHUD showError:@"用户名不能为空"];
    }
    else if (self.passwordField.text == 0 )
    {
        [MBProgressHUD showError:@"密码不能为空"];
    }
    else

    {
        
        m_hud = [[MBProgressHUD alloc] initWithWindow:((AppDelegate *)[UIApplication sharedApplication].delegate).window];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:m_hud];
        m_hud.detailsLabelText = @"登录中...";
        [m_hud show:YES];
        
        NSString *username = self.userField.text ;
        NSString *password = self.passwordField.text;
        NSString *client = @"ios";
        NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
        NSString *jcode = [info objectForKey:kJcode];
        NSDictionary *parameters = [[NSDictionary alloc]init];
        if (jcode.length == 0) {
             parameters = [NSDictionary dictionaryWithObjectsAndKeys:username,@"username",password,@"password",client,@"client", nil];
        }
        else
        {
         parameters = [NSDictionary dictionaryWithObjectsAndKeys:username,@"username",password,@"password",client,@"client",jcode,@"jcode", nil];
        }

    
        [WXAFNetwork postRequestWithUrl:kLoginUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription) {
            
            if (isSuccessed) {
                
                NSNumber *code = [resultObject objectForKey:kCode];
                NSDictionary *data = [resultObject objectForKey:kData];
               
                if ([code integerValue] == 200) {
                    
                    m_hud.detailsLabelText = @"登录成功";
                   
                    
                    //NSLog(@"%@",data);
                    NSLog(@"%@",[resultObject objectForKey:kData]);
                    NSString *client = [data objectForKey:kClient];
                    NSString *username = [data objectForKey:kUserName];
                    NSString *key = [data objectForKey:kKey];
                    NSString *uphone = [data objectForKey:kUpPone];
                    NSString *avatar = [data objectForKey:kAvatar];
                    
                    
                    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
                    [info setValue:client forKey:kClient];
                    [info setValue:username forKey:kUserName];
                    [info setValue:key forKey:kKey];
                    [info setValue:uphone forKey:kUpPone];
                    [info setValue:avatar forKey:kAvatar];
                    
                     [info synchronize];
                    
                    m_hud.hidden = YES;
                    
                    [self.navigationController popViewControllerAnimated:YES];
                   
            }
            else
            {
            
                [MBProgressHUD showError:[data objectForKey:kMessage]];
                m_hud.hidden = YES;
            
            }
         }
        else
        {
                [MBProgressHUD showError:kError];
                m_hud.hidden = YES;
            
        }
            

            m_hud.hidden = YES;

        } ];
        
    
}
   // self.login.adjustsImageWhenHighlighted = NO;
   
}

-(void)removeObject
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    //[info removeObjectForKey:kUserId];
    [info removeObjectForKey:kClient];
    [info removeObjectForKey:kUserName];
    [info removeObjectForKey:kKey];
    [info removeObjectForKey:kUpPone];

}


- (IBAction)registered:(id)sender {
    
    self.registered.adjustsImageWhenHighlighted = NO;
    self.hidesBottomBarWhenPushed = YES;
    registeredVC *vc = [[registeredVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
