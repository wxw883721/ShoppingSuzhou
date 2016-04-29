//
//  integralMallDetailVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/1.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "integralMallDetailVC.h"
#import "Size.h"
#import "integralMallDetailModel.h"
#import "integralExchangeVC.h"

@interface integralMallDetailVC ()
{
    
    integralMallDetailModel *model;
    
}

@property (nonatomic,retain)NSMutableArray *integralDetailArr;

@end


@implementation integralMallDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self createUI];
    
}

-(void)createUI
{
    self.view.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    self.title = @"积分商城";
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    self.integralMallDetailView.backgroundColor = [UIColor whiteColor];
    self.exchangeNumber.layer.borderWidth = 1.0;
    self.exchangeNumber.layer.borderColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0].CGColor;
    self.exchangeNumber.layer.cornerRadius = 5.0;
    
    self.exchangeNumber.keyboardType = UIKeyboardTypeNumberPad;
    
    self.exchageIntegralBtn.backgroundColor = kColor;
    [self.exchageIntegralBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.exchageIntegralBtn setTitle:@"我要兑换" forState:UIControlStateNormal];
    self.exchageIntegralBtn.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Big];
    self.exchageIntegralBtn.layer.cornerRadius = 5.0;
    [self.exchageIntegralBtn addTarget:self action:@selector(exchageIntegralBtn:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    model = [[integralMallDetailModel alloc]init];
    //
    //    self.integralDetailArr = [[NSMutableArray alloc]init];
    
}

-(void)requestData
{
    if (!model) {
        model = [[integralMallDetailModel alloc]init];
    }
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSString *pgoods_id = self.pgoods_id;
    NSString *op = @"pinfo";
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",pgoods_id,@"id",op,@"op", nil];
    
    [WXAFNetwork getRequestWithUrl:kIntegralDetailUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
     
     {
         if (isSuccessed) {
             
             NSNumber *code = [resultObject objectForKey:kCode];
             NSDictionary *data = [resultObject objectForKey:kData];
             NSLog(@"%@",data);
             if ([code integerValue] == 200) {
                 
                 NSString *pcartnum = [data objectForKey:@"pcartnum"];
                 NSDictionary *member_info = [data objectForKey:@"member_info"];
                 NSString *member_points = [member_info objectForKey:@"member_points"];
                 NSString *member_avatar = [member_info objectForKey:@"member_avatar"];
                 
                 NSDictionary *prodinfo = [data objectForKey:@"prodinfo"];
                 [model setValuesForKeysWithDictionary:prodinfo];
                 
                 
                 [self.integralMallDetailImage sd_setImageWithURL:[NSURL URLWithString:model.pgoods_image]placeholderImage:[UIImage imageNamed:@"200-200.png"] options:0 completed:nil];
                 self.integralMallDetailScore.text = [NSString stringWithFormat:@"我的积分: %@积分",member_points];
                 self.cashNeedsIntegral.text = [NSString stringWithFormat:@"兑换所需: %@积分",model.pgoods_points];
                 self.numberRemaining.text = [NSString stringWithFormat:@"剩余数量: %@个",model.pgoods_storage];
                 self.exchangeMostNumber.text = [NSString stringWithFormat:@"*此礼品每单限兑%@个",model.pgoods_limitnum];
                 
             }
             else
             {
                 
             }
         }
         else
         {
             [MBProgressHUD showError:kError];
         }
         
     }];
    
}


-(void)exchageIntegralBtn:(UIButton *)btn
{
    if (self.exchangeNumber.text.length == 0) {
        
        [MBProgressHUD showError:@"请输入要兑换的数量"];
    }
    else if ([self.exchangeNumber.text intValue] > [model.pgoods_limitnum intValue])
    {
        [MBProgressHUD showError:@"兑换数量超过每单限兑量"];
        
    }
    else if ([self.exchangeNumber.text intValue] > [model.pgoods_storage intValue])
    {
        [MBProgressHUD showError:@"兑换量超过剩余数量"];
        
    }
    else
    {
        NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
        NSString *key = [info objectForKey:kKey];
        
        NSString *pgid = model.pgoods_id;
        NSString *quantity = self.exchangeNumber.text;
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",pgid,@"pgid",quantity,@"quantity", nil];
        
        [WXAFNetwork getRequestWithUrl:kPointCart parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
         {
             if (isSuccessed) {
                 
                 NSNumber *code = [resultObject objectForKey:kCode];
                 NSDictionary *data = [resultObject objectForKey:kData];
                 
                 if ([code integerValue] == 200) {
                     
                     //                     integralPointCartModel *pointModel = [[integralPointCartModel alloc]init];
                     
                     //                     NSDictionary *dict = [data objectForKey:@"order_arr"];
                     //                     [pointModel setValuesForKeysWithDictionary:dict];
                     //
                     NSLog(@"%@",resultObject);
                     NSDictionary *dict = [resultObject objectForKey:@"data"];
                     
                     
                     //                     integralSuccessVC *vc = [[integralSuccessVC alloc]init];
                     //                     vc.name = self.model.pgoods_name;
                     //                     vc.code = self.code;
                     //                     vc.phone = self.integralExchangePhone.text;
                     self.hidesBottomBarWhenPushed = YES;
                     integralExchangeVC *vc = [[integralExchangeVC alloc]init];
                     vc.model = model;
                     vc.exchangeDict = dict;
                     [self.navigationController pushViewController:vc animated:YES];
                     
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
