//
//  ShoppingCarViewController.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/17.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "Size.h"
#import "MJRefresh.h"
#import "shoppingCartListModel.h"
#import "makeSureOrderVC.h"
#import "userLoginVC.h"
#import "HomeViewController.h"
#import "LHGodsDetailViewController.h"

@interface ShoppingCarViewController ()
{
    shoppingCarCell *cell;
    float sum;
    int num;
    UIButton *settlementBtn;//结算或删除按钮
    UILabel *footNumLabel;//全选数量
    UIButton *footBtn;//全选按钮
    UILabel *titleText;
    
    BOOL isHeadReshing;
}

@property (nonatomic,retain) UIView *loginView;
@property (nonatomic,retain) UIView *noLoginView;
@property (nonatomic,retain) UIView *emptyCarView;

@property (nonatomic,retain) NSMutableArray *shoppingArr;
@property (nonatomic,retain) NSMutableArray *shoppingStateArr;
@property (nonatomic,retain) NSString *totalPrice;


@end

@implementation ShoppingCarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    editStateArray = [[NSMutableArray alloc]init];
    [self createUI];
    [self createNavgation];
    
    [self createAccordingView];
    [self createTableView];
    [self createFootView];
    
    isHeadReshing = NO;
    [self.customTableView reloadData];
    [self setupRefreshing];
    self.shoppingStateArr = [[NSMutableArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self requestData];
    [self refreshFootView];
    
    if (self.isPop == YES) {
        
        self.navigationController.tabBarItem.badgeValue = nil;
        self.tabBarController.tabBar.hidden = YES;
        
    }
    else
    {
      self.tabBarController.tabBar.hidden = NO;
    }
}


//下拉刷新
-(void)setupRefreshing
{
    //下拉刷新
    [self.customTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
}

//下拉刷新
-(void)headerRefreshing
{
    isHeadReshing = YES;
    [self requestData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
         [self.customTableView headerEndRefreshing];
        
    });
    
}

-(void)createNavgation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"red.png"] forBarMetrics:UIBarMetricsDefault];
}


-(void)requestData
{
    if (!self.shoppingArr) {
        
        self.shoppingArr = [[NSMutableArray alloc]init];
    }
    [self.shoppingArr removeAllObjects];
    
    if (!m_selectedItemArray) {
        m_selectedItemArray = [[NSMutableArray alloc]init];
    }
    [m_selectedItemArray removeAllObjects];
    
    if (isHeadReshing) {
    
        isHeadReshing = NO;
    }
    else
    {
    
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key", nil];
    [WXAFNetwork getRequestWithUrl:kShoppingCar parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
     {
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (isSuccessed) {
             
             NSNumber *code = [responseObject objectForKey:kCode];
             
             NSDictionary *data = [responseObject objectForKey:kData];
             
             if ([code integerValue] ==200) {
                 
                 self.totalPrice = [data objectForKey:@"sum"];
                 NSArray *cart = [data objectForKey:@"cart_list"];
                 
                 for (NSDictionary *dict in cart) {
                     [self.shoppingArr addObject:dict];
                }
                 
                 if (self.isPop == YES) {
                     
                 }
                 else
                 {
                 //小图标和导航栏标题
                 int iconNum = 0;
                 for (int i = 0; i < self.shoppingArr.count; i ++) {
                     
                     iconNum = iconNum + [[self.shoppingArr[i] valueForKey:@"goods_num"]intValue];
                     
                 }
                 if (self.shoppingArr.count == 0) {
                      titleText.text = @"购物车";
                     self.navigationController.tabBarItem.badgeValue = nil;
                 }
                 else
                 {
                     NSLog(@"%d", iconNum);
                 self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",iconNum];
                 titleText.text = [NSString stringWithFormat:@"购物车(%d)",iconNum ];
                 }
                     
                     titleText.font = [UIFont boldSystemFontOfSize:18.0];
                }
             }
             else
             {
                 [MBProgressHUD showError:[data objectForKey:kMessage]];
             
             }
             
             //判断界面
             if ([info objectForKey:kUserName] == nil) {
                 
                 _button.hidden = YES;
                 [self.loginView removeFromSuperview];
                 [self.emptyCarView removeFromSuperview];
                  self.navigationController.tabBarItem.badgeValue = nil;
                 titleText.text = @"购物车";
                 [self.view addSubview:self.noLoginView];
             }
             else
             {
                 
                 if (self.shoppingArr.count == 0) {
                     _button.hidden = YES;
                     [self.noLoginView removeFromSuperview];
                     [self.loginView removeFromSuperview];
                     [self.view addSubview:self.emptyCarView];
                 }
                 else
                 {
                     _button.hidden = NO;
                     [self.noLoginView removeFromSuperview];
                     [self.emptyCarView removeFromSuperview];
                     [self.view addSubview:self.loginView];
                     
                 }
                 
             }

             [self.customTableView reloadData];
         }
        else
        {
        
            [MBProgressHUD showError:kError];
        }
     
     }];
}

-(void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    titleText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,90, 44)];
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=[UIColor whiteColor];
    titleText.textAlignment = NSTextAlignmentCenter;
    [titleText setFont:[UIFont boldSystemFontOfSize:Text_Big]];
    self.navigationItem.titleView=titleText;
    
    //导航条字体颜色,大小
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    _button = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 40, 0, 60, 20)];
    
    [_button setTitle:@"编辑全部" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(clickEditorBtn:) forControlEvents:UIControlEventTouchUpInside];
    isEditState = NO;
    _button.titleLabel.font = [UIFont systemFontOfSize:Text_Big];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_button];
    self.navigationItem.rightBarButtonItem = item;
   
    if (self.isPop == YES)
    {
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *items = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = items;
       
    }
}

