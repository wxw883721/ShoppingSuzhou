//
//  LHHudView.m
//  CookingHelp
//
//  Created by 李浩 on 15/5/18.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "LHHudView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation LHHudView
{
    UIActivityIndicatorView* _activityView;
    UIView* _view;
    UILabel* _label;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _view.backgroundColor = [UIColor blackColor];
        _view.alpha = 0.5;
        [self addSubview:_view];
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.frame = CGRectMake(SCREEN_WIDTH/2-40, SCREEN_HEIGHT/2-30, 80, 60);
        _label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT/2+30, 100, 40)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"正在请求数据";
        _label.backgroundColor = [UIColor blackColor];
        _label.alpha = 0.5;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:Text_Normal];
        [_view addSubview:_label];
        [_activityView startAnimating];
        [_view addSubview:_activityView];
    }
    return self;
}

+(LHHudView*)sharedManger
{
    static LHHudView *lhView = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lhView = [[LHHudView alloc] init];
    });
    
    return lhView;
}

- (void)addViewToTarget:(id)target
{
    UIViewController* vc = (UIViewController*)target;
    [vc.view addSubview:self];
}

- (void)removeViewToTarget:(id)target
{
    [NSThread sleepForTimeInterval:0.5];
    UIViewController* vc = (UIViewController*)target;
    for (UIView* view in vc.view.subviews) {
        if ([view isMemberOfClass:[LHHudView class]]) {
            [view removeFromSuperview];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
