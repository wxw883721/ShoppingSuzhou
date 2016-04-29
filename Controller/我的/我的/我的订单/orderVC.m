//
//  orderVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/26.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "orderVC.h"
#import "Size.h"
#import "orderHeadView.h"
#import "orderCell.h"
#import "orderDetailVC.h"
#import "MJRefresh.h"
#import "orderModel.h"
#import "orderEvaluationVC.h"


@interface orderVC ()
{
    UIButton *allOrderBtn;
    orderHeadView *headView;
    NSInteger index ;
    int  state;
    BOOL isHeadReshing;
    BOOL isFooterReshing;
    
    int currentPage;

    NSIndexPath *indexSection;
    NSString *tivket;
    
}

@property (nonatomic,retain) NSMutableArray *storeNameArr;
@property (nonatomic,retain) NSMutableArray *storeDescArr;

@end


@implementation orderVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    [self createTableView];
    [self builtTitleView];
    
   
    isFooterReshing = NO;
    isHeadReshing = NO;
    
    [self requestData];
    self.orderArr = [[NSMutableArray alloc]init];
    self.orderListArr = [[NSMutableArray alloc]init];

    //监听来自项目主委托方法中发来的快捷支付成功地通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quickPaySuccess) name:@"havePaySuccessful" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self headerRefreshing];
    
}

//上拉，下拉刷新
-(void)setupRefreshing
{
    //下拉刷新
    [self.customTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    //上拉刷新
    [self.customTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}

//下拉刷新
-(void)headerRefreshing
{
    isHeadReshing = YES;
    [self.orderArr removeAllObjects];
    [self.orderListArr removeAllObjects];
    currentPage = 1;
    [self requestData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.customTableView headerEndRefreshing];
    });
    
}

//上拉加载更多
-(void)footerRefreshing
{
    isFooterReshing = YES;
    [self requestData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.customTableView footerEndRefreshing];
    });
}


-(void)requestData
{
    
    if (isHeadReshing) {
        
        currentPage = 1;
        isHeadReshing = NO;
    }
    else if(isFooterReshing)
    {
        currentPage ++;
        isFooterReshing = NO;
    }
    else
    {
        //[MBProgressHUD showError:kError];
    }
    
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSString *curpage = [NSString stringWithFormat:@"%i",currentPage];
    
    if (index == 0)
    {
        state = 0;
    }
    else if (index == 1)
    {
        state = 10;
    }
    else if (index == 2)
    {
        state = 20;
    }
    else
    {
        state = 40;
    }
    
    NSString *order_state = [NSString stringWithFormat:@"%i",state];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",curpage,@"curpage",order_state,@"order_state", nil];
    [WXAFNetwork getRequestWithUrl:kOrderUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (isSuccessed) {
             
             NSNumber *code = [responseObject objectForKey:kCode];
             
             // NSNumber *page_total = [responseObject objectForKey:@"page_total"];
             // NSString *hasmore = [responseObject objectForKey:@"hasmore"];
             
             if ([code integerValue] == 200) {
                 
                 if ([[responseObject objectForKey:kData] isKindOfClass:[NSDictionary class]]) {
                     
                     [MBProgressHUD showError:[[responseObject objectForKey:kData]objectForKey:kMessage]];
                 }
                 else
                 {
                     for (NSDictionary *dict in [responseObject objectForKey:kData]) {
                         
                         [self.orderArr addObject:dict];
                         
                         NSMutableArray *arr = [[NSMutableArray alloc]init];
                         for (NSDictionary *listDict in [dict valueForKey:@"order_list"]) {
                             
                             [arr addObject:listDict];
                             
                         }
                         [self.orderListArr addObject:arr];
                         
                     }
                     
                 }
                 

                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 //[self setupRefreshing];
             }
              [self setupRefreshing];
              [self.customTableView reloadData];
            
          }
        
         else
         {
             
             [MBProgressHUD showError:kError];
             
         }
     }];

}

//创建返回按钮
-(void)createUI
{
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
}

-(void)builtTitleView
{
    headView = [[[NSBundle mainBundle] loadNibNamed:@"orderHeadView" owner:self options:nil] lastObject];
    headView.frame = CGRectMake(KScr_W - 123, 0, 245, 29) ;
    headView.layer.borderColor = [UIColor whiteColor].CGColor;
    headView.layer.borderWidth = 1.0;
    headView.layer.cornerRadius = 5.0;
    self.navigationItem.titleView = headView;
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:headView];
//    self.navigationItem.rightBarButtonItem = item;
    
    //默认选择
    headView.segmentBtn.selectedSegmentIndex = 0;
    //设置点击背景色
    headView.segmentBtn.tintColor = [UIColor whiteColor];
    headView.segmentBtn.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:24.0/255.0 blue:31.0/255.0 alpha:1.0];
    //字体
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:Text_Normal],NSFontAttributeName, nil];
    [headView.segmentBtn setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    //设置监听事件
    [headView.segmentBtn addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    
    //添加手势
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeSelectSegment:)];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeSelectSegment:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
}

