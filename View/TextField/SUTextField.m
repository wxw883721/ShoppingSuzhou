//
//  SUTextField.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/18.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "SUTextField.h"
#define kBorder 15

@implementation SUTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawPlaceholderInRect:(CGRect)rect
{
    NSMutableDictionary *attirs = [NSMutableDictionary dictionary];
    attirs[NSFontAttributeName] = [UIFont systemFontOfSize:Text_Normal];
    attirs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    CGFloat holderH = [self.placeholder sizeWithAttributes:attirs].height;
    CGFloat x = rect.origin.x;
    CGFloat y = (rect.size.height - holderH) * 0.5;
    CGFloat w = rect.size.width;
    CGFloat h = holderH;
    CGRect frame = CGRectMake(x, y, w, h);
    
    [self.placeholder drawInRect:frame withAttributes:attirs];
}

//控制编辑文本的位置(编辑状态指的是 点击文本框后光标闪烁)
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + kBorder, bounds.origin.y, bounds.size.width - kBorder, bounds.size.height);
    
    return inset;
}

//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + kBorder, bounds.origin.y, bounds.size.width - kBorder, bounds.size.height);//更好理解些
    
    return inset;
    
}

@end