- (void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createAccordingView
{
    //未登录
    self.noLoginView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScr_W, KScr_H)];
    //[self.view addSubview:self.noLoginView];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScr_W/2 - 50, 30, kScr_Rate*100, 100*kScr_Rate)];
    imageView.image = [UIImage imageNamed:@"ren@2x.png"];
    
    imageView.layer.cornerRadius = 50;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KScr_W/2-50,50 + kScr_Rate*100 , 100*kScr_Rate, 20)];
    label.text = @"亲~请先登陆啦";
    label.font = [UIFont systemFontOfSize:Text_Big];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    
    [self.noLoginView addSubview:imageView];
    [self.noLoginView addSubview:label];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W/2 - 150,120 + kScr_Rate*100 , 300, 50)];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.0;
    button.backgroundColor = kColor;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [button addTarget:self action:@selector(clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.noLoginView addSubview:button];

    
    //登录
    self.loginView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScr_W, KScr_H)];
    
    
    //购物车为空
    self.emptyCarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScr_W, KScr_H)];
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(KScr_W/2 - 50, 30, kScr_Rate*100, 100*kScr_Rate)];
    imageView1.image = [UIImage imageNamed:@"gouwuc@2x.png"];
    
    imageView1.layer.cornerRadius = 50;
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(KScr_W/2-50,50 + kScr_Rate*100 , 100*kScr_Rate, 20)];
    label1.text = @"亲~购物车为空";
    label1.font = [UIFont systemFontOfSize:Text_Big];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor blackColor];
    
    [self.emptyCarView addSubview:imageView1];
    [self.emptyCarView addSubview:label1];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W/2 - 150,120 + kScr_Rate*100 , 300, 50)];
    [button1 setTitle:@"去逛逛" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.layer.cornerRadius = 5.0;
    button1.backgroundColor = kColor;
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [button1 addTarget:self action:@selector(browseClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.emptyCarView addSubview:button1];
}

//登录
-(void)clickLoginBtn:(UIButton *)btn
{
    self.hidesBottomBarWhenPushed = YES;
    userLoginVC *vc = [[userLoginVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

//去逛逛
-(void)browseClickBtn:(UIButton *)btn
{
    if (_isPop)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    self.tabBarController.selectedIndex = 0;

}

//底部
-(void)createFootView
{
    UIView *view = [[UIView alloc]init];
    if (self.isPop == YES) {
        
    view.frame = CGRectMake(0, KScr_H - 112, KScr_W, 50);
    }
    else
    {
     view.frame = CGRectMake(0,KScr_H - 162, KScr_W, 50);
    }
    //view.backgroundColor = [UIColor blackColor];
    [self.loginView addSubview:view];
    
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScr_W, 1)];
    image.backgroundColor = kLine;
    [view addSubview:image];
    
    footBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [footBtn addTarget:self action:@selector(footBtn:) forControlEvents:UIControlEventTouchUpInside];
    //[footBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 10,30 , 24)];
    label.text = @"全选";
    label.font = [UIFont systemFontOfSize:Text_Normal];
    label.tintColor = [UIColor blackColor];
    [view addSubview:footBtn];
    [view addSubview:label];
    
    footNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 10, 100, 24)];
    footNumLabel.text = [NSString stringWithFormat:@"￥%.2f",sum];
    [footNumLabel setTextColor:[UIColor colorWithRed:13.0/255.0 green:148.0/255.0 blue:252.0/255.0 alpha:1.0]];
    footNumLabel.font = [UIFont systemFontOfSize:Text_Normal];
    [view addSubview:footNumLabel];
    
    settlementBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 70, 10, 60, 25)];
    settlementBtn.layer.cornerRadius = 5.0;
    [settlementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    settlementBtn.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Normal];
    [settlementBtn setTitle:[NSString stringWithFormat:@"结算(%d)",num] forState:UIControlStateNormal] ;
    [settlementBtn setBackgroundColor:[UIColor redColor]];
    
    [settlementBtn addTarget:self action:@selector(settlementBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:settlementBtn];

}


