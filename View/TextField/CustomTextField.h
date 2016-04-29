//
//  CustomTextField.h
//  ShoppingSuzhou
//
//  Created by apple on 15/5/18.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "SUTextField.h"

@interface CustomTextField : SUTextField

- (id)initWithFrame:(CGRect)frame andisRightMode:(BOOL)right andisNeedBorder:(BOOL)need andisMain:(BOOL)main;
- (void)setTarget:(id)object andMethod:(SEL)method;

@end
