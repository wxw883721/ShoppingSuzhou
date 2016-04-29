//
//  LHHudView.h
//  CookingHelp
//
//  Created by 李浩 on 15/5/18.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHHudView : UIView

+(LHHudView*)sharedManger;

- (void)addViewToTarget:(id)target;

- (void)removeViewToTarget:(id)target;

@end
