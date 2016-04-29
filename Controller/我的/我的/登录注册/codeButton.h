//
//  codeButton.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface codeButton : UIButton

//设置超时时间
@property (nonatomic) int timeOut;
//倒计时
-(void)startCountDown;

-(void)addTarget:(id)target action:(SEL)action;
@end
