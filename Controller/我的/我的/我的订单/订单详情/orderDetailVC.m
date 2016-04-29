//
//  orderDetailVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/1.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "orderDetailVC.h"
#import "orderDetailCell.h"
#import "Size.h"
#import "detailOrderModel.h"
#import "detailOrderGoodsModel.h"
#import "orderVC.h"
#import "orderEvaluationVC.h"
#import "LHGodsDetailViewController.h"
#import "SuShopDetailViewController.h"

@interface orderDetailVC ()<PaymentDelegate>
{
    UILabel *detailOrderId;
    UILabel *detailOrderTimer;
    UILabel *detailOrderRecipient;
    UILabel *detailOrderNumber;
    
    NSDictionary *dataDict;
}

@property (nonatomic,retain) detailOrderGoodsModel *detailOrderGoodsModel;
//@property (nonatomic,retain) detailOrderModel *detailOrderModel;

@property (nonatomic,retain) NSDictionary *detailOrderDic;
@property (nonatomic,retain) NSMutableArray *detailOrderGoodsArr;


@end

@implementation orderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self createTableView];
    [self builtHeadView];
    // [self createFootView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quickPaySuccess) name:@"havePaySuccessful" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self requestData];
    
}

-(void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"订单详情";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
 
}


-(void)requestData
{
    if (!self.detailOrderDic) {
        self.detailOrderDic = [[NSDictionary alloc]init];
    }
    
    if (!self.detailOrderGoodsArr) {
        self.detailOrderGoodsArr = [[NSMutableArray alloc]init];
    }
    [self.detailOrderGoodsArr removeAllObjects];
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    
    NSString *order_id = self.order_id;
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",order_id,@"order_id", nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [WXAFNetwork getRequestWithUrl:kDetailOrderUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (isSuccessed) {
             
             NSNumber *code = [responseObject objectForKey:kCode];
             NSDictionary *data = [responseObject objectForKey:kData];
             dataDict = [responseObject objectForKey:kData];
             NSLog(@"%@",data);
             if ([code integerValue] == 200) {
                 
                 self.detailOrderDic = [responseObject objectForKey:kData];
                 
                 NSArray *orderGoods = [data objectForKey:@"extend_order_goods"];
                 for (NSDictionary *dict in orderGoods)
                 {
                     
                     [self.detailOrderGoodsArr addObject:dict];
                     
                     [self createFootView];
                 }
                 
                 NSDictionary *orderCommon = [data objectForKey:@"extend_order_common"];
                 
                 detailOrderId.text = [NSString stringWithFormat:@"订单编号：%@",[self.detailOrderDic valueForKey:@"order_sn"]];
                 detailOrderTimer.text = [NSString stringWithFormat:@"下单时间：%@",[self.detailOrderDic valueForKey:@"add_time"]];
                 detailOrderRecipient.text = [NSString stringWithFormat:@"收货人：%@",[orderCommon objectForKey:@"buyer_nickname"]];
                 detailOrderNumber.text = [orderCommon objectForKey:@"buyer_phone"];
                 
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             }
             else
             {
                 
             }
             
             [self.customTableView reloadData];
         }
         else
         {
             
             [MBProgressHUD showError:kError];
         }
         
     }];
}

