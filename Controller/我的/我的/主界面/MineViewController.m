//
//  MineViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "MineViewController.h"

#import "Size.h"
#import "feedBackVC.h"
#import "Size.h"
#import "loginTableViewCell.h"
#import "loginHeadView.h"
#import "voucherVC.h"
#import "collectionVC.h"
#import "orderVC.h"
#import "userLoginVC.h"
#import "integralVC.h"
#import "AFNetworking.h"
#import "personalMessageVC.h"
#import "loginFootView.h"
#import "aboutVC.h"
#import "setUpVC.h"
#import "advanceDepositVC.h"
#import "myMessVC.h"


@interface MineViewController ()
{
    BOOL login;
}

@property (nonatomic,retain) UIView *loginView;
@property (nonatomic,strong) UIView *unLonginView;

@end

@implementation MineViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self createUI];
    [self createNavgation];
    //self.hidesBottomBarWhenPushed = NO;
    self.tabBarController.tabBar.hidden = NO;

}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];

}

-(void)createNavgation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"red.png"] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:204/255 green:204/255 blue:204/255 alpha:1];
    //self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
}


-(void)createUI
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",info);
    
    NSLog(@"%@",[info objectForKey:kKey]);
    
    if ([info objectForKey:kUserName] == nil) {
        
        [self.loginView removeFromSuperview];
        self.title = @"个人中心";
        //导航条字体颜色,大小
        [self.navigationController.navigationBar setTitleTextAttributes:
         
         @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0],
           
           NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScr_W/2 - 50, 30, kScr_Rate*100, 100*kScr_Rate)];
        imageView.image = [UIImage imageNamed:@"ren@2x.png"];
        
        imageView.layer.cornerRadius = 50;
        //imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KScr_W/2-50,50 + kScr_Rate*100 , 100*kScr_Rate, 20)];
        label.text = @"亲~请先登陆啦";
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        
        [self.view addSubview:imageView];
        [self.view addSubview:label];
        

        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = item;
        
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W/2 - 150,120 + kScr_Rate*100 , 300, 50)];
        [button1 setTitle:@"登录" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button1.layer.cornerRadius = 5.0;
        button1.backgroundColor = kColor;
        button1.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        [button1 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button1];

    }
    else
    {
        self.loginView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScr_W, KScr_H - 64)];
        self.loginView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.loginView];
        
        self.title = @"个人中心";
        //导航条字体颜色,大小
        [self.navigationController.navigationBar setTitleTextAttributes:
         
         @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0],
           
           NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        self.titleArr = @[@[@"我的订单",@"我的积分",@"我的收藏",@"我的抵用券",@"我的预存款"],@[@"设置",@"关于",@"意见反馈",@"我的消息"]];
        self.pictureArr = @[@[@"个人中心_03.png",@"个人中心_07.png",@"个人中心_11.png",@"个人中心_14.png",@"myyucun"],@[@"个人中心_21.png",@"个人中心_24.png",@"个人中心_23.png",@"mymessage"]];
      
        [self createTableView];
        [self createHeadView];

    }
   
}


//退出登录按钮
-(void)createBtn
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 ,KScr_W , 90)];
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(15,30, KScr_W-30, 40)];
    
    [loginBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = kColor;
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    loginBtn.layer.cornerRadius = 5;
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:loginBtn];
    
    self.customTableView.tableFooterView = footView;
    
}


