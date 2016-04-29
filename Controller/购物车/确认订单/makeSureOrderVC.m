//
//  makeSureOrderVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/24.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "makeSureOrderVC.h"
#import "makeSureOrderCell.h"
#import "ShoppingCarViewController.h"
#import "Payment.h"
#import "SureVoucherViewController.h"
#import "orderVC.h"
#import "voucherVC.h"

@interface makeSureOrderVC ()<PaymentDelegate,sureVoucherDelegae,UITextFieldDelegate>
{
    float sum;
    float discount;
    float actdiscount;
    UIButton *_advanceBtn;
    UITextField *_enterPasswordField;
    UIButton *_voucherBtn;
    UILabel *secVoucherLabel;
    UILabel *combinedLabel;
    UITextField *_remarkField;
    UILabel *textLabel;
}

@property (nonatomic,strong) UILabel *voucherLabel;//显示抵用券的label

@property (nonatomic,strong) NSMutableArray *vourcherMutArr;//存放“满多少减多少”
@property (nonatomic,strong) NSMutableArray *discontPriceArr;//存放抵用券减少的金额
@property (nonatomic,strong) NSMutableArray *vourcherDesArr;//所有的抵用券

@end

@implementation makeSureOrderVC

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _vourcherMutArr = [[NSMutableArray alloc] init];
    _discontPriceArr = [[NSMutableArray alloc] init];
    _vourcherDesArr = [[NSMutableArray alloc] init];
    
    
    
    NSLog(@"%@",_selectedDic);
    NSArray *store_cart_listArr = _selectedDic[@"data"][@"store_cart_list"];
    self.payMessageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < store_cart_listArr.count; i ++)
    {
        [self.payMessageArray addObject:@""];
    }
    
    
    [self createUI];
    [self createView];
    [self createTableView];
    [self createFootView];
    [self createHeadView];
    
    //监听来自项目主委托方法中发来的快捷支付成功地通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quickPaySuccess) name:@"havePaySuccessful" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quickPayFailure) name:@"havePayFailure" object:nil];
}

-(void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"确认订单";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;

}

