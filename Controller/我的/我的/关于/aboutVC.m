//
//  aboutVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/15.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "aboutVC.h"
#import "Size.h"

@interface aboutVC ()
{
    UIWebView *web;

}

@end

@implementation aboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
   // [self requestData];
    
}

-(void)createUI
{

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于";
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    

    web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, KScr_W, KScr_H-64)];
    [self.view addSubview:web];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kAbout]];
    [web loadRequest:request];
    
}


//-(void)requestData
//{
//    [WXAFNetwork getRequestWithUrl:kAbout parameters:nil resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
//     {
//         if (isSuccessed) {
//             NSNumber *code = [resultObject objectForKey:kCode];
//             NSString *data = [resultObject objectForKey:kData];
//             if ([code integerValue] == 200) {
//                 
//                 //[web loadHTMLString:data baseURL:[NSURL URLWithString:kAbout]];
//                
//             }
//             else
//             {
//             
//                 [MBProgressHUD showError:data];
//                 
//             }
//         }
//     else
//     {
//     
//         [MBProgressHUD showError:kError];
//     }
//     
//     }];
//
//}

-(void)touchBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
