//
//  DesViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "DesViewController.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"

@interface DesViewController ()

@end

@implementation DesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNavgtion];
    
    self.tabBarController.tabBar.hidden = YES;
    
    
}

-(void)createNavgtion
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"red.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou@2x"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(BackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
}
-(void)BackAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setViewTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:22];
    self.navigationItem.titleView = label;
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
