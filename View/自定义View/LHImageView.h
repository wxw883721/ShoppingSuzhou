//
//  LHImageView.h
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/11.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHImageView : UIImageView

@property (assign,nonatomic) id target;
@property (nonatomic) SEL action;

- (instancetype)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

- (void)addTarget:(id)target action:(SEL)action;

@end