-(void)createTableView
{
    
    self.customTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,KScr_W , KScr_H - 64-49) style:UITableViewStylePlain];
    self.customTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.customTableView.delegate = self;
    self.customTableView.dataSource = self;
    self.customTableView.showsHorizontalScrollIndicator = NO;
    self.customTableView.showsVerticalScrollIndicator = NO;
    [self.customTableView registerNib:[UINib nibWithNibName:@"loginTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"loginTableView"];
    [self createBtn];
    
    [self.loginView addSubview:self.customTableView];
    
}

-(void)createHeadView
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    loginHeadView *headView = [[[NSBundle mainBundle]loadNibNamed:@"loginHeadView" owner:self options:nil]lastObject];
    headView.mobileLabel.text = [info objectForKey:kUserName];
    headView.contentMode = UIViewContentModeScaleAspectFit;
    //创建按钮
    UIButton *userBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    [userBtn addTarget:self action:@selector(userBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView.userBtnView addSubview:userBtn];
    //[userBtn.imageView setImageWithURL:[NSURL URLWithString:[info objectForKey:kAvatar] ] placeholderImage:nil options:0 completed:nil];
    //[userBtn setBackgroundImage:[UIImage imageNamed:@"个人中心_people.png"] forState:UIControlStateNormal];
    
    UIImageView *userBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    [userBtnImage sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:kAvatar]] placeholderImage:[UIImage imageNamed:@"200-200.png"] options:0 completed:nil];
    userBtnImage.layer.masksToBounds = YES;
    userBtnImage.layer.cornerRadius = 40;
    [headView.userBtnView addSubview:userBtnImage];
    
    //背景图片
    headView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"个人中心_banner.jpg"]];
    headView.userBtnView.backgroundColor = [UIColor clearColor];
    
    headView.headViewLine.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 9,KScr_W, 1)];
    image.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    [headView.headViewLine addSubview:image];
    
    self.customTableView.tableHeaderView = headView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 5;
            break;
            
        default:
            return 4;
            break;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 40;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 11;
    }
    else
    {
        return 1;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    loginFootView *footerView1 = [[[NSBundle mainBundle]loadNibNamed:@"loginFootView" owner:self options:nil]lastObject];
    
    if (section == 1) {
        footerView1.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    }
    else
    {
        footerView1.footViewImage.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0];
        UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScr_W, 1)];
        UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, KScr_W, 1)];
        image1.backgroundColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0];
        image2.backgroundColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0];

        [footerView1 addSubview:image2];
        [footerView1 addSubview:image1];
//        footerView.footViewLine.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
//        footerView.footViewLine1.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];

    
    }
    return footerView1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    loginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loginTableView" forIndexPath:indexPath];;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.nameLabel.text = self.titleArr[indexPath.section][indexPath.row];
    
    
    UIImageView *pictureImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, 11, 21, 21)];
    pictureImage.image = [UIImage imageNamed:self.pictureArr[indexPath.section][indexPath.row]];
    pictureImage.contentMode = UIViewContentModeScaleAspectFit;
    [cell addSubview:pictureImage];
    
    UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(45, 43, KScr_W - 41-9, 1)];
    lineImage.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    [cell addSubview:lineImage];
    
    if ((indexPath.section == 0 && indexPath.row == 4)||(indexPath.section == 1 && indexPath.row == 3)) {
        
        lineImage.hidden = YES;
    }
    else
    {
       lineImage.hidden = NO;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            orderVC *vc = [[orderVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
        }
        
        if (indexPath.row == 1) {
            integralVC *vc = [[integralVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        if (indexPath.row == 2) {
            
            
            collectionVC *vc = [[collectionVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        
        if (indexPath.row == 3) {
            
            voucherVC *vc = [[voucherVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
        }
        if (indexPath.row == 4) {
            
            advanceDepositVC *vc = [[advanceDepositVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
        }

        
    }
    else
    {
        if (indexPath.row == 0) {
            
            setUpVC *vc = [[setUpVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        
        if (indexPath.row == 1) {
            
            aboutVC *vc = [[aboutVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
        }
        
        if (indexPath.row == 2) {
        
        feedBackVC *vc = [[feedBackVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
      }
        if (indexPath.row == 3) {
            
            myMessVC *vc = [[myMessVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        
    }
}

//个人资料
-(void)userBtnClick:(UIButton *)btn
{
    self.hidesBottomBarWhenPushed = YES;
    personalMessageVC *vc = [[personalMessageVC alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

-(void)touchBtn:(UIButton *)btn
{
    
}


//登录
-(void)clickBtn:(UIButton *)btn
{
    self.hidesBottomBarWhenPushed = YES;
    userLoginVC *vc = [[userLoginVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//退出登录
-(void)loginBtnClick:(UIButton *)btn
{
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
  
    
    NSString *username = [info objectForKey:kUserName];
    NSString *key = [info objectForKey:kKey];
    NSString *client = [info objectForKey:kClient];
    
    NSDictionary *paremeters = [NSDictionary dictionaryWithObjectsAndKeys:username,@"username",key,@"key",client,@"client", nil];
    
    
    [WXAFNetwork postRequestWithUrl:kExitLoginUrl parameters:paremeters resultBlock:
     ^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
     {
         if (isSuccessed) {
             NSNumber *code = [resultObject objectForKey:kCode];
             NSDictionary *data = [resultObject objectForKey:kData];
             if ([code integerValue] == 200) {
                 
                 [MBProgressHUD showSuccess:[data objectForKey:kMessage]];
                 [info removeObjectForKey:kUserName];
                 [info removeObjectForKey:kKey];
                 [info removeObjectForKey:kUpPone];
                 [info removeObjectForKey:kClient];
                 [info removeObjectForKey:kAvatar];
                 
                  MineViewController *vc = [[MineViewController alloc]init];
                 [self.navigationController pushViewController:vc animated:NO];
                
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