-(void)createTableView
{
    self.customTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 105,KScr_W , KScr_H - 240) style:UITableViewStyleGrouped];
    self.customTableView.backgroundColor = [UIColor whiteColor];
    self.customTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.customTableView.delegate = self;
    self.customTableView.dataSource = self;
    [self.customTableView registerNib:[UINib nibWithNibName:@"orderDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"orderDetailCell"];
    [self.view addSubview:self.customTableView];
    
}

-(void)builtHeadView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,0 , KScr_W, 100)];
    [self.view addSubview:headView];
    
    detailOrderId = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, KScr_W - 16, 24)];
    detailOrderTimer = [[UILabel alloc]initWithFrame:CGRectMake(8,40 , KScr_W - 16, 24)];
    detailOrderRecipient = [[UILabel alloc]initWithFrame:CGRectMake(8, 72, KScr_W /2 - 8, 24)];
    detailOrderNumber = [[UILabel alloc]initWithFrame:CGRectMake(KScr_W/2, 72, KScr_W/2 - 8, 24)];
    
    detailOrderId.font = [UIFont systemFontOfSize:Text_Big];
    [detailOrderId setTextColor:[UIColor blackColor]];
    detailOrderTimer.font = [UIFont systemFontOfSize:Text_Big];
    [detailOrderTimer setTextColor:[UIColor blackColor]];
    detailOrderRecipient.font = [UIFont systemFontOfSize:Text_Big];
    [detailOrderRecipient setTextColor:[UIColor blackColor]];
    detailOrderNumber.font = [UIFont systemFontOfSize:Text_Big];
    [detailOrderNumber setTextColor:[UIColor blackColor]];
    
    detailOrderNumber.textAlignment = NSTextAlignmentRight;
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 99, KScr_W, 1)];
    image.backgroundColor = kLineImage;
    
    [headView addSubview:detailOrderId];
    [headView addSubview:detailOrderNumber];
    [headView addSubview:detailOrderRecipient];
    [headView addSubview:detailOrderTimer];
    [headView addSubview:image];
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headCellView = [[UIView alloc]init];
    headCellView.backgroundColor = [UIColor whiteColor];
    
    
    if ([[dataDict objectForKey:@"pay_message"] isKindOfClass:[NSNull class]])
    {
        UILabel *detailStoreName = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, KScr_W - 16, 24)];
        detailStoreName.font = [UIFont systemFontOfSize:Text_Big];
        [detailStoreName setTextColor:[UIColor blackColor]];
        detailStoreName.text = [self.detailOrderDic valueForKey:@"store_name"];
        [headCellView addSubview:detailStoreName];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 23,10 , 15, 20)];
        [btn setBackgroundImage:[UIImage imageNamed:@"30*40.png"] forState:UIControlStateNormal];
        btn.contentMode = UIViewContentModeScaleAspectFit;
        [headCellView addSubview:btn];
        
        UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(8, 39, KScr_W - 16, 1)];
        imageLine2.backgroundColor = kLineImage;
        [headCellView addSubview:imageLine2];
    }
    else
    {
        NSString *str = [dataDict objectForKey:@"pay_message"];
        if (str.length > 0)
        {
            UILabel *pay_messageLabel = [[UILabel alloc] init];
            NSString *pay_message = [NSString stringWithFormat:@"备注：%@",[dataDict objectForKey:@"pay_message"]];
            
            CGRect frame = [pay_message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Text_Big]} context:nil];
            
            pay_messageLabel.frame = CGRectMake(8, 0, SCREEN_WIDTH-16, frame.size.height);
            pay_messageLabel.lineBreakMode =NSLineBreakByWordWrapping;
            pay_messageLabel.numberOfLines = 0;
            pay_messageLabel.font = [UIFont systemFontOfSize:Text_Big];
            pay_messageLabel.text = pay_message;
            [headCellView addSubview:pay_messageLabel];
            
            UIImageView *imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(8, frame.size.height+4, KScr_W - 16, 1)];
            imageLine3.backgroundColor = kLineImage;
            [headCellView addSubview:imageLine3];
            
            
            UILabel *detailStoreName = [[UILabel alloc]initWithFrame:CGRectMake(8, 8+frame.size.height, KScr_W - 16, 24)];
            detailStoreName.font = [UIFont systemFontOfSize:Text_Big];
            [detailStoreName setTextColor:[UIColor blackColor]];
            detailStoreName.text = [self.detailOrderDic valueForKey:@"store_name"];
            [headCellView addSubview:detailStoreName];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 23,10+frame.size.height, 15, 20)];
            [btn setBackgroundImage:[UIImage imageNamed:@"30*40.png"] forState:UIControlStateNormal];
            btn.contentMode = UIViewContentModeScaleAspectFit;
            [headCellView addSubview:btn];
            
            UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(8, 39+frame.size.height, KScr_W - 16, 1)];
            imageLine2.backgroundColor = kLineImage;
            [headCellView addSubview:imageLine2];
        }
        else
        {
            UILabel *detailStoreName = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, KScr_W - 16, 24)];
            detailStoreName.font = [UIFont systemFontOfSize:Text_Big];
            [detailStoreName setTextColor:[UIColor blackColor]];
            detailStoreName.text = [self.detailOrderDic valueForKey:@"store_name"];
            [headCellView addSubview:detailStoreName];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 23,10 , 15, 20)];
            [btn setBackgroundImage:[UIImage imageNamed:@"30*40.png"] forState:UIControlStateNormal];
            btn.contentMode = UIViewContentModeScaleAspectFit;
            [headCellView addSubview:btn];
            
            UIImageView *imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(8, 39, KScr_W - 16, 1)];
            imageLine2.backgroundColor = kLineImage;
            [headCellView addSubview:imageLine2];
        }
    }
    
    return headCellView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[dataDict objectForKey:@"pay_message"] isKindOfClass:[NSNull class]])
    {
        return 40;
    }
    else
    {
        NSString *pay_message = [NSString stringWithFormat:@"备注：%@",[dataDict objectForKey:@"pay_message"]];
        CGRect frame = [pay_message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Text_Big]} context:nil];
        
        return frame.size.height+40+5;
    }
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
    //UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 40)];
    
