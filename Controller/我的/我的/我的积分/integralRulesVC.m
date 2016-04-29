//
//  integralRulesVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/17.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "integralRulesVC.h"
#import "Size.h"

@interface integralRulesVC ()

@end

@implementation integralRulesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


-(void)createUI
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"积分规则";
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, KScr_W, KScr_H-64)];
    [self.view addSubview:web];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kIntegralRules]];
    [web loadRequest:request];
    
}

-(void)touchBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
