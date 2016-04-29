//
//  AppDelegate.h
//  ShoppingSuzhou
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,UIScrollViewDelegate>
{
     BMKLocationService *m_locaService;
}

@property (strong, nonatomic) UIWindow *window;


@end

