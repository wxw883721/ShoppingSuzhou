//
//  Payment.h
//  MMall
//
//  Created by apple on 15-1-26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Payment;
@protocol PaymentDelegate <NSObject>

@optional
- (void)finishPay;

- (void)finishPayFailure;

@end

@interface Payment : NSObject

@property (nonatomic,weak)id<PaymentDelegate>delegate;

-(void)payActionWithTradeId:(NSString*)orderId JsonStr:(NSString*)jsonStr andTotalMoney:(CGFloat)totalMoney;

@end