-(void)createView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, KScr_H - 114, KScr_W, 50)];
    [self.view addSubview:view];
    
    combinedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScr_W/2, 50)];
    combinedLabel.backgroundColor = [UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1];
    [combinedLabel setTextColor:[UIColor colorWithRed:233.0/255.0 green:122.0/255.0 blue:35.0/255.0 alpha:1]];
    combinedLabel.font = [UIFont systemFontOfSize:Text_Normal];
    combinedLabel.textAlignment = NSTextAlignmentCenter;
    
    sum = 0;
    discount = 0;
    actdiscount = 0;
    NSArray *store_cart_listArr = _selectedDic[@"data"][@"store_cart_list"];
    
    for (int i = 0; i < _discontPriceArr.count; i ++)
    {
       
        NSString *discoutStr = _discontPriceArr[i];
        
        discount = discount +[discoutStr floatValue];
    }
    
   
    
    for (NSDictionary *cartDic in store_cart_listArr)
    {
        NSString *store_goods_total = cartDic[@"store_goods_total"];
        
        sum = sum + [store_goods_total floatValue];
        NSString *actDiscount = @"";
        
        if ([cartDic[@"store_mansong_rule_list"] isKindOfClass:[NSDictionary class]])
        {
            actDiscount = cartDic[@"store_mansong_rule_list"][@"discount"];
        }
        actdiscount = actdiscount + [actDiscount floatValue];
    }
    
    combinedLabel .text = [NSString stringWithFormat:@"合计：%.2f",sum-discount-actdiscount];
    
    [view addSubview:combinedLabel];
    
    UIButton *buyNowBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W/2, 0, KScr_W/2, 50)];
    buyNowBtn.backgroundColor = [UIColor redColor];
    [buyNowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyNowBtn.titleLabel.font = [UIFont systemFontOfSize:Text_Normal];
    [buyNowBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyNowBtn addTarget:self action:@selector(buyNowAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buyNowBtn];
}

#pragma mark - 立即购买
- (void)buyNowAction
{
    NSString *url = @"http://www.bgsz.tv/mobile/index.php?act=member_buy&op=buy_step2";
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSString *cart_id = nil;
    NSString *pay_message = nil;
    
//pay_message的处理
    NSArray *store_cartList = _selectedDic[@"data"][@"store_cart_list"];
    NSLog(@"%@",store_cartList);
    NSMutableString *mutableMessageStr = [[NSMutableString alloc] init];
    for (int  i = 0; i < store_cartList.count;i ++)
    {
        if(store_cartList.count == 1)
        {
            NSString *store_id = store_cartList[0][@"goods_list"][0][@"store_id"];
            
            UITextField *textField = (UITextField *)[self.view viewWithTag:42314+i];
            
            NSString *message = nil;
            
            if (textField.text&&textField.text.length > 0)
            {
                message = textField.text;
            }
            else
            {
                message = @"";
            }
            
            
            pay_message = [NSString stringWithFormat:@"%@|%@",store_id,message];
        }
        else
        {
            
            if (i == 0)
            {
                NSString *store_id = store_cartList[i][@"goods_list"][0][@"store_id"];
                
                UITextField *textField = (UITextField *)[self.view viewWithTag:42314+i];
                
                NSString *message = nil;
                
                if (textField.text.length > 0)
                {
                    message = self.payMessageArray[i];
                    NSLog(@"%@",message);
                }
                else
                {
                    message = @"";
                }
                NSString *str = [NSString stringWithFormat:@"%@|%@",store_id,message];
                [mutableMessageStr appendString:str];
                NSLog(@"%@",mutableMessageStr);
            }
            else
            {
                NSString *store_id = store_cartList[i][@"goods_list"][0][@"store_id"];
                UITextField *textField = (UITextField *)[self.view viewWithTag:42314+i];
                
                NSString *message = nil;
                
                if (textField.text&&textField.text.length > 0)
                {
                    message = textField.text;
                }
                else
                {
                    message = @"";
                }
                NSString *str = [NSString stringWithFormat:@",%@|%@",store_id,message];
                [mutableMessageStr appendString:str];
            }
            
            pay_message = [NSString stringWithString:mutableMessageStr];
        }
        
    }
    
    NSLog(@"%@",pay_message);
    
    
    NSMutableString *mutableStr = [[NSMutableString alloc] init];
    
    NSArray *cartListArr = _selectedDic[kData][@"store_cart_list"];
    
//cart_id的处理
    for (int i = 0;i < cartListArr.count;i ++)
    {
        NSDictionary *goodListDic = cartListArr[i];
        
        NSArray *goodlistArr = goodListDic[@"goods_list"];
        
        for (int  j = 0;j < goodlistArr.count;j ++)
        {
            NSDictionary *goodsDesDict = goodlistArr[j];
            
            if (cartListArr.count == 1&&goodlistArr.count == 1)
            {
                NSString *str = [NSString stringWithFormat:@"%@|%@",goodsDesDict[@"cart_id"],goodsDesDict[@"goods_num"]];
                cart_id = [NSString stringWithString:str];
            }
            else
            {
                if (i == 0 && j == 0)
                {
                    NSString *str = [NSString stringWithFormat:@"%@|%@",goodsDesDict[@"cart_id"],goodsDesDict[@"goods_num"]];
                    [mutableStr appendString:str];
                }
                else
                {
                    NSString *str = [NSString stringWithFormat:@",%@|%@",goodsDesDict[@"cart_id"],goodsDesDict[@"goods_num"]];
                    [mutableStr appendString:str];
                }
                cart_id = [NSString stringWithString:mutableStr];
            }
        }
    }
        
        
        
    NSLog(@"%@",cart_id);
    
//voucher的处理
    NSMutableString *mutableVoucher = [[NSMutableString alloc] init];
    NSString *voucher = @"";
    
    for (int i = 0; i < _vourcherDesArr.count;i ++)
    {
        NSDictionary *dict = _vourcherDesArr[i];
        
        NSLog(@"%@",dict);
        
        if (_vourcherDesArr.count == 1)
        {
            NSString *str = [NSString stringWithFormat:@"%@|%@|%d",dict[@"voucher_t_id"],dict[@"voucher_store_id"],[dict[@"voucher_price"] integerValue]];
            voucher = [NSString stringWithString:str];
        }
        else
        {
            if (i == 0)
            {
                NSString *str = [NSString stringWithFormat:@"%@|%@|%d",dict[@"voucher_t_id"],dict[@"voucher_store_id"],[dict[@"voucher_price"] integerValue]];
                [mutableVoucher appendString:str];
            }
            else
            {
                NSString *str = [NSString stringWithFormat:@",%@|%@|%d",dict[@"voucher_t_id"],dict[@"voucher_store_id"],[dict[@"voucher_price"] integerValue]];
                [mutableVoucher appendString:str];
            }
            
            voucher = [NSString stringWithString:mutableStr];
        }
        
    }
    
    NSLog(@"%@",voucher);
    
//预付款支付
    if (_advanceBtn.selected == YES)
    {
        NSString *pd_pay = @"1";
        
        
        
        NSString * password = nil;
        if (_enterPasswordField.text==nil ||_enterPasswordField.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            password = _enterPasswordField.text;
            
            NSDictionary *parameters = @{@"key":key,@"cart_id":cart_id,@"ifcart":_ifcart,@"pd_pay":pd_pay,@"password":password,@"voucher":voucher,@"pay_message":pay_message};
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [WXAFNetwork postRequestWithUrl:url parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription) {
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                if (isSuccessed)
                {
                    NSLog(@"%@",resultObject);
                    
                    NSDictionary *dataDic = [resultObject objectForKey:kData];
                    
                    NSNumber *code = [resultObject objectForKey:kCode];
                    
                    if ([code integerValue] == 200)
                    {
                        if ([[dataDic objectForKey:@"pay_state"] integerValue] == 1)
                        {
                            NSString *message = [dataDic objectForKey:kMessage];
                            [MBProgressHUD showSuccess:message toView:self.view];
                            
                            
                            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0f];
                        }
                        else
                        {
                            //调用支付宝
                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                            [userDefaults setObject:@"payNow" forKey:@"payType"];
                            
                            
                            NSString *orderId = dataDic[@"pay_sn"];
                            
                            NSLog(@"%@",orderId);
                            
                            NSString *price = [NSString stringWithFormat:@"%.2f",[dataDic[@"order_amount"] floatValue]];
                            
                            CGFloat   submittotalMoney = [price floatValue]; //0.01;[model.pay_amount floatValue];
                            
                            NSLog(@"支付金额：%f",submittotalMoney);
                            
                            //开始支付
                            Payment *payment = [[Payment alloc]init];
                            payment.delegate = self;
                            [payment payActionWithTradeId:orderId JsonStr:@"suzhoupay" andTotalMoney:submittotalMoney];
                        }
                    }
                    else
                    {
                        NSString *message = [dataDic objectForKey:kMessage];

                        [MBProgressHUD showError:message toView:self.view];
                    }
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
//支付宝支付
        NSString * pd_pay = @"0";
        NSString *password = @"";
        
        if (voucher.length == 0) {
            voucher = @"";
        }
        
        NSDictionary *parameters = @{@"key":key,@"cart_id":cart_id,@"ifcart":_ifcart,@"pd_pay":pd_pay,@"password":password,@"voucher":voucher,@"pay_message":pay_message};
        
        NSLog(@"%@",parameters);
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WXAFNetwork postRequestWithUrl:url parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if (isSuccessed)
            {
                NSLog(@"%@",resultObject);
                
                NSString *message = [resultObject objectForKey:kData][kMessage];
                NSLog(@"%@",message);
                
                NSNumber *code = [resultObject objectForKey:kCode];
                if ([code integerValue] == 200)
                {
                    NSDictionary *dataDic = [resultObject objectForKey:kData];
                    
                    //调用支付宝
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:@"payNow" forKey:@"payType"];
                    
                    
                    NSString *orderId = dataDic[@"pay_sn"];
                    
                    NSLog(@"%@",orderId);
                    
                    NSString *price = [NSString stringWithFormat:@"%.2f",[dataDic[@"order_amount"] floatValue]];
                    
                    CGFloat   submittotalMoney = [price floatValue]; //0.01;[model.pay_amount floatValue];
                    
                    NSLog(@"支付金额：%f",submittotalMoney);
                    
                    //开始支付
                    Payment *payment = [[Payment alloc]init];
                    payment.delegate = self;
                    [payment payActionWithTradeId:orderId JsonStr:@"suzhoupay" andTotalMoney:submittotalMoney];
                }
                
            }
            else
            {
                [MBProgressHUD showError:kError];
            }
        }];
        
    }
}

