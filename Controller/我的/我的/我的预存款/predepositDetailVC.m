//
//  predepositDetailVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/8.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "predepositDetailVC.h"
#import "predepositModel.h"


@interface predepositDetailVC ()
{
    predepositModel *model;

}

@end

@implementation predepositDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self requestData];
}

-(void)createUI
{
 
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"明细";
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
}

-(void)requestData
{
    if (!model) {
        model = [[predepositModel alloc]init];
    }
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSString *lg_id = self.lg_id;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",lg_id,@"lg_id", nil];
    [WXAFNetwork getRequestWithUrl:kPredeposit parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
     {
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (isSuccessed) {
             NSNumber *code = [resultObject objectForKey:kCode];
             NSDictionary *data = [resultObject objectForKey:kData];
             if ([code integerValue] == 200) {
                 
                 [model setValuesForKeysWithDictionary:data];
                 self.predepositMoney.text = [NSString stringWithFormat:@"发生金额: %@",model.lg_av_amount];
                 self.predepositTime.text = [NSString stringWithFormat:@"创建时间: %@",model.lg_add_time];
                 self.predepositInstructions.text = model.lg_desc;
                 self.predepositInstructions.numberOfLines = 0;
                 self.predepositInstructions.lineBreakMode = NSLineBreakByWordWrapping;
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
    // Dispose of any resources that can be recreated.
}


@end
