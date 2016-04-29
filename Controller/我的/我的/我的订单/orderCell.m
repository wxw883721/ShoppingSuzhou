//
//  orderCell.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/26.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "orderCell.h"
#import "orderTicket.h"

@implementation orderCell
{

    UIImageView *imageLine ;
    UIImageView *goodsImage ;
    UILabel *goodsName ;
    UILabel *goodsPrice ;
    UILabel *goodsTaste ;
    UILabel *goodsNum ;
    UIImageView *imageLine2;
    UILabel *ticketLabel;
    UIImageView *ticketImageLine;
    
    UIView *view;
    UIImageView *image;
    
    NSMutableArray *sectionArr;
    NSMutableArray *totalTicketArr;

}

-(void)configFication:(NSMutableArray *)arr andOrderSectionArr:(NSMutableArray *)orderSectionArr
{
    self.orderArr = [[NSMutableArray alloc]init];
    self.orderArr = arr;
    sectionArr = orderSectionArr;
    self.goodsArr = [[NSMutableArray alloc]init];
    self.tickerHeight = 0;
    
    for (NSDictionary *goodDict in [arr valueForKey:@"extend_order_goods"]) {
        
        [self.goodsArr addObject:goodDict];
    }
    //商户名
    UILabel *storeLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, KScr_W /2- 8, 40)];
    storeLabel.text = [arr valueForKey:@"store_name"];
    storeLabel.font = [UIFont systemFontOfSize:Text_Big];
    [storeLabel setTextColor:[UIColor blackColor]];
    [self addSubview:storeLabel];
    
    UILabel *store_desc = [[UILabel alloc]initWithFrame:CGRectMake(KScr_W - 85, 0, 75, 40)];
    store_desc.text = [arr valueForKey:@"state_desc"];
    store_desc.font = [UIFont systemFontOfSize:Text_Big];
    [store_desc setTextColor:[UIColor blackColor]];
    store_desc.textAlignment = NSTextAlignmentRight;
    [self addSubview:store_desc];
    
    UIImageView *storeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScr_W - 110, 10, 21, 21)];
    storeImageView.image = [UIImage imageNamed:@"42-42.png"];
    storeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:storeImageView];
    
    totalTicketArr = [[NSMutableArray alloc]init];
    
    //有几个商品
    for (int i = 0; i < self.goodsArr.count ; i ++) {
        
        self.tickerHeight = self.tickerHeight + 40*self.ticketArr.count;
        if (!self.ticketArr) {
            self.ticketArr = [[NSMutableArray alloc]init];
        }
        
        //商户类容
        if (i == 0) {
            imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(8, 39, KScr_W - 16, 1)];
            goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, 50 ,80 , 80)];
            goodsName = [[UILabel alloc]initWithFrame:CGRectMake(90,50 , KScr_W - 170, 21)];
            goodsPrice = [[UILabel alloc]initWithFrame:CGRectMake(KScr_W - 75,50, 65, 21)];
            goodsTaste = [[UILabel alloc]initWithFrame:CGRectMake(90,105, KScr_W - 170, 21)];
            goodsNum = [[UILabel alloc]initWithFrame:CGRectMake(KScr_W - 75, 105, 65, 21)];
            imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(8, 139 ,KScr_W - 16 , 1)];
        }
        else
        {
            imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(8, 39 + 100*i + self.tickerHeight, KScr_W - 16, 1)];
            goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, 50 +100*i +self.tickerHeight,80 , 80)];
            goodsName = [[UILabel alloc]initWithFrame:CGRectMake(90,50 +100*i +self.tickerHeight , KScr_W - 170, 21)];
            goodsPrice = [[UILabel alloc]initWithFrame:CGRectMake(KScr_W - 75,50 +100*i +self.tickerHeight , 65, 21)];
            goodsTaste = [[UILabel alloc]initWithFrame:CGRectMake(90,105+100*i +self.tickerHeight, KScr_W - 170, 21)];
            goodsNum = [[UILabel alloc]initWithFrame:CGRectMake(KScr_W - 75, 105+100*i +self.tickerHeight, 65, 21)];
            imageLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(8, 139 +100*i +self.tickerHeight,KScr_W - 16 , 1)];
            
        }
        
        [self.ticketArr removeAllObjects];
        for (NSDictionary *ticketDict in [self.goodsArr[i] valueForKey:@"order_ticket"])
        {
            [self.ticketArr addObject:ticketDict];
            [totalTicketArr addObject:ticketDict];
        }
        
        
        imageLine.backgroundColor = kLineImage;
        [self addSubview:imageLine];
        
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:[self.goodsArr[i] valueForKey:@"goods_image_url"]] placeholderImage:[UIImage imageNamed:@"200-200.png"] options:0 completed:nil];
        [self addSubview:goodsImage];
        
        
        goodsName.text = [self.goodsArr[i] valueForKey:@"goods_name"];
        goodsName.font = [UIFont systemFontOfSize:Text_Big];
        [goodsName setTextColor:[UIColor blackColor]];
        [self addSubview:goodsName];
        
        
        goodsPrice.font = [UIFont systemFontOfSize:Text_Normal];
        if ([[self.goodsArr[i] valueForKey:@"goods_price"]intValue] == 0) {
            
            goodsPrice.text = @"赠品";
            [goodsPrice setTextColor:[UIColor lightGrayColor]];
        }
        else
        {
            goodsPrice.text = [NSString stringWithFormat:@"￥%.2f",[[self.goodsArr[i] valueForKey:@"goods_price"] floatValue]];
            [goodsPrice setTextColor:[UIColor blackColor]];
        }
        goodsPrice.textAlignment = NSTextAlignmentCenter;
        [self addSubview:goodsPrice];
        
        
        [goodsTaste setTextColor:[UIColor lightGrayColor]];
        goodsTaste.font = [UIFont systemFontOfSize:Text_Normal];
        if ([self.goodsArr[i] valueForKey:@"spec_name"]) {
            goodsTaste.text = @"无规格";
        }
        else
        {
            NSArray *array1 = [[self.goodsArr[i] valueForKey:@"spec_name"] componentsSeparatedByString:@","];
            NSArray *array2 = [[self.goodsArr[i] valueForKey:@"goods_spec"] componentsSeparatedByString:@","];
            
            goodsTaste.text = [NSString stringWithFormat:@"%@:%@ %@:%@",array1[0],array2[0],array1[1],array2[1]];
        }
        [self addSubview:goodsTaste];
        
        
        [goodsNum setTextColor:[UIColor blackColor]];
        goodsNum.textAlignment = NSTextAlignmentCenter;
        goodsNum.font = [UIFont systemFontOfSize:Text_Normal];
        goodsNum.text = [NSString stringWithFormat:@"x%@",[self.goodsArr[i]valueForKey:@"goods_num"]];
        [self addSubview:goodsNum];
        
        
        imageLine2.backgroundColor = kLineImage;
        [self addSubview:imageLine2];
        
        //验证码
        if (self.ticketArr.count == 0) {
            
        }
        else
        {
            NSLog(@"%@",self.ticketArr);
            for (int j = 0; j < self.ticketArr.count ; j ++) {
                
                ticketLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 140 + 100*i + 40*j + self.tickerHeight, KScr_W - 16, 40)];
                ticketImageLine = [[UIImageView alloc]initWithFrame:CGRectMake(8, 179 + 100*i + 40*j + self.tickerHeight, KScr_W - 16, 1)];
                
                ticketLabel.text = [NSString stringWithFormat:@"验证码：%@", [self.ticketArr[j] valueForKey:@"ticket"]];
                ticketLabel.font = [UIFont systemFontOfSize:Text_Normal];
                [ticketLabel setTextColor:[UIColor blackColor]];
                [self addSubview:ticketLabel];
                
                ticketImageLine.backgroundColor = kLineImage;
                [self addSubview:ticketImageLine];
                
                UIButton *ZBarBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 140 + 100*i +40*j+ self.tickerHeight, KScr_W - 16, 40)];
                [ZBarBtn addTarget:self action:@selector(ZBarBtn:) forControlEvents:UIControlEventTouchUpInside];
                ZBarBtn.tag = i + j;
                [self addSubview:ZBarBtn];
                
            }
        }
        
    }
    
    //待付款
    if ([[arr valueForKey:@"order_state"] intValue] == 10)
    {
            int num = 0;
            float sum = 0;
            for (int m = 0; m < self.goodsArr.count; m ++) {
                
                num = num + [[self.goodsArr[m] valueForKey:@"goods_num"]intValue];
                sum = sum + [[self.goodsArr[m] valueForKey:@"goods_price"]floatValue];
            }
            
            UILabel *CellNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 40 + 100*self.goodsArr.count +self.tickerHeight + 40*self.ticketArr.count , 100, 40)];
            CellNumLabel.text = [NSString stringWithFormat:@"总数：%d", num];
            CellNumLabel.font = [UIFont systemFontOfSize:Text_Normal];
            [CellNumLabel setTextColor:[UIColor blackColor]];
            [self addSubview:CellNumLabel];
            
            UILabel *CellSumLabel = [[UILabel alloc]initWithFrame:CGRectMake(118, 40 + 100*self.goodsArr.count +self.tickerHeight+ 40*self.ticketArr.count ,100, 40)];
            CellSumLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",sum];
            CellSumLabel.font = [UIFont systemFontOfSize:Text_Normal];
            [CellSumLabel setTextColor:[UIColor blackColor]];
            [self addSubview:CellSumLabel];
            
            UIButton *cancleOrder = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 78, 40 + 100*self.goodsArr.count + 8 + self.tickerHeight+ 40*self.ticketArr.count , 70, 24)];
            [cancleOrder setBackgroundColor:[UIColor whiteColor]];
            cancleOrder.layer.borderWidth = 1;
            cancleOrder.layer.borderColor = [UIColor colorWithRed:252.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1.0].CGColor;
            cancleOrder.layer.cornerRadius = 5.0;
            [cancleOrder setTitle:@"取消订单" forState:UIControlStateNormal];
            cancleOrder.titleLabel.font = [UIFont systemFontOfSize:Text_Normal];
            [cancleOrder setTitleColor:[UIColor colorWithRed:252.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [cancleOrder addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:cancleOrder];
            
            UIImageView *imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 79 + 100*self.goodsArr.count + self.tickerHeight+ 40*self.ticketArr.count , KScr_W, 1)];
            imageLine3.backgroundColor = kLineImage;
            [self addSubview:imageLine3];
            
            self.height =  40 + 100*self.goodsArr.count + 40*self.ticketArr.count + self.tickerHeight + 40;
        }
        //待消费
        else if ([[arr valueForKey:@"order_state"] intValue] == 20)
        {
           
                int num = 0;
                for (int m = 0; m < self.goodsArr.count; m ++) {
                    num = num + [[self.goodsArr[m] valueForKey:@"goods_num"]intValue];
                    
                }
                
                UILabel *CellNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 40 + 100*self.goodsArr.count +self.tickerHeight+ 40*self.ticketArr.count, 100, 40)];
                CellNumLabel.text = [NSString stringWithFormat:@"总数：%d", num];
                CellNumLabel.font = [UIFont systemFontOfSize:Text_Normal];
                [CellNumLabel setTextColor:[UIColor blackColor]];
                [self addSubview:CellNumLabel];
                
                UIButton *appleRefundBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 78, 40 + 100*self.goodsArr.count + 8 + self.tickerHeight+ 40*self.ticketArr.count , 70, 24)];
                [appleRefundBtn setBackgroundColor:[UIColor whiteColor]];
                appleRefundBtn.layer.borderWidth = 1;
                appleRefundBtn.layer.borderColor = [UIColor colorWithRed:252.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1.0].CGColor;
                appleRefundBtn.layer.cornerRadius = 5.0;
            
                appleRefundBtn.titleLabel.font = [UIFont systemFontOfSize:Text_Normal];
                
                if ([[arr valueForKey:@"lock_state"] intValue] == 1) {
                    [appleRefundBtn setTitle:@"退款中..." forState:UIControlStateNormal];
                    appleRefundBtn.userInteractionEnabled = NO;
                    [appleRefundBtn setTitleColor:[UIColor colorWithRed:197.0/255.0 green:24.0/255.0 blue:30.0/255.0 alpha:0.3] forState:UIControlStateNormal];
                    appleRefundBtn.layer.borderColor = [UIColor colorWithRed:197.0/255.0 green:24.0/255.0 blue:30.0/255.0 alpha:0.3].CGColor;
                    appleRefundBtn.backgroundColor = [UIColor whiteColor];
                }
                else
                {
                    [appleRefundBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                    [appleRefundBtn setBackgroundColor:[UIColor orangeColor]];
                    [appleRefundBtn addTarget:self action:@selector(appleRefundBtn:) forControlEvents:UIControlEventTouchUpInside];

                }

                [self addSubview:appleRefundBtn];
                
                UIImageView *imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 79 + 100*self.goodsArr.count + self.tickerHeight+ 40*self.ticketArr.count , KScr_W, 1)];
                imageLine3.backgroundColor = kLineImage;
                [self addSubview:imageLine3];
                
                self.height =  40 + 100*self.goodsArr.count + 40*self.ticketArr.count + self.tickerHeight + 40 ;
            }
         else if ([[arr valueForKey:@"order_state"] intValue] == 40)
         {
             int num = 0;
             for (int m = 0; m < self.goodsArr.count; m ++) {
                 num = num + [[self.goodsArr[m] valueForKey:@"goods_num"]intValue];
                 
             }
             
             UILabel *CellNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 40 + 100*self.goodsArr.count +self.tickerHeight+ 40*self.ticketArr.count, 100, 40)];
             CellNumLabel.text = [NSString stringWithFormat:@"总数：%d", num];
             CellNumLabel.font = [UIFont systemFontOfSize:Text_Normal];
             [CellNumLabel setTextColor:[UIColor blackColor]];
             [self addSubview:CellNumLabel];
             
             UIButton *deleteRefundBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 78, 40 + 100*self.goodsArr.count + 8 + self.tickerHeight+ 40*self.ticketArr.count , 70, 24)];
             [deleteRefundBtn setBackgroundColor:[UIColor whiteColor]];
             deleteRefundBtn.layer.borderWidth = 1;
             deleteRefundBtn.layer.borderColor = [UIColor colorWithRed:252.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1.0].CGColor;
             [deleteRefundBtn setTitleColor:[UIColor colorWithRed:252.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1.0] forState:UIControlStateNormal];
             deleteRefundBtn.layer.cornerRadius = 5.0;
             deleteRefundBtn.titleLabel.font = [UIFont systemFontOfSize:Text_Normal];
             
             if ([[arr valueForKey:@"evaluation_state"]intValue] == 1) {
                 [deleteRefundBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                 [deleteRefundBtn addTarget:self action:@selector(deleteRefundBtn:) forControlEvents:UIControlEventTouchUpInside];
                 
                 deleteRefundBtn.backgroundColor = [UIColor whiteColor];
             }
             else
             {
                 [deleteRefundBtn setTitle:@"去评价" forState:UIControlStateNormal];
                 [deleteRefundBtn addTarget:self action:@selector(evaluateBtn:) forControlEvents:UIControlEventTouchUpInside];
                 
             }
             
             [self addSubview:deleteRefundBtn];
             
             UIImageView *imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 79 + 100*self.goodsArr.count + self.tickerHeight+ 40*self.ticketArr.count , KScr_W, 1)];
             imageLine3.backgroundColor = kLineImage;
             [self addSubview:imageLine3];
         
         }
    else if ([[arr valueForKey:@"order_state"] intValue] == 0)
    {
        int num = 0;
        for (int m = 0; m < self.goodsArr.count; m ++) {
            num = num + [[self.goodsArr[m] valueForKey:@"goods_num"]intValue];
            
        }
        
        UILabel *CellNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 40 + 100*self.goodsArr.count +self.tickerHeight+ 40*self.ticketArr.count, 100, 40)];
        CellNumLabel.text = [NSString stringWithFormat:@"总数：%d", num];
        CellNumLabel.font = [UIFont systemFontOfSize:Text_Normal];
        [CellNumLabel setTextColor:[UIColor blackColor]];
        [self addSubview:CellNumLabel];
        
        UIButton *deleteRefundBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScr_W - 78, 40 + 100*self.goodsArr.count + 8 + self.tickerHeight+ 40*self.ticketArr.count , 70, 24)];
        [deleteRefundBtn setBackgroundColor:[UIColor whiteColor]];
        deleteRefundBtn.layer.borderWidth = 1;
        deleteRefundBtn.layer.borderColor = [UIColor colorWithRed:252.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1.0].CGColor;
        [deleteRefundBtn setTitleColor:[UIColor colorWithRed:252.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        deleteRefundBtn.layer.cornerRadius = 5.0;
        deleteRefundBtn.titleLabel.font = [UIFont systemFontOfSize:Text_Normal];
    
        [deleteRefundBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [deleteRefundBtn addTarget:self action:@selector(deleteRefundBtn:) forControlEvents:UIControlEventTouchUpInside];
            
        deleteRefundBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:deleteRefundBtn];
        
        UIImageView *imageLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 79 + 100*self.goodsArr.count + self.tickerHeight+ 40*self.ticketArr.count , KScr_W, 1)];
        imageLine3.backgroundColor = kLineImage;
        [self addSubview:imageLine3];
    
    }
    
}