- (void)delayMethod
{
    orderVC *vc = [[orderVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

//走网页支付成功后的回调
- (void)finishPay
{
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0f];
}

- (void)finishPayFailure
{
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0f];
}

//支付成功后向后台提供数据以备生成订单
- (void)quickPaySuccess
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([[userDefaults objectForKey:@"payType"] isEqualToString:@"payNow"])
    {
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0f];
//        //刷新数据
//        orderVC *vc = [[orderVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        
        [self.customTableView reloadData];
    }
    
}

- (void)quickPayFailure
{
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0f];
}

#pragma mark - 创建表格
- (void)createTableView
{
    self.customTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, KScr_W, KScr_H - 154) style:UITableViewStyleGrouped];
    self.customTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.customTableView.delegate = self;
    self.customTableView.dataSource = self;
    
    [self.view addSubview:self.customTableView];

}

-(void)createHeadView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScr_W, 40)];
    
    UILabel *goodsMess = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, KScr_W - 16, 24)];
    goodsMess.text = @"商品信息:";
    goodsMess.font = [UIFont boldSystemFontOfSize:Text_Big];
    [goodsMess setTextColor:[UIColor blackColor]];
    [headView addSubview:goodsMess];
    
    [self.view addSubview:headView];
    
//    self.customTableView.tableHeaderView = headView;
}

