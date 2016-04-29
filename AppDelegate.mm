//
//  AppDelegate.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "APService.h"
#import "NewFeatureViewController.h"
#import "IQKeyboardManager.h"

//支付宝支付回调
#import <AlipaySDK/AlipaySDK.h>

#define KeyBoardManager [IQKeyboardManager sharedManager]

BMKMapManager* _mapManager;
@interface AppDelegate ()

{
    BOOL isOut;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //启动图片停留时间
    [NSThread sleepForTimeInterval:1.0];
    
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //设置推送角标为0；
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

//引导页设定
    NSString *key = (NSString *)kCFBundleVersionKey;
    
    //从Info.plist中取出版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    
    //从沙盒中取出上次存储的版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    NSLog(@"**********存储的版本号的%@",saveVersion);
    
    if([version isEqualToString:saveVersion])
    {
        TabBarViewController *rvc = [[TabBarViewController alloc]init];
        //不是第一次显示版本
        //不显示状态栏
//        application.statusBarHidden = NO;
        self.window.rootViewController = rvc;
        
        //self.window.rootViewController = [[ToolViewController alloc]init];
    }
    else
    {
        //第一次使用新版本 将版本号写入沙盒
        [[NSUserDefaults standardUserDefaults]setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NewFeatureViewController *vc = [[NewFeatureViewController alloc] init];
        
        self.window.rootViewController = vc;
        
        
        //第一次使用新版本 将激光推送开关设为开启状态
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:kPushState];
        
    }
    
    
// 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"naNrfl1odgA9nMSswedQ0csb" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
     m_locaService = [[BMKLocationService alloc]init];
    
    [m_locaService startUserLocationService];
    m_locaService.delegate =self;

    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kPushState] integerValue] == 0)
    {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    else
    {
        //极光
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
        {
            //categories
            [APService
             registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                 UIUserNotificationTypeSound |
                                                 UIUserNotificationTypeAlert)
             categories:nil];
        }
        else
        {
            //categories nil
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
#else
             //categories nil
             categories:nil];
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
#endif
             // Required
             categories:nil];
        }
        [APService setupWithOption:launchOptions];
        
        NSString *JPushID = [APService registrationID];
                
        [[NSUserDefaults standardUserDefaults] setObject:JPushID forKey:kJcode];
        
    }
    
//友盟
    [UMSocialData setAppKey:@"55af40dbe0f55a214800035b"];
    
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"55af40dbe0f55a214800035b" url:@"http://www.bgsz.tv/shop/index.php"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxf63d69f0c196bad8" appSecret:@"b303f0a0a4551fef66bb5714d80e5472" url:@"http://www.bgsz.tv/shop/index.php"];
   
    [self.window makeKeyAndVisible];
    [self setupKeyBoard];
    return YES;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)setupKeyBoard{
    
    [KeyBoardManager setEnable:YES];
    [KeyBoardManager setEnableAutoToolbar:NO];
    [KeyBoardManager setKeyboardDistanceFromTextField:15];
    [KeyBoardManager setShouldResignOnTouchOutside:YES];
    [KeyBoardManager setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    [KeyBoardManager setCanAdjustTextView:YES];
}



//友盟
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic)
         {
             NSLog(@"result = %@", resultDic);
             
             if ([[resultDic valueForKey:@"resultStatus"] integerValue] == 9000)//支付成功，抛出通知
             {
                 //支付宝支付成功，向充值页面发出通知
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"havePaySuccessful" object:nil];
                 
                 
             }
             else
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"havePayFailure" object:nil];
             }
             
         }];
        
        return YES;
    }
    else
    {
        return  [UMSocialSnsService handleOpenURL:url];

    }
    
    
    
}


//地图的代理方法
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
//    [m_mapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    
    if ([info objectForKey:@"lat"]) {
        [info removeObjectForKey:@"lat"];
    }
    if ([info objectForKey:@"lon"]) {
        [info removeObjectForKey:@"lon"];
    }
    
    NSString *lat = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    
    [info setObject:lat forKey:@"lat"];
    [info setObject:lon forKey:@"lon"];
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

//极光代理
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    [info setValue:deviceToken forKey:@"deviceToken"];
    
    // Required
    NSLog(@"%@",deviceToken);
    
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Required
    [APService handleRemoteNotification:userInfo];
}




- (void)applicationWillResignActive:(UIApplication *)application {
     //[BMKMapView willBackGround];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //[BMKMapView didForeGround];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
