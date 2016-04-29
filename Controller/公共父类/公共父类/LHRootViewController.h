//
//  LHRootViewController.h
//  HandCooking
//
//  Created by qianfeng on 15-4-20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHRootViewController : UIViewController

@property (nonatomic,strong) NSMutableArray* dataSource;

//设置导航栏
- (void)createNavWithImage:(UIImage*)image View:(UIView*)view frame:(CGRect)frame title:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)color;

//设置导航栏按钮
- (void)createNavItemWithImage:(UIImage*)image frame:(CGRect)frame title:(NSString*)title posi:(posi)posi target:(id)target action:(SEL)action;

//网络GET请求
- (void)RequestWithURL:(NSString*)url target:(id)target action:(SEL)action;

- (void)cacheWithUrl:(NSString *)urlString callback:(void(^)(NSData* data))callback;

//POST请求
- (void)PostRequestWithUrl:(NSString*)url parameters:(id)parameters success:(void(^)(LHRequest* request,NSData* data))success failed:(void(^)(LHRequest* request))failed;

//中文字符串转化
- (NSString*)urlString:(NSString*)url;

//处理缓存
- (void)cacheWithUrl:(NSString*)urlString target:(id)target action:(SEL)action;

//添加压栈动画
- (void)pushToViewController:(UIViewController*)vc;

//添加退栈动画
- (void)popToViewController;
//添加请求动漫
- (void)addHudViewTo:(id)target;
//移除请求动漫
- (void)removeHudViewFrom:(id)target;

@end