-(void)createFootView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0,0, KScr_W , 80)];
    footView.backgroundColor = [UIColor whiteColor];
    
    
    
    //创建预付款栏
    _advanceBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 10,20 , 20)];
    [_advanceBtn setBackgroundImage:[UIImage imageNamed:@"购物车_10-05.png"] forState:UIControlStateNormal];
    [_advanceBtn setBackgroundImage:[UIImage imageNamed:@"cxGouPressed@2x.png"] forState:UIControlStateSelected];
    [_advanceBtn addTarget:self action:@selector(advanceClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:_advanceBtn];
    
    UILabel *advanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 10, KScr_W - 55, 20)];
    NSString *advanceMoney = [NSString stringWithFormat:@"预存款支付:（%@元）",(_selectedDic[@"data"][@"available_predeposit"] != [NSNull null])?_selectedDic[@"data"][@"available_predeposit"]:@"0"];
    advanceLabel.text = advanceMoney;
    advanceLabel.font = [UIFont systemFontOfSize:Text_Big];
    [advanceLabel setTextColor:[UIColor blackColor]];
    [footView addSubview:advanceLabel];
    
    _enterPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(10, 40, KScr_W - 20, 30)];
    _enterPasswordField.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    _enterPasswordField.layer.cornerRadius = 5.0;
    _enterPasswordField.secureTextEntry = YES;
    [footView addSubview:_enterPasswordField];
    
    UILabel *enterPassLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, KScr_W - 20, 30)];
    [enterPassLabel setTextColor:[UIColor colorWithRed:162.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1.0]];
    enterPassLabel.text = @"请输入密码";
    enterPassLabel.font = [UIFont systemFontOfSize:Text_Normal];
    enterPassLabel.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:enterPassLabel];
    
    self.customTableView.tableFooterView = footView;
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *goodsListDic = _selectedDic[@"data"][@"store_cart_list"][section];
    NSArray *goodsListArr = goodsListDic[@"goods_list"];
    
    
    for (int i = 0; i < goodsListArr.count; i ++)
    {
        [_vourcherMutArr addObject:@""];
        [_discontPriceArr addObject:@"0"];
    }
    
    return goodsListArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *store_cart_listArr = _selectedDic[@"data"][@"store_cart_list"];
    return store_cart_listArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *makeSureCell = @"makeSureOrderCell";
    
    makeSureOrderCell *cell = (makeSureOrderCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (nil == cell) {
        
        cell = [[makeSureOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:makeSureCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *goodsListDic = _selectedDic[@"data"][@"store_cart_list"][indexPath.section];
    
    NSArray *goodsListArr = goodsListDic[@"goods_list"];
    
    cell.delegate = self;
    [cell configCellWith:goodsListArr[indexPath.row]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *mansong_goods_name = @"";
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *goodsListDic = _selectedDic[@"data"][@"store_cart_list"][section];
    
    
    UILabel *storeName = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, KScr_W - 90, 24)];
    storeName.text = [goodsListDic valueForKey:@"store_name"];
    storeName.font = [UIFont boldSystemFontOfSize:Text_Big];
    [headerView addSubview:storeName];
    
    UILabel *storePrice = [[UILabel alloc]initWithFrame:CGRectMake(KScr_W - 110, 8, 100, 24)];
    storePrice.text = [NSString stringWithFormat:@"￥%.2f",[[goodsListDic valueForKey:@"store_goods_total"]floatValue]];
    storePrice.textAlignment = NSTextAlignmentRight;
    [storePrice setTextColor:[UIColor redColor]];
    storePrice.font = [UIFont systemFontOfSize:Text_Normal];
    [headerView addSubview:storePrice];
    
    UIImageView *imageLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, KScr_W, 1)];
    imageLine1.backgroundColor = kLineImage;
    [headerView addSubview:imageLine1];
    
    if ([goodsListDic[@"store_mansong_rule_list"] isKindOfClass:[NSDictionary class]])
    {
        UILabel *manSongLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH-15, 30)];
        NSString *str = goodsListDic[@"store_mansong_rule_list"][@"desc"];
        mansong_goods_name = goodsListDic[@"store_mansong_rule_list"][@"mansong_goods_name"];

        manSongLabel.text = [NSString stringWithFormat:@"活动:%@%@",str,mansong_goods_name];
        manSongLabel.textColor = [UIColor orangeColor];
        manSongLabel.font = [UIFont systemFontOfSize:Text_Normal];
        UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 69, KScr_W, 1)];
        imageLine2.backgroundColor = kLineImage;
        [headerView addSubview:imageLine2];
        
        [headerView addSubview:imageLine2];
        [headerView addSubview:manSongLabel];
        
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSDictionary *goodsListDic = _selectedDic[@"data"][@"store_cart_list"][section];
    
    if ([goodsListDic[@"store_mansong_rule_list"] isKindOfClass:[NSDictionary class]]) {
        return 70;
    }
    else
        return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *selectVoucher = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, KScr_W - 50, 40)];
    [selectVoucher addTarget:self action:@selector(voucherAction:) forControlEvents:UIControlEventTouchUpInside];
    //[footerView addSubview:selectVoucher];
    
    secVoucherLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
    secVoucherLabel.text = @"选择抵用券";
    secVoucherLabel.font = [UIFont systemFontOfSize:Text_Normal];
    [secVoucherLabel setTextColor:[UIColor blackColor]];
    [footerView addSubview:secVoucherLabel];
    
    //点击事件
    UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [control addTarget:self action:@selector(voucherAction:) forControlEvents:UIControlEventTouchUpInside];
    control.tag =45678+section;
    [footerView addSubview:control];
    
    _voucherLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, SCREEN_WIDTH-130, 40)];
    _voucherLabel.tag  = 19999+section;
    _voucherLabel.text = _vourcherMutArr[section];
    _voucherLabel.textColor = [UIColor redColor];
    _voucherLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:_voucherLabel];
    
    
    UIImageView *secVoucherImage = [[UIImageView alloc]initWithFrame:CGRectMake(KScr_W - 25, 15, 10, 10)];
    secVoucherImage.image = [UIImage imageNamed:@"20-20"];
    secVoucherImage.contentMode = UIViewContentModeScaleAspectFill;
    [footerView addSubview:secVoucherImage];
    
    
    UIImageView *imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 39, KScr_W-20, 1)];
    imageLine3.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.4];
    [footerView addSubview:imageLine3];
    
    //创建备注栏
    _remarkField = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-20, 30)];
    _remarkField.tag = 42314 +section;
    _remarkField.placeholder = @"选填：对本次交易的补充说明";
    _remarkField.text = self.payMessageArray[section];
    _remarkField.delegate = self;
    [footerView addSubview:_remarkField];
    
    UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 69, KScr_W, 1)];
    imageLine2.backgroundColor = kLineImage;
    [footerView addSubview:imageLine2];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 70;
}

