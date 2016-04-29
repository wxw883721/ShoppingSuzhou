//
//  integralVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/2.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "integralVC.h"
#import "Size.h"
#import "integralModel.h"
#import "UIImageView+WebCache.h"
#import "integralRulesVC.h"
#import "IntegralMallVC.h"

@interface integralVC ()
{
    integralModel *model;

}

@end

@implementation integralVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self builtView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
   [self requestData];

}

-(void)createUI
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的积分";
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 40, 0, 60, 30)];
    [button2 setTitle:@"签到" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.backgroundColor = kloginColor;
    button2.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [button2 addTarget:self action:@selector(signBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
    
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.rightBarButtonItem = item2;
    
    
    [self.integralRulesBtn addTarget:self action:@selector(integralRulesBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.integralMallBtn addTarget:self action:@selector(integralMallBtn:) forControlEvents:UIControlEventTouchUpInside];
   // [self.integralPortraitImage setImage:self.model.avatar];
  
    
}

-(void)builtView
{
    self.integralPortraitImage.backgroundColor = [UIColor clearColor];
    self.integralPortraitImage.layer.masksToBounds = YES;
    self.integralPortraitImage.layer.cornerRadius = 30.0;
    self.integralHeadView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"个人中心_banner.jpg"]];
    self.integralImage1.backgroundColor = kLine;
    self.integralImage2.backgroundColor = kLine;
    
    self.integralLineImage.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 9, KScr_W, 1)];
    image.backgroundColor = kLine;
    [self.integralLineImage addSubview:image];
    
}

//请求数据
-(void)requestData
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSString *url = [NSString stringWithFormat:@"%@",kIntegral];
    NSLog(@"%@",url);
    model =  [[integralModel alloc]init];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WXAFNetwork postRequestWithUrl:kIntegral parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
     {
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (isSuccessed)
         {
                NSNumber *code = [resultObject objectForKey:kCode];
                NSDictionary *data = [resultObject objectForKey:kData];
                if ([code integerValue] == 200) {
                [model setValuesForKeysWithDictionary:data];
                            
                self.integralLabel.text = [NSString stringWithFormat:@"%@积分", model.points];
                              
                [self.integralPortraitImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"200-200.png"] options:0 completed:nil];
                              
                NSLog(@"%@",self.integralLabel.text);
                NSLog(@"%@",data);
              
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

-(void)signBtn:(UIButton *)btn
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key", nil];
    
    [WXAFNetwork getRequestWithUrl:kSignIntegral parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
     {
         if (isSuccessed) {
             NSNumber *code = [resultObject objectForKey:kCode];
               NSLog(@"%@", [resultObject objectForKey:kData]);
             
             if ([code integerValue] == 200) {
               
                 [MBProgressHUD showSuccess:@"签到成功"];
                 
                  self.integralLabel.text = [NSString stringWithFormat:@"%d积分",[model.points intValue] +1];
             }
             else
             {
                 [MBProgressHUD showError:@"你今天已经签过到了"];
             }
         }
         else
         {
             [MBProgressHUD showError:kError];
         }
     }
     ];
    
}

-(void)integralMallBtn:(UIButton *)btn
{
   
    self.hidesBottomBarWhenPushed = YES;
    IntegralMallVC *vc = [[IntegralMallVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}


-(void)integralRulesBtn:(UIButton *)btn
{
    self.hidesBottomBarWhenPushed = YES;
    integralRulesVC *vc = [[integralRulesVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end