-(void)ZBarBtn:(UIButton *)btn
{
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScr_W, KScr_H)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.3;
    [self.window addSubview:view];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getBack:)];
    [view addGestureRecognizer:gesture];
    
    image = [[UIImageView alloc]initWithFrame:CGRectMake(KScr_W/2-50, KScr_H/2-50, 100, 100)];
    [self.window addSubview:image];
    
    NSString *t_code = [totalTicketArr[btn.tag] valueForKey:@"ticket"];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:t_code,@"t_code", nil];
    [WXAFNetwork getRequestWithUrl:kTd_code parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
     {
         if (isSuccessed) {
             
             NSNumber *code = [responseObject objectForKey:kCode];
             if ([code integerValue] == 200) {
                 
                 NSDictionary *dic = [responseObject objectForKey:kData];
                 
                 [image sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"png"]] placeholderImage:nil options:0 completed:nil];
                 image.backgroundColor  = [UIColor whiteColor];
             }
         }
         
     }];
    
    NSLog(@"%@",totalTicketArr[btn.tag]);
    
}

//手势的方法
-(void)getBack:(UITapGestureRecognizer *)gesture
{
    
    [view removeFromSuperview];
    [image removeFromSuperview];
}

//一个cell里的取消订单
-(void)cancelOrder:(UIButton *)btn
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSString *order_id = [self.orderArr valueForKey:@"order_id"];
    NSString *msg = @"";
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",order_id,@"order_id",msg,@"msg", nil];
    [WXAFNetwork postRequestWithUrl:kCancelOrderUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
     {
         if (isSuccessed) {
             
             NSNumber *code = [responseObject objectForKey:kCode];
             NSDictionary *data = [responseObject objectForKey:kData];
             
             if ([code integerValue] == 200) {
                 
                 //[self.orderArr removeObjectAtIndex:btn.tag];
                 if (_delegate && [_delegate respondsToSelector:@selector(setRefresh)]) {
                     
                     [_delegate setRefresh];
                 }
                 [MBProgressHUD showSuccess:@"取消成功"];
                 
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

//申请退款
-(void)appleRefundBtn:(UIButton *)btn
{
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"是否退款" message:@"" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    [alter show];
    
}

//是否删除
-(void)deleteRefundBtn:(UIButton *)btn
{
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"是否删除" message:@"" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    [alter show];
}

//是否退款
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
    }
    else if ( buttonIndex == 0)
    {
        //申请退款
        if ([[self.orderArr valueForKey:@"order_state"] intValue] == 20)
        {
            
        NSString *order_id = [self.orderArr valueForKey:@"order_id"];
        NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
        NSString *key = [info objectForKey:kKey];
        NSLog(@"%@",order_id);
        NSString *msg = @"";
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",order_id,@"order_id",msg,@"msg", nil];
        [WXAFNetwork postRequestWithUrl:kRefundOrderUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
         {
             
             NSLog(@"%@",responseObject);
             
             if (isSuccessed) {
                 
                 NSNumber *code = [responseObject objectForKey:kCode];
                 NSDictionary *data = [responseObject objectForKey:kData];
                 if ([code integerValue] == 200)
                 {
                     
                     [MBProgressHUD showSuccess:@"退款成功"];
                     if (_delegate && [_delegate respondsToSelector:@selector(setRefresh)]) {
                         
                         [_delegate setRefresh];
                     }
                 }
                 else
                 {
                     if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
                     // 快速显示一个提示信息
                     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
                     hud.detailsLabelText = [NSString stringWithFormat:@"%@",[data objectForKey:kMessage]];
                     
                     // 再设置模式
                     hud.mode = MBProgressHUDModeCustomView;
                     
                     // 隐藏时候从父控件中移除
                     hud.removeFromSuperViewOnHide = YES;
                     
                     // 1秒之后再消失
                     [hud hide:YES afterDelay:0.7];
                     
                 }
                 
             }
             else
             {
                 [MBProgressHUD showError:kError];
                 
             }
             
         }];
        }
        
        //删除订单
        else
        {
            NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
            NSString *key = [info objectForKey:kKey];
            NSString *order_id = [self.orderArr valueForKey:@"order_id"];
            
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",order_id,@"order_id", nil];
            [WXAFNetwork getRequestWithUrl:kDeleteOrderUrl parameters:parameters resultBlock:^(BOOL isSuccessed, id responseObject, NSString *errorDescription)
             {
                 if (isSuccessed) {
                     
                     NSNumber *code = [responseObject objectForKey:kCode];
                     NSDictionary *data = [responseObject objectForKey:kData];
                     if ([code integerValue] == 200) {
                         
                         [MBProgressHUD showSuccess:@"删除成功"];
                         if (_delegate && [_delegate respondsToSelector:@selector(setRefresh)]) {
                             
                             [_delegate setRefresh];
                         }
                         
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

    }
}

//去评价
-(void)evaluateBtn:(UIButton *)btn
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickBtn:)]) {
        
        [_delegate clickBtn:self.orderArr];
    }


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
