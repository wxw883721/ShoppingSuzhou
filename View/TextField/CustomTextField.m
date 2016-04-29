//
//  CustomTextField.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/18.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField
{
    id _object;
    SEL _method;
}

- (id)initWithFrame:(CGRect)frame andisRightMode:(BOOL)right andisNeedBorder:(BOOL)need andisMain:(BOOL)main
{
    self= [super initWithFrame:frame];
    if (self) {
        
        self.placeholder=@"请输入商品关键字";
        self.layer.cornerRadius=5;
        self.font=[UIFont systemFontOfSize:Text_Big];
        if (main)
        {
            self.backgroundColor=[UIColor colorWithRed:0.98f green:0.69f blue:0.40f alpha:1.00f];
            
        }
        else
        {
            self.backgroundColor=[UIColor whiteColor];
            
        }
        if (need)
        {
            
            self.textColor=[UIColor colorWithRed:20.0f/255.0f green:145.0f/255.0f blue:210.0f/255.0f alpha:1.00f];
            self.layer.borderWidth=0.5f;
            self.layer.borderColor=[[UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.00f] CGColor];
        }
        if (right) {
            UIButton *searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            searchBtn.frame = CGRectMake(1, 1,self.frame.size.height*0.6, self.frame.size.height*0.6);
            searchBtn.titleLabel.text = @"搜索";
            searchBtn.titleLabel.font = [UIFont systemFontOfSize:Text_Big];
            self.rightViewMode=UITextFieldViewModeAlways;
            self.rightView=searchBtn;
        }
    }
    return self;
}

- (void)setTarget:(id)object andMethod:(SEL)method
{
    
    _object=object;
    _method=method;
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_object&&[_object respondsToSelector:_method]) {
        [_object performSelector:_method withObject:nil];
    }
    
    
}


@end
