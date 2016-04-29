//
//  integralSuccessVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/8/7.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "integralSuccessVC.h"
#import "IntegralMallVC.h"

@interface integralSuccessVC ()
{
    
    UIImageView *image;
    UILabel *promptMsgLabel;
    
}

@end

@implementation integralSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self createView];
    [self createBtn];
}

-(void)createUI
{
    self.title = @"积分商城";
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    
}

-(void) createView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScr_W, 120)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 80, 80)];
    promptMsgLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 20, KScr_W - 110, 80)];
    promptMsgLabel.numberOfLines = 0;
    promptMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    image.image = [UIImage imageNamed:@"right"];
    promptMsgLabel.text = @"恭喜你，兑换成功，请注意查询手机短信";
    
    [self.view addSubview:image];
    [self.view addSubview:promptMsgLabel];
    
}

-(void)createBtn
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake( 40, 160, KScr_W - 80, 40)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setBackgroundColor:kColor];
    btn.layer.cornerRadius = 5.0;
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
}

-(void)clickBtn:(UIButton *)btn
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[IntegralMallVC class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
        }
        
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
