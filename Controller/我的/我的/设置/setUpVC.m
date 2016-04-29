//
//  setUpVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/18.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "setUpVC.h"
#import "Size.h"
#import "APService.h"

@interface setUpVC ()

@property (nonatomic,retain) NSMutableArray *arr;
@property (nonatomic,retain) NSMutableArray *arr2;
@property (nonatomic,retain) NSMutableArray *arr3;

@end

@implementation setUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self createSwitch];
    //[self requestData];
   
}

-(void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置";
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;

    
    self.arr = [[NSMutableArray alloc]init];
    self.arr3 = [[NSMutableArray alloc]init];
}


-(void)createSwitch
{
    NSString *pushState = [[NSUserDefaults standardUserDefaults] objectForKey:kPushState];
    
    if ([pushState integerValue] == 1)
    {
        _switchBtn.on = YES;
    }
    else
    {
        _switchBtn.on = NO;
    }
    
}

-(void)touchBtn:(UIButton *)btn
{

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



- (IBAction)switchChange:(id)sender
{
    BOOL pushState = [[[NSUserDefaults standardUserDefaults]objectForKey:kPushState] boolValue];
    
    NSString *pushStateStr = [NSString stringWithFormat:@"%d",!pushState];
    
    [[NSUserDefaults standardUserDefaults] setObject:pushStateStr forKey:kPushState];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kPushState] integerValue] == 0)
    {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        
        [MBProgressHUD showSuccess:@"您已关闭消息推送"];
        
    }
    else
    {
        //极光
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
        {
            //categories
            [APService
             registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                 UIUserNotificationTypeSound |
                                                 UIUserNotificationTypeAlert)
             categories:nil];
        }
        else
        {
            //categories nil
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
#else
             //categories nil
             categories:nil];
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
#endif
             // Required
             categories:nil];
        }
        [MBProgressHUD showSuccess:@"您已打开消息推送"];

    }
    
    
    
    
    
    
    
}
@end
