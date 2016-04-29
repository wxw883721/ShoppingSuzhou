//
//  TabBarViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "SurroundViewController.h"
#import "ShoppingCarViewController.h"
#import "MineViewController.h"
#define BTN_PUBLIC_TAG 1000

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeViewController *hVC = [[HomeViewController alloc] init];
    SurroundViewController *sVC  = [[SurroundViewController alloc] init];
    ShoppingCarViewController *cVC = [[ShoppingCarViewController alloc] init];
    MineViewController *mVC = [[MineViewController alloc] init];
    
    [self initChildViewController:hVC tilte:@"首页" imageName:@"1.png" selectedImageName:@"33.png" ];
    [self initChildViewController:sVC tilte:@"周边商家" imageName:@"2.png" selectedImageName:@"44.png" ];
    [self initChildViewController:cVC tilte:@"购物车" imageName:@"3.png" selectedImageName:@"22.png" ];
    [self initChildViewController:mVC tilte:@"个人中心" imageName:@"4.png" selectedImageName:@"11.png" ];
}

- (void)initChildViewController:(UIViewController *)childViewController tilte:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:childViewController];
    // nav.navigationBar.barTintColor =[UIColor colorWithRed:0.89f green:0.23f blue:0.24f alpha:1.00f];
    nav.navigationBar.translucent = NO;
    // 设置头标题
    [nav.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1.00],NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    
    // 不渲染图片
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 未选中时tabBarItem上字体的颜色
    [childViewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    UIColor * customSelectColor =[UIColor redColor];
    
    // 选中时tabBarItem上字体的颜色
    //[childViewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.24f green:0.75f blue:0.64f alpha:1.00f]} forState:UIControlStateSelected];
    [childViewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:customSelectColor} forState:UIControlStateSelected];
    
    // 设置标题和图片
    if ([title isEqualToString:@"首页"])
    {
        childViewController.tabBarItem = [childViewController.tabBarItem initWithTitle:nil
                                                                                 image:image
                                                                         selectedImage:selectedImage];
        childViewController.tabBarItem.title=@"首页";
    }
    childViewController.tabBarItem = [childViewController.tabBarItem initWithTitle:title
                                                                             image:image
                                                                     selectedImage:selectedImage];
    //childViewController.title = title;
    // 加入到标签栏控制器中
    [self addChildViewController:nav];
    
    
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