//刷新底部的view最原始的footView)
-(void)refreshFootView
{
    [footBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    footNumLabel.text = [NSString stringWithFormat:@"￥%.2f",0.00];
    footNumLabel.hidden = NO;
    [settlementBtn setTitle:[NSString stringWithFormat:@"结算(%d)",0] forState:UIControlStateNormal];
    [settlementBtn setBackgroundColor:[UIColor redColor]];
    isSelectedAll = NO;
    isEditState = NO;
    [m_selectedItemArray removeAllObjects];
    [editStateArray removeAllObjects];
     num = 0;
    [_button setTitle:@"编辑全部" forState:UIControlStateNormal];
    [self.customTableView reloadData];

}

-(void)createTableView
{
    self.customTableView = [[UITableView alloc]init];
    
    if (self.isPop == YES) {
     self.customTableView.frame = CGRectMake(0, 0, KScr_W, KScr_H -112);

    }
    else
    {
        self.customTableView.frame = CGRectMake(0, 0, KScr_W, KScr_H - 162);
    }
    self.customTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.customTableView.delegate = self;
    self.customTableView.dataSource = self;
    
    [self.loginView addSubview:self.customTableView];

}

#pragma mark - UITableViewDelegate/DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shoppingArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *shoppingCell = @"shoppingCarCell";
   
    cell = (shoppingCarCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (nil == cell) {
        
        cell = [[shoppingCarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shoppingCell];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if (isSelectedAll)
    {
         cell.isSelectedAll = YES;
       
    }
    else
    {
        cell.isSelectedAll = NO;
    }
    
    
    if (self.shoppingArr.count>0)
    {
        if ([m_selectedItemArray containsObject:[self.shoppingArr objectAtIndex:indexPath.row]])
        {
            cell.circleClick = YES;
            
        }
        else
        {
            cell.circleClick = NO;
        }
    }
    
    //编辑状态
    if (isEditState ) {
        cell.isEditor = YES;
    }
    else
    {
        cell.isEditor = NO;
    
    }
    
    if (self.shoppingArr.count > 0)
    {
        if ([editStateArray containsObject:[self.shoppingArr objectAtIndex:indexPath.row]]) {
            
            cell.onClick = YES;
        }
        else
        {
            cell.onClick = NO;
            
        }
    }
    
    if (self.shoppingArr.count == 0) {
        
    }
    else
    {
    
    cell.delegate = self;
    [cell configCellWith:self.shoppingArr[indexPath.row]];
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
}



-(void)clickEditorBtn:(UIButton *)btn
{
    isSelectedAll = NO;
    if ([btn.titleLabel.text isEqualToString:@"编辑全部"]) {
        isEditState = YES;
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        
        if (m_selectedItemArray.count > 0) {
            [m_selectedItemArray removeAllObjects];
        }
        if (editStateArray.count > 0) {
            
            [editStateArray removeAllObjects];
        }
        for (NSDictionary *dic in self.shoppingArr) {
            
            [editStateArray addObject:dic];
        }
        
        
        [self TotalPrice];
        
        [self.customTableView reloadData];
    }
    else
    {
        
        [self requestCartNum];
        
        if (m_selectedItemArray) {
            
            [m_selectedItemArray removeAllObjects];
        }
        [btn setTitle:@"编辑全部" forState:UIControlStateNormal];
        isEditState = NO;
        
        if (editStateArray.count >0) {
            [editStateArray removeAllObjects];
        }
        
        [self TotalPrice];
        [self.customTableView reloadData];
        
    }
}


//更新购物车购买数量
-(void)requestCartNum
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    
    NSString *cart = [[NSString alloc]init];
    for (int i = 0; i < editStateArray.count; i ++)
    {
        
        NSString *str1 = [editStateArray[i] valueForKey:@"cart_id"];
        NSString *str2 = [editStateArray[i] valueForKey:@"goods_num"];
        NSString *str3 = [str1 stringByAppendingString:@"|"];
        NSString *str = [str3 stringByAppendingString:str2];
        
        if ([str1 isEqualToString: @""])
        {
            
        }
        else
        {
            if (i > 0)
            {
                
                cart  =[cart  stringByAppendingString:@";"];
            }
            
        }
        cart  = [cart  stringByAppendingString:str];
    }
    
    NSLog(@"%@",cart);
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",cart,@"cart", nil];
    
    [WXAFNetwork getRequestWithUrl:kShoppingCarNum parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
     {
         if (isSuccessed) {
             
             NSNumber *code = [responseObject objectForKey:kCode];
             NSDictionary *data = [responseObject objectForKey:kData];
             if ([code integerValue] == 200) {
                 
                  [MBProgressHUD showSuccess:[data objectForKey:kMessage]];
             }
             else
             {
                 [MBProgressHUD showError:[data objectForKey:kMessage]];
                 
             }
             
             [self.customTableView reloadData];
             
         }
         else
         {
             [MBProgressHUD showError:kError];
             
         }
         
     }
     ];
    
}

//删除购物车
-(void)deleteShoppingCar
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSString *cart_id = [[NSString alloc]init];
    
    for (int i = 0; i < m_selectedItemArray.count; i++) {
        
        NSString *str = [m_selectedItemArray[i] valueForKey:@"cart_id"];
        
        if ([cart_id isEqualToString: @""]) {
            
        }
        else
        {
            cart_id =[cart_id stringByAppendingString:@"|"];
        }
        cart_id = [cart_id stringByAppendingString:str];
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",cart_id,@"cart_id", nil];
    [WXAFNetwork getRequestWithUrl:kDeleteCart parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
     {
         if (isSuccessed) {
             
             NSNumber *code = [responseObject objectForKey:kCode];
             NSDictionary *data = [responseObject objectForKey:kData];
             if ([code integerValue] == 200) {
                 
                 [self.shoppingArr removeObject:m_selectedItemArray];
                 [m_selectedItemArray removeAllObjects];
                 [_button setTitle:@"编辑全部" forState:UIControlStateNormal];
                 num = 0;
                 [MBProgressHUD showSuccess:@"删除成功"];
                
                 [self refreshFootView];
                 
             }
             else
             {
                 [MBProgressHUD showError:[data objectForKey:kMessage]];
                 
             }
             
             //如果全删
             if (self.shoppingArr.count == 0) {
                 _button.hidden = YES;
                 [self.noLoginView removeFromSuperview];
                 [self.loginView removeFromSuperview];
                 [self.view addSubview:self.emptyCarView];
             }
             
             [self headerRefreshing];
             [self.customTableView reloadData];
         }
         else
         {
             [MBProgressHUD showError:kError];
             
         }
         
     }];
    
}

#pragma mark- 结算
//删除或结算
-(void)settlementBtn:(UIButton *)btn
{
    
    if ( [btn.backgroundColor isEqual: [UIColor redColor]]) {
        //如果结算
        
        NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
        NSString *key = [info objectForKey:kKey];
        
        if (m_selectedItemArray.count == 0 ) {
            
            [MBProgressHUD showError:@"未选中商品"];
        }
        else
        {
            NSLog(@"%@",m_selectedItemArray);  //m_selectedItemArray
            
            NSString *cart_id ;
            
            NSMutableString *mutableStr = [[NSMutableString alloc] init];
            
            for (int i = 0;i < m_selectedItemArray.count;i ++)
            {
                NSDictionary *desDic = m_selectedItemArray[i];
                
                if (m_selectedItemArray.count == 1) {
                    NSString *str = [NSString stringWithFormat:@"%@|%@",desDic[@"cart_id"],desDic[@"goods_num"]];
                    cart_id = [NSString stringWithString:str];
                }
                else
                {
                    if (i == 0)
                    {
                        NSString *str = [NSString stringWithFormat:@"%@|%@",desDic[@"cart_id"],desDic[@"goods_num"]];
                        [mutableStr appendString:str];
                    }
                    else
                    {
                        NSString *str = [NSString stringWithFormat:@",%@|%@",desDic[@"cart_id"],desDic[@"goods_num"]];
                        [mutableStr appendString:str];
                    }
                    
                    cart_id = [NSString stringWithString:mutableStr];
                }
            }
            
            NSDictionary* parameters = @{@"key":key,@"cart_id":cart_id,@"ifcart":@"1"};
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            
            [WXAFNetwork postRequestWithUrl:SHOPCARBUY_URL parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if (isSuccessed)
                {
                    NSLog(@"%@",resultObject);
                    self.hidesBottomBarWhenPushed = YES;
                    makeSureOrderVC *vc = [[makeSureOrderVC alloc] init];
                    vc.selectedDic = (NSDictionary *)resultObject;
                    vc.ifcart = @"1";
                    [self.navigationController pushViewController:vc animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                    
                }
                else
                {
                    [MBProgressHUD showError:kError];
                }
                
            }];
        }
    }
    else
    {
        //如果删除
        [self deleteShoppingCar];
        
    }
    
}


//全选按钮点击事件
-(void)footBtn:(UIButton *)btn
{
    if ([[footBtn backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkbox_normal"]])
        
    {
        //isSelectedAll = YES;
        [footBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateNormal];
        if (m_selectedItemArray.count > 0) {
            
            [m_selectedItemArray removeAllObjects];
        }
        for (NSDictionary *dic in self.shoppingArr) {
            
            [m_selectedItemArray addObject:dic];
        }
        [self TotalPrice];
    }
    else
    {
        // isSelectedAll = NO;
        
        [footBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        
        if (m_selectedItemArray.count > 0) {
            
            [m_selectedItemArray removeAllObjects];
        }
        
        [self TotalPrice];
    }
    
    [self.customTableView reloadData];
}

- (void)selecteItem:(NSDictionary *)selectedItem isSelected:(BOOL)isSelected
{
    
    if ([m_selectedItemArray containsObject:selectedItem])
    {
        [m_selectedItemArray removeObject:selectedItem];
    }
    else
    {
        [m_selectedItemArray addObject:selectedItem];
    }
    
    [self TotalPrice];
    
    [self.customTableView reloadData];
}



-(void)clickItem:(NSDictionary *)selectedItem isSelected:(BOOL)isSelected
{
    if ([editStateArray containsObject:selectedItem]) {
    
        [editStateArray removeObject:selectedItem];
    }
    else
    {
        [editStateArray addObject:selectedItem];
    }
    
}

-(void)editBtnPress:(NSString *)editProductId
{
    [_button setTitle:@"完成" forState:UIControlStateNormal];
    footNumLabel.hidden = YES;
    settlementBtn.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:140.0/255.0 blue:47.0/255.0 alpha:1.0];
    [settlementBtn setTitle:[NSString stringWithFormat:@"删除(%d)",num] forState:UIControlStateNormal];
}


-(void)changeNum:(NSString *)totalNum changeSum:(NSString *)totalSum andChangeItemDic:(NSDictionary *)dic
{
    
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    
    //数组里某个值的替换
    [tempDic setObject:totalNum forKey:@"goods_num"];
    [tempDic setObject:totalSum forKey:@"goods_sum"];
    
    //字典对应的数组的位置替换掉
    [self.shoppingArr replaceObjectAtIndex:[self.shoppingArr indexOfObject:dic] withObject:tempDic];
    
    NSLog(@"%@",self.shoppingArr);
    
    if (editStateArray.count == 0) {
        
    }
    else
    {
       
        [editStateArray replaceObjectAtIndex:[editStateArray indexOfObject:dic] withObject:tempDic];
      
    }
    
    if (m_selectedItemArray.count ==0) {
        
    }
    else
    {
         if ([m_selectedItemArray containsObject:dic]) {
            [m_selectedItemArray replaceObjectAtIndex:[m_selectedItemArray indexOfObject:dic] withObject:tempDic];
        }
      else
      {
        
      }
    
    }
    
    [self TotalPrice];
    [self.customTableView   reloadData];
    
}


//计算价格
-(void)TotalPrice
{
    sum = 0;
    num = 0;
    
    for (NSDictionary *dic in m_selectedItemArray) {
        
        NSLog(@"%@",dic);
        sum = sum + [[dic valueForKey:@"goods_price"] floatValue] * [[dic valueForKey:@"goods_num"]intValue];
        num = num +[[dic valueForKey:@"goods_num"]intValue];
    }
    NSLog(@"%f......%d",sum,num);
    footNumLabel.text = [NSString stringWithFormat:@"￥%.2f",sum];
    [self changeStateBtn];
    
}

//底部View的状态
-(void)changeStateBtn
{
    if (isEditState == YES) {
        
        footNumLabel.hidden = YES;
        [settlementBtn setTitle:[NSString stringWithFormat:@"删除(%d)",num] forState:UIControlStateNormal];
        settlementBtn.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:140.0/255.0 blue:47.0/255.0 alpha:1.0];
    }
    else
    {
        footNumLabel.hidden = NO;
        [settlementBtn setTitle:[NSString stringWithFormat:@"结算(%d)",num] forState:UIControlStateNormal];
        [settlementBtn setBackgroundColor:[UIColor redColor]];
    }
    
    if (m_selectedItemArray.count == self.shoppingArr.count)
    {
        
        [footBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateNormal];
    }
    else
    {
        [footBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
