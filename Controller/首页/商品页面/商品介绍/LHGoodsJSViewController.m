//
//  LHGoodsJSViewController.m
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/15.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "LHGoodsJSViewController.h"

@interface LHGoodsJSViewController ()

@end

@implementation LHGoodsJSViewController
{
    UIWebView* _webView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.text = @"商品介绍";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = label;
    
    
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GOODSJIESHAO_URL,self.goods_id]]]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
