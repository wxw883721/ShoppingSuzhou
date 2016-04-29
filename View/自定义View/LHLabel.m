//
//  LHLabel.m
//  ShoppingSuzhou
//
//  Created by YQ on 15/6/12.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "LHLabel.h"

@implementation LHLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
