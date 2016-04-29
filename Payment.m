//
//  Payment.m
//  MMall
//
//  Created by apple on 15-1-26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Payment.h"


#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>


@implementation Payment




-(void)payActionWithTradeId:(NSString*)orderId JsonStr:(NSString*)jsonStr andTotalMoney:(CGFloat)totalMoney;
{
    NSString *partner = @"2088911725134728";
    NSString *seller = @"2088911725134728";
    
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOOxHPwHB7yWwCpK+5yD2xiaO2ZY91zqOtTDMcbc+72D58D41sAFXnMAFosNPK7MZpbfR0tD4X0BH4bgw8fsU0SbsJDLciCSf1d4DC91wj9f762o0nvR/m0NdvZ/9yNbgHGYIWqDohXqmWEDqF9/C/sZ3aFFUbSiMF/0T2SOrIi9AgMBAAECgYAu63N+l/BHM4V78aGx2hYPFtFAwPqQYhAngeXDBgy2O/VI9b5DKZgR+KWsl9i2aJaHZpFpeB6CRPX7NFwD2bY6nJeDUJp9PGiDIkdYuIYLUcMkJXkBMlSKVtDFfI08eFNK9jtuVV7kdd8feU6pywtBHU2Cg174C0PH4svcjiGtnQJBAPbTS8Z33hCmsfDQPPV62Q0rlZGajARqFtkbsHeQ2GCjDkhmXDafS5TAKfpSHmxmoYKLIqrY4teGkYAbxx1DxhsCQQDsJ7/QVzQtr8lIexvFSHH8IOxPTmfh8W+F3XA0It2+wo9RM6lryoNs9rQxxHF0NhNZSVx8JvqUldfOpSxj0DoHAkBVQG3vwv8kaS8UqhgkAaZuchtbCzJJZAs4OeQdqB3UYv1P7Gr1QtfsLONS3oI7lsc6O6xhrj/LiWNACFght4L5AkBDEeL7U9kA5L0A9d3kQPgGiH804urEE+L9nO+CDyj1RaKYiFikwYZkCwkQXV9vhvAl2p0GsbdXPdtl2ClsS7Y/AkEA1j5AiPNHZMuWrih+Kp3TvziNWnWqhkVxalotdI69aFWnKXKBoHhJXQdyxNGEtXwZbZ3UvG/vVHsi7OgQu+hzPA==";
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    //生成订单信息及签名
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderId; //订单ID（由商家自行制定）
    order.productName = @"订单支付支付"; //商品标题
    
    order.productDescription = jsonStr; //商品描述,这里是后台生成订单的凭据
    order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格,这里用0.01来测试
    order.notifyURL =  @"http://www.bgsz.tv/mobile/notify_url.php"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"suzhoubaigoupay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
         {
             
             NSLog(@"reslut = %@",resultDic);
             
             NSLog(@"结果：%@",[resultDic valueForKey:@"memo"]);
             
             // NSLog(@"code：%@",[[resultDic valueForKey:@"memo"] valueForKey:@"Code"]);
             
             //[resultDic valueForKey:@"resultStatus"] == 4000,当id不对，私钥对的的时候，结果状态是4000，当用户中途点击取消按钮来取消本次支付的时候状态值是6001，
             
             if ([[resultDic valueForKey:@"resultStatus"] integerValue] == 9000)
             {
                 if (self.delegate && [self.delegate respondsToSelector:@selector(finishPay)])
                 {
                     [self.delegate finishPay];
                 }
             }
             else
             {
                 if (self.delegate && [self.delegate respondsToSelector:@selector(finishPayFailure)])
                 {
                     [self.delegate finishPayFailure];
                 }
             }
             
         }];
        
    }
}
@end
