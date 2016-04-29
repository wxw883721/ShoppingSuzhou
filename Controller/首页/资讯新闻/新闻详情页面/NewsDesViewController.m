//
//  NewsDesViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/20.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "NewsDesViewController.h"

@interface NewsDesViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *web;
@end

@implementation NewsDesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    /** 1.设置导航栏*/
    [self createNavgation];
    /** 2.创建UI控件*/
    [self createUI];
    
//    [self request:self.news_id];
}

- (void)request:(NSString*)string
{
    [self RequestWithURL:[NSString stringWithFormat:NEWSDETAIL_URL, string] target:self action:@selector(analyze:)];
}

- (void)analyze:(NSData*)data
{
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"dic = %@",dic);
}

- (void)createNavgation
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLabel.text = @"资讯新闻";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor  = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleLabel;
}

- (void)createUI
{
    _web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_web];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.bgsz.tv/mobile/index.php?act=news&op=news&news_id=%@", self.news_id]]];

//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [_web loadRequest:request];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