- (void)voucherAction:(UIControl *)control
{
    //跳转到我的抵用券
    NSArray *goodListArr = _selectedDic[kData][@"store_cart_list"];
    int i = control.tag - 45678;
    
    NSDictionary * goodDes = goodListArr[i];
    if ([goodDes[@"store_voucher_list"] isKindOfClass:[NSArray class]])
    {
        NSArray *voucherArr = goodDes[@"store_voucher_list"];
        if (voucherArr.count > 0)
        {
            SureVoucherViewController *vc = [[SureVoucherViewController alloc] init];
            vc.voucherArr = voucherArr;
            vc.my_delegate = self;
            vc.row = [NSString stringWithFormat:@"%d",i];
            [self.navigationController pushViewController:vc animated:NO];
        }
        else
        {
            [MBProgressHUD showError:@"没有可用的抵用券"];
        }
    }
}

-(void)cellDidClick:(NSDictionary *)voucherDic andRow:(NSString *)row
{
//    UILabel *vourcherLabel = (UILabel *)[self.view viewWithTag:19999+[row integerValue]];
    
    NSString *string = [NSString stringWithFormat:@"满%@减%@",voucherDic[@"voucher_limit"],voucherDic[@"voucher_price"]];
    [_discontPriceArr replaceObjectAtIndex:[row integerValue] withObject:voucherDic[@"voucher_price"]];
    [_vourcherMutArr replaceObjectAtIndex:[row integerValue] withObject:string];
    
    [_vourcherDesArr addObject:voucherDic];
    
    [self.customTableView reloadData];
    [self createView];
}

-(void)advanceClick:(UIButton *)btn
{
    if ([_selectedDic[@"data"][@"available_predeposit"] isMemberOfClass:[NSNull class]])
        return;
    
    btn.selected = !btn.selected;
}

-(void)touchBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.payMessageArray  replaceObjectAtIndex:textField.tag-42314  withObject:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.payMessageArray  replaceObjectAtIndex:textField.tag-42314  withObject:textField.text];
    
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