- (void)changeSelectSegment:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (headView.segmentBtn.selectedSegmentIndex == 3)
        {
            
        }
        else
        {
            headView.segmentBtn.selectedSegmentIndex += 1;
        }
        
    }
    else
    {
        if (headView.segmentBtn.selectedSegmentIndex == 0)
        {
            
        }
        else
        {
            headView.segmentBtn.selectedSegmentIndex -= 1;
        }
    }
    
    [self segmentChange:headView.segmentBtn];
    
}

-(void)createTableView
{
    self.customTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScr_W, KScr_H - 64) style:UITableViewStyleGrouped];
    self.customTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.customTableView.delegate = self;
    self.customTableView.dataSource = self;
    
    [self.view addSubview:self.customTableView];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orderArr.count;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *arr = (NSArray *)self.orderListArr[section];
    
    return arr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if ([self.orderListArr count] > 0)
    {
        NSMutableArray *arr = self.orderListArr[indexPath.section][indexPath.row];
        NSMutableArray *orderSectionArr = self.orderListArr[indexPath.section];
        NSMutableArray *goodsArr = [[NSMutableArray alloc]init];
        for (NSDictionary *goodDict in [arr valueForKey:@"extend_order_goods"]) {
            
            [goodsArr addObject:goodDict];
        }
        NSMutableArray *ticketArr = [[NSMutableArray alloc]init];
        for (int i = 0; i < goodsArr.count ; i ++) {
            
            for (NSDictionary *ticketDict in [goodsArr[i] valueForKey:@"order_ticket"])
            {
                [ticketArr addObject:ticketDict];
            }
            
        }
        //待付款
        if ([[arr valueForKey:@"order_state"] intValue] == 10)
        {
            if ( orderSectionArr.count == 1 ) {
                
                self.cellHeight =  40 + 100*goodsArr.count + 40*ticketArr.count ;
            }
            else
            {
                
                self.cellHeight =  40 + 100*goodsArr.count + 40*ticketArr.count  + 40;
            }
        }
        //待消费
        else if ([[arr valueForKey:@"order_state"] intValue] == 20)
        {
            if ( orderSectionArr.count == 1 ) {
                
                self.cellHeight =  40 + 100*goodsArr.count + 40*ticketArr.count ;
            }
            else
            {
                self.cellHeight =  40 + 100*goodsArr.count + 40*ticketArr.count  + 40 ;
                
            }
        }
        //去评价
        else if ([[arr valueForKey:@"order_state"]intValue] == 40)
        {
            if ( orderSectionArr.count == 1 ) {
                
                self.cellHeight =  40 + 100*goodsArr.count + 40*ticketArr.count ;
            }
            else
            {
                self.cellHeight =  40 + 100*goodsArr.count + 40*ticketArr.count  + 40 ;
                
            }
        }

        else if ([[arr valueForKey:@"order_state"] intValue] == 0)
        {
            if (orderSectionArr.count == 1) {
                self.cellHeight =  40 + 100*goodsArr.count + 40*ticketArr.count ;
            }
            else
            {
            self.cellHeight =  40 + 100*goodsArr.count + 40*ticketArr.count + 40;
            }
            
        }
        else
        {
            self.cellHeight = 40 + 100*goodsArr.count + 40*ticketArr.count;
        
        }
        
    }
    
    return self.cellHeight;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.orderListArr.count == 0) {
        
        return 0;
    }
    else
    {
    NSArray *arr = self.orderListArr[section];
    self.order_state = [self.orderArr[section] valueForKey:@"order_state"];
    
    if ((arr.count > 1 && [self.order_state intValue] == 20) || (arr.count > 1 && [self.order_state intValue] == 40)) {
        UIView *footView1 = [[UIView alloc]init];
        footView1.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
        return footView1;
    }
    else
    {
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    UILabel *ordersNumber = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 140, 21)];
    UILabel *ordersCombined = [[UILabel alloc]initWithFrame:CGRectMake(KScr_W - 150, 8, 140, 21)];
    ordersCombined.textAlignment = NSTextAlignmentRight;
    ordersNumber.textAlignment = NSTextAlignmentLeft;
    ordersCombined.font = [UIFont systemFontOfSize:Text_Big];
    ordersNumber.font = [UIFont systemFontOfSize:Text_Big];
    [footView addSubview:ordersNumber];
    [footView addSubview:ordersCombined];
    
    if (self.orderArr.count == 0) {
        
    }
    else
    {
        float num = [[self.orderArr[section] valueForKey:@"pay_amount"]floatValue];
       
        UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,40 , KScr_W, 1)];
        image2.backgroundColor = kLine;
        [footView addSubview:image2];
        
        UIButton *deleteOrderBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 190, 55,70 , 30)];
        UIButton *refundOrEvaluateBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 80 , 55, 70,30)];
        deleteOrderBtn.backgroundColor = [UIColor whiteColor];
        [deleteOrderBtn setTitleColor:kloginColor forState:UIControlStateNormal];
        deleteOrderBtn.layer.cornerRadius = 5.0;
        deleteOrderBtn.layer.borderWidth = 1.0;
        deleteOrderBtn.layer.borderColor = kloginColor.CGColor;
        deleteOrderBtn.titleLabel.font = [UIFont systemFontOfSize:Text_Big];
        
        refundOrEvaluateBtn.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1.0];
        [refundOrEvaluateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        refundOrEvaluateBtn.layer.cornerRadius = 5.0;
        refundOrEvaluateBtn.titleLabel.font = [UIFont systemFontOfSize:Text_Big];
        
        [footView addSubview:deleteOrderBtn];
        [footView addSubview:refundOrEvaluateBtn];
        
        if ([self.order_state intValue]== 0) {
            
            deleteOrderBtn.hidden = YES;
            refundOrEvaluateBtn.hidden = NO ;
            [refundOrEvaluateBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [refundOrEvaluateBtn addTarget:self action:@selector(deleteOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
            refundOrEvaluateBtn.tag = section;
            
            refundOrEvaluateBtn.backgroundColor = [UIColor whiteColor];
            [refundOrEvaluateBtn setTitleColor:kloginColor forState:UIControlStateNormal];
            refundOrEvaluateBtn.layer.cornerRadius = 5.0;
            refundOrEvaluateBtn.layer.borderWidth = 1.0;
            refundOrEvaluateBtn.layer.borderColor = kloginColor.CGColor;
            
            ordersCombined.text = [NSString stringWithFormat:@"订单总数：%@",[self.orderArr[section] valueForKey:@"total_num"]];
            
        }
        
        else if ([self.order_state intValue] == 10)
        {
            deleteOrderBtn.hidden = NO;
            refundOrEvaluateBtn.hidden = NO;
            deleteOrderBtn.tag = section;
            [deleteOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [deleteOrderBtn addTarget:self action:@selector(CancleOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            refundOrEvaluateBtn.tag = section;
            [refundOrEvaluateBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [refundOrEvaluateBtn addTarget:self action:@selector(goPaymentBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            ordersNumber.text = [NSString stringWithFormat:@"订单总数：%@",[self.orderArr[section] valueForKey:@"total_num"]];
            ordersCombined.text = [NSString stringWithFormat:@"合计：%.1f",num];
        }
        
        else if ([self.order_state intValue] == 20) {
            
            deleteOrderBtn.hidden = YES;
            refundOrEvaluateBtn.hidden = NO;
            refundOrEvaluateBtn.tag = section;
           
            //判断是否退款
            if ([[self.orderArr[section] valueForKey:@"lock_state"] intValue] == 1) {
                [refundOrEvaluateBtn setTitle:@"退款中..." forState:UIControlStateNormal];
                refundOrEvaluateBtn.userInteractionEnabled = NO;
                [refundOrEvaluateBtn setTitleColor:[UIColor colorWithRed:197.0/255.0 green:24.0/255.0 blue:30.0/255.0 alpha:0.3] forState:UIControlStateNormal];
                refundOrEvaluateBtn.layer.borderColor = [UIColor colorWithRed:197.0/255.0 green:24.0/255.0 blue:30.0/255.0 alpha:0.3].CGColor;
                refundOrEvaluateBtn.layer.borderWidth = 1.0;
                refundOrEvaluateBtn.backgroundColor = [UIColor whiteColor];
            }
            else
            {
                [refundOrEvaluateBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                [refundOrEvaluateBtn addTarget:self action:@selector(applyRefundBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
            ordersCombined.text = [NSString stringWithFormat:@"订单总数：%@",[self.orderArr[section] valueForKey:@"total_num"]];
         
            }
        else
        {
            refundOrEvaluateBtn.hidden = NO;
            deleteOrderBtn.hidden = YES;
            refundOrEvaluateBtn.tag = section;
            if ([[self.orderArr[section] valueForKey:@"evaluation_state"]intValue] == 0) {
                
                [refundOrEvaluateBtn setTitle:@"去评价" forState:UIControlStateNormal];
                [refundOrEvaluateBtn addTarget:self action:@selector(EvaluateBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [refundOrEvaluateBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [refundOrEvaluateBtn addTarget:self action:@selector(deleteOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
                [refundOrEvaluateBtn setBackgroundColor:[UIColor whiteColor]];
                refundOrEvaluateBtn.layer.borderColor = [UIColor redColor].CGColor;
                refundOrEvaluateBtn.layer.borderWidth = 1;
                [refundOrEvaluateBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                
            }
            
            ordersCombined.text = [NSString stringWithFormat:@"订单总数：%@",[self.orderArr[section] valueForKey:@"total_num"]];
            
        }
    }
    
    //下面的分割线
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 95, KScr_W, 10)];
    view.backgroundColor = kLineImage;
    [footView addSubview:view];
    return footView;
        
    }
  }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.orderListArr.count == 0) {
        
        return 0;
    }
    else
    {
    NSArray *arr = self.orderListArr[section];
    if ((arr.count > 1 && [[self.orderArr[section] valueForKey:@"order_state"] intValue] == 20)||(arr.count > 1 && [[self.orderArr[section] valueForKey:@"order_state"] intValue] == 40)) {
        return 10;
    }
    else
    {
        return 105;
     }
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSString *mark = @"orderCell";
    orderCell *cell = (orderCell *)[tableView cellForRowAtIndexPath:indexPath];

    if (cell == nil) {
        
        cell = [[orderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    cell.delegate = self;
    
    if (self.orderListArr.count == 0) {
        
    }
    else
    {
        NSMutableArray *arr = self.orderListArr[indexPath.section][indexPath.row];
        NSMutableArray *orderSectionArr = self.orderListArr[indexPath.section];
        [cell configFication:arr andOrderSectionArr:orderSectionArr];
        
    }
    
    return cell;
    
}

//点击进入订单详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    orderDetailVC *vc = [[orderDetailVC alloc]init];
    NSMutableArray *arr = self.orderListArr[indexPath.section][indexPath.row];
    
    vc.order_id = [arr valueForKey:@"order_id"];
    vc.state_desc = [arr valueForKey:@"state_desc"];
    vc.orderD_arr = self.orderListArr[indexPath.section];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}



//监听事件
-(void)segmentChange:(UISegmentedControl *)segmentContorl
{
    index = segmentContorl.selectedSegmentIndex;
    
    
    switch (index) {
        case 0:
            
            
            break;
        case 1:
            
            
            break;
        case 2:
            
            break;
        case 3:
            
            
            break;
    }
    
    [self headerRefreshing];
    [self.customTableView reloadData];
}

//各种点击事件,将一个section所有订单全部执行

//申请退款
-(void)applyRefundBtn:(UIButton *)btn
{
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"是否退款" message:@"" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    [alter show];
    self.RefundArr = [[NSMutableArray alloc]init];
    self.RefundArr = self.orderListArr[btn.tag];
    
    self.isOrderState = [self.orderArr[btn.tag] valueForKey:@"order_state"];
    
}

//删除订单
-(void)deleteOrderBtn:(UIButton *)btn
{
    
    UIAlertView *alter1 = [[UIAlertView alloc]initWithTitle:@"是否删除" message:@"" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    [alter1 show];
    self.deleteArr = [[NSMutableArray alloc]init];
    self.deleteArr = self.orderListArr[btn.tag];
    self.isOrderState = [self.orderArr[btn.tag] valueForKey:@"order_state"];
    self.btnTag = btn.tag;
}

//是否退款或删除
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
    }
    else if ( buttonIndex == 0)
    {
        if ([self.isOrderState intValue] == 20) {
            
            NSString *order_id = [[NSString alloc]init];
            for (NSDictionary *dict in self.RefundArr) {
                order_id = [dict objectForKey:@"order_id"];
            }
            NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
            NSString *key = [info objectForKey:kKey];
            NSLog(@"%@",order_id);
            NSString *msg = @"";
                
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",order_id,@"order_id",msg,@"msg", nil];
            [WXAFNetwork postRequestWithUrl:kRefundOrderUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
            {
                if (isSuccessed) {
                         
                NSNumber *code = [responseObject objectForKey:kCode];
                NSDictionary *data = [responseObject objectForKey:kData];
                if ([code integerValue] == 200) {
                             
                    [MBProgressHUD showSuccess:@"退款成功"];
                    [self headerRefreshing];
                    
                    }
                else
                {
                    if (self.view == nil)self.view = [[UIApplication sharedApplication].windows lastObject];
                    // 快速显示一个提示信息
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.detailsLabelText = [NSString stringWithFormat:@"%@",[data objectForKey:kMessage]];
                    
                    // 再设置模式
                    hud.mode = MBProgressHUDModeCustomView;
                    
                    // 隐藏时候从父控件中移除
                    hud.removeFromSuperViewOnHide = YES;
                    
                    // 1秒之后再消失
                    [hud hide:YES afterDelay:0.7];
                    
                    
                }
                
                [self.customTableView reloadData];
                         
                }
                else
                {
                    [MBProgressHUD showError:kError];
                         
                }
                     
             }];
         }
        else
            
        {
            
            NSArray *arr = self.orderListArr[self.btnTag];
            for (int i = 0; i < arr.count; i ++) {
                
                NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
                NSString *key = [info objectForKey:kKey];
                NSString *order_id = [arr[i] valueForKey:@"order_id"];
                
                NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",order_id,@"order_id", nil];
                [WXAFNetwork getRequestWithUrl:kDeleteOrderUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
                 {
                     if (isSuccessed) {
                         
                         NSNumber *code = [responseObject objectForKey:kCode];
                         NSDictionary *data = [responseObject objectForKey:kData];
                         if ([code integerValue] == 200) {
                             
                             [MBProgressHUD showSuccess:@"删除成功"];
                             [self headerRefreshing];
                             
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
                     
                 }];
                
            }
            
            
        }
    }
    
}


//取消订单
-(void)CancleOrderBtn:(UIButton *)btn
{
    NSArray *arr = self.orderListArr[btn.tag];
    
    for (int i = 0; i < arr.count; i ++) {
        
        NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
        NSString *key = [info objectForKey:kKey];
        NSString *order_id = [arr[i] valueForKey:@"order_id"];
        NSString *msg = @"";
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",order_id,@"order_id",msg,@"msg", nil];
        [WXAFNetwork postRequestWithUrl:kCancelOrderUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
         {
             if (isSuccessed) {
                 
                 NSNumber *code = [responseObject objectForKey:kCode];
                 NSDictionary *data = [responseObject objectForKey:kData];
                 
                 if ([code integerValue] == 200) {
                     
                     //[self.orderArr removeObjectAtIndex:btn.tag];
                     [MBProgressHUD showSuccess:@"取消成功"];
                     [self setupRefreshing];
                 }
                 else
                 {
                     [MBProgressHUD showError:[data objectForKey:kMessage]];
                     
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
    
}

//去付款
-(void)goPaymentBtn:(UIButton *)btn
{
    
    
    int  section = btn.tag;
    //设置支付的环境类型
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"listPay" forKey:@"payType"];
    
    NSArray *arr = self.orderListArr[btn.tag];
    float sum = 0;
    for (int i = 0; i < arr.count; i ++) {
        
        sum = sum + [[arr[i] valueForKey:@"order_amount"]floatValue];
    }
    
    NSString *orderId = [self.orderArr[btn.tag] valueForKey:@"pay_sn"];
    
    CGFloat   submittotalMoney = [[self.orderArr[section] valueForKey:@"pay_amount"]floatValue];
    
    NSLog(@"支付金额：%f",submittotalMoney);
    
    
    //开始支付
    Payment *payment = [[Payment alloc]init];
    payment.delegate = self;
    [payment payActionWithTradeId:orderId JsonStr:@"suzhoupay" andTotalMoney:submittotalMoney];
    
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
    
    if ([[userDefaults objectForKey:@"payType"] isEqualToString:@"listPay"])
    {
        
        //刷新数据
        //[self getSourceData];
        [self headerRefreshing];
    }
    
}

- (void)delayMethod
{
    orderVC *vc = [[orderVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setRefresh
{
    [self headerRefreshing];

}

//去评价
-(void)EvaluateBtn:(UIButton *)btn
{
    
    NSArray *arr = self.orderListArr[btn.tag];
    
    self.hidesBottomBarWhenPushed = YES;
    orderEvaluationVC *vc = [[orderEvaluationVC alloc]init];
    vc.evaluationArr = arr;
    vc.goods_id = _goods_id;
    [self.navigationController pushViewController:vc animated:YES];
    [self setupRefreshing];
}

-(void)clickBtn:(NSMutableArray *)arr
{
    orderEvaluationVC *vc = [[orderEvaluationVC alloc]init];
    vc.evalCellArr = arr;
    NSLog(@"%@",arr);
    [self.navigationController pushViewController:vc animated:YES];
    [self setupRefreshing];
}

-(void)touchBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