//    if ([dataDict objectForKey:@"pay_message"] is) {
//        <#statements#>
//    }
//    
//
//    
//    
//    return footerView;
//    
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 40;
//    
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailOrderGoodsArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *make = @"orderDetailCell";
    orderDetailCell *cell = (orderDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[orderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:make];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.delegate = self;
    
    [cell configDetailOrder:self.detailOrderGoodsArr[indexPath.row]];
    
    return cell;
    
}


-(void)createFootView
{
    UIButton *footDeleteOrder = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 190, 17, 80, 30)];
    UIButton *footVPayment = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 90, 17, 80, 30)];
    //foot.backgroundColor = [UIColor colorWithRed:195.0/255.0 green:195.0/255.0 blue:195.0/255.0 alpha:1];
    footDeleteOrder.layer.cornerRadius = 5.0;
    footDeleteOrder.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:116.0/255.0 blue:36.0/255.0 alpha:1.0];
    [footDeleteOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footDeleteOrder.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Big];
    
    footVPayment.layer.cornerRadius = 5.0;
    footVPayment.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:116.0/255.0 blue:36.0/255.0 alpha:1.0];
    [footVPayment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footVPayment.titleLabel.font = [UIFont boldSystemFontOfSize:Text_Big];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0,0 ,KScr_W , 1)];
    image.backgroundColor = kLine;
    
    UILabel *footViewlabelName = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, 75, 40)];
    footViewlabelName.font = [UIFont systemFontOfSize: 17.0];
    footViewlabelName.text = self.state_desc;
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, KScr_H - 128,KScr_W , 64);
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:footDeleteOrder];
    [view addSubview:footVPayment];
    [view addSubview:image];
    [view addSubview:footViewlabelName];
    [self.view addSubview:view];
    
    if ([[self.detailOrderDic valueForKey:@"order_state"] intValue]== 0) {
        
        footDeleteOrder.hidden = YES;
        footVPayment.hidden = NO;
        [footVPayment setTitle:@"删除订单" forState:UIControlStateNormal];
        [footVPayment addTarget:self action:@selector(detailDeleteOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    else if ([[self.detailOrderDic valueForKey:@"order_state"] intValue] == 10)
    {
        footDeleteOrder.hidden = NO;
        footVPayment.hidden = NO;
        
        [footDeleteOrder setTitle:@"取消订单" forState:UIControlStateNormal];
        [footDeleteOrder addTarget:self action:@selector(detailCancleOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [footVPayment setTitle:@"去付款" forState:UIControlStateNormal];
        [footVPayment addTarget:self action:@selector(detailGoPaymentBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    else if ([[self.detailOrderDic valueForKey:@"order_state"] intValue] == 20) {
        
        footDeleteOrder.hidden = YES;
        footVPayment.hidden = NO;
        //判断是否退款
        if ([[self.detailOrderDic valueForKey:@"lock_state"] intValue] == 1) {
            [footVPayment setTitle:@"退款中..." forState:UIControlStateNormal];
            footVPayment.userInteractionEnabled = NO;
            [footVPayment setTitleColor:[UIColor colorWithRed:197.0/255.0 green:24.0/255.0 blue:30.0/255.0 alpha:0.3] forState:UIControlStateNormal];
            footVPayment.layer.borderColor = [UIColor colorWithRed:197.0/255.0 green:24.0/255.0 blue:30.0/255.0 alpha:0.3].CGColor;
            footVPayment.layer.borderWidth = 1.0;
            footVPayment.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            [footVPayment setTitle:@"申请退款" forState:UIControlStateNormal];
            [footVPayment addTarget:self action:@selector(detailApplyRefundBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    else
    {
        footDeleteOrder.hidden = YES;
        footVPayment.hidden = NO;
        if ([[self.detailOrderDic valueForKey:@"evaluation_state"]intValue] == 0) {
            
            [footVPayment setTitle:@"去评价" forState:UIControlStateNormal];
            [footVPayment addTarget:self action:@selector(detailEvaluateBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [footVPayment setTitle:@"删除订单" forState:UIControlStateNormal];
            [footVPayment addTarget:self action:@selector(detailDeleteOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
            [footVPayment setBackgroundColor:[UIColor whiteColor]];
            footVPayment.layer.borderColor = [UIColor redColor].CGColor;
            footVPayment.layer.borderWidth = 1;
            [footVPayment setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }
        
    }
    
    
}


//cell里的点击进入商品和商户
-(void)detailShopBtn:(UIButton *)btn
{
    self.hidesBottomBarWhenPushed = YES;
    SuShopDetailViewController *vc = [[SuShopDetailViewController alloc]init];
    vc.store_id = self.store_id;
    vc.backRootVC = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)detailGoodsBtn:(UIButton *)btn
{
    self.hidesBottomBarWhenPushed = YES;
    LHGodsDetailViewController *vc = [[LHGodsDetailViewController alloc]init];
    vc.goods_id = self.goods_id;
    vc.backRootVC = @"0";
    NSLog(@"%@",self.goods_id);
    [self.navigationController pushViewController:vc animated:YES];
    
}

//各种点击事件

//申请退款
-(void)detailApplyRefundBtn:(UIButton *)btn
{
   
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"是否退款" message:@"" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    [alter show];
    
}
//是否退款
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
    }
    else if ( buttonIndex == 0)
    {
        
        _order_id = [self.detailOrderDic valueForKey:@"order_id"];
        
        NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
        NSString *key = [info objectForKey:kKey];
        NSString *order_id = _order_id;
        NSString *msg = @"";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",order_id,@"order_id",msg,@"msg", nil];
        [WXAFNetwork postRequestWithUrl:kRefundOrderUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (isSuccessed) {
                 
                 NSNumber *code = [responseObject objectForKey:kCode];
                 NSDictionary *data = [responseObject objectForKey:kData];
                 if ([code integerValue] == 200) {
                     
                     [MBProgressHUD showSuccess:@"退款成功"];
                     [self performSelector:@selector(popVC) withObject:self afterDelay:0.5];
                     
                 }
                 else
                 {
                     UIAlertView *alter = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",[data objectForKey:kMessage]] message:@"" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
                     [alter show];
                     
                 }
             }
             else
             {
                 [MBProgressHUD showError:kError];
                 
             }
             
         }];
        
    }
}


//删除订单
-(void)detailDeleteOrderBtn:(UIButton *)btn
{
    
    _order_id = [self.detailOrderDic valueForKey:@"order_id"];
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSString *order_id = _order_id;
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",order_id,@"order_id", nil];
    [WXAFNetwork getRequestWithUrl:kDeleteOrderUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
     {
         if (isSuccessed) {
             
             NSNumber *code = [responseObject objectForKey:kCode];
             NSDictionary *data = [responseObject objectForKey:kData];
             if ([code integerValue] == 200) {
                 
                 [MBProgressHUD showSuccess:@"删除成功"];
                 [self performSelector:@selector(popVC) withObject:self afterDelay:0.5];
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

//取消订单
-(void)detailCancleOrderBtn:(UIButton *)btn
{
    _order_id = [self.detailOrderDic valueForKey:@"order_id"];
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSString *order_id = _order_id;
    NSString *msg = @"";
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",order_id,@"order_id",msg,@"msg", nil];
    [WXAFNetwork postRequestWithUrl:kCancelOrderUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
     {
         if (isSuccessed) {
             
             NSNumber *code = [responseObject objectForKey:kCode];
             NSDictionary *data = [responseObject objectForKey:kData];
             
             if ([code integerValue] == 200) {
                 
                 [MBProgressHUD showSuccess:@"取消成功"];
                  [self performSelector:@selector(popVC) withObject:self afterDelay:0.5];
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


//去付款
-(void)detailGoPaymentBtn:(UIButton *)btn
{
    
    //设置支付的环境类型
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"detailPay" forKey:@"payType"];
    
    
    NSString *orderId = dataDict[@"pay_sn"];
    
    NSLog(@"%@",orderId);
    
    NSString *price = [NSString stringWithFormat:@"%.2f",[dataDict[@"goods_amount"] floatValue ]-[dataDict[@"pd_amount"] floatValue]];
    
    float   submittotalMoney = [price floatValue]; //0.01;//[model.pay_amount floatValue];
    
    NSLog(@"支付金额：%f",submittotalMoney);
    
    
    //开始支付
    Payment *payment = [[Payment alloc]init];
    payment.delegate = self;
    [payment payActionWithTradeId:orderId JsonStr:@"suzhoupay" andTotalMoney:submittotalMoney];
    
}

//去评价
-(void)detailEvaluateBtn:(UIButton *)btn
{
    // _order_id = [self.detailOrderDic valueForKey:@"order_id"];
    self.hidesBottomBarWhenPushed = YES;
    orderEvaluationVC *vc = [[orderEvaluationVC alloc]init];
    vc.evaluationArr = self.orderD_arr;
    vc.goods_id = _goods_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//走网页支付成功后的回调
- (void)finishPay
{
    
    [self requestData];
}



//支付成功后向后台提供数据以备生成订单
- (void)quickPaySuccess
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([[userDefaults objectForKey:@"payType"] isEqualToString:@"detailPay"])
    {
        
        //刷新数据
        //[self getSourceData];
        [self requestData];
    }
    
}


-(void)touchBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)popVC
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
