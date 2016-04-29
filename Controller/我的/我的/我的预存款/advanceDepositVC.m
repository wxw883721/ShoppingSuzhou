//
//  advanceDepositVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/7.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "advanceDepositVC.h"
#import "Size.h"
#import "advanceDetailVC.h"

@interface advanceDepositVC ()

@property (nonatomic,retain) UILabel *balanceLabel;

@end



@implementation advanceDepositVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self createView];
    [self requestData];
    [self createBtn];
}

-(void)createUI
{
    
    self.view.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    self.title = @"我的预存款";
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    
}

-(void)createView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScr_W, 120)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 100, 30)];
    label.text = @"余额（元）";
    label.font = [UIFont systemFontOfSize:Text_Big];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    _balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,70 , KScr_W, 30)];
    [_balanceLabel setTextColor:[UIColor redColor]];
    _balanceLabel.textAlignment = NSTextAlignmentCenter;
    _balanceLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [view addSubview:_balanceLabel];
    [self.view addSubview:view];
}

-(void)requestData
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key", nil];
    [WXAFNetwork getRequestWithUrl:kAdvance parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (isSuccessed) {
             NSNumber *code = [resultObject objectForKey:kCode];
             NSDictionary *data = [resultObject objectForKey:kData];
             if ([code integerValue] == 200) {
                 
                 
                 _balanceLabel.text = [data objectForKey:@"available_predeposit"];
                 NSString *freeze_predeposit = [data objectForKey:@"freeze_predeposit"];
                 NSLog(@"%@",freeze_predeposit);
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

-(void)createBtn
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 160, KScr_W-100, 40)];
    btn.backgroundColor = kColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"预存款明细" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Big];
    btn.layer.cornerRadius = 5.0;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
}

-(void)btnClick:(UIButton *)btn
{
    self.hidesBottomBarWhenPushed = YES;
    advanceDetailVC *vc = [[advanceDetailVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}


-(void)touchBtn:(UIButton *)btn
{

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
