//
//  LHLabel.h
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/12.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHLabel : UILabel

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

- (void)addTarget:(id)target action:(SEL)action;

@end
