//
//  LHRootViewController.m
//  HandCooking
//
//  Created by qianfeng on 15-4-20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "LHRootViewController.h"

@interface LHRootViewController ()

@end

@implementation LHRootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark- 创建导航栏
- (void)createNavWithImage:(UIImage*)image View:(UIView*)view frame:(CGRect)frame title:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)color
{
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [view setFrame:frame];
    if ([view isMemberOfClass:[UILabel class]]) {
        UILabel* label = (UILabel*)view;
        [label setText:title];
        [label setFont:font];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:color];
    }
    [self.navigationItem setTitleView:view];
}

#pragma mark- 创建导航栏按钮
- (void)createNavItemWithImage:(UIImage*)image frame:(CGRect)frame title:(NSString*)title posi:(posi)posi target:(id)target action:(SEL)action
{
    UIButton* btn = [LHTool ButtonWithFrame:frame image:image title:title titleColor:nil target:target action:action];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    if (posi == LEFT) {
        [self.navigationItem setLeftBarButtonItem:item];
    }else{
        [self.navigationItem setRightBarButtonItem:item];
    }
}

#pragma mark- 开始请求
- (void)RequestWithURL:(NSString*)url target:(id)target action:(SEL)action;
{
    __weak LHRequestMissonManger* manager = [LHRequestMissonManger manager];
    [manager addGETMissionWithURL:url success:^(LHRequest *request, NSData *data) {
        [[PSBCachesManager defaultManager] insertCacheWithURL:url data:data];
        [target performSelector:action withObject:data];
        [manager removeRequest:request]; 
    } failed:^(LHRequest *request) {
        [manager removeRequest:request];
    }];
}

- (void)RequestWithURL:(NSString *)url callback:(void(^)(NSData* data))callback
{
    __weak LHRequestMissonManger* manager = [LHRequestMissonManger manager];
    [manager addGETMissionWithURL:url success:^(LHRequest *request, NSData *data) {
        [[PSBCachesManager defaultManager] insertCacheWithURL:url data:data];
        callback(data);
        [manager removeRequest:request];
    } failed:^(LHRequest *request) {
        [manager removeRequest:request];
    }];
}

#pragma mark- POST请求
- (void)PostRequestWithUrl:(NSString*)url parameters:(id)parameters success:(void(^)(LHRequest* request,NSData* data))success failed:(void(^)(LHRequest* request))failed;
{
    LHRequest* request = [[LHRequest alloc] init];
    request.success = success;
    request.failed = failed;
    [request requestPost:parameters url:url];
}

#pragma mark- 字符串转化
- (NSString*)urlString:(NSString*)url
{
    NSString* urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 处理缓存
- (void)cacheWithUrl:(NSString *)urlString target:(id)target action:(SEL)action
{
    PSBCachesManager* manger = [PSBCachesManager defaultManager];
    NSData* data = [manger dataFromCachesWithURL:urlString];
    if (data) {
        [target performSelector:action withObject:data];
    }else{
        [target RequestWithURL:urlString target:target action:action];
    }
}

- (void)cacheWithUrl:(NSString *)urlString callback:(void(^)(NSData* data))callback
{
    PSBCachesManager* manger = [PSBCachesManager defaultManager];
    NSData* data = [manger dataFromCachesWithURL:urlString];
    if (data) {
        callback(data);
    }else{
        [self RequestWithURL:urlString callback:callback];
    }
}

//#pragma mark- 压栈动画
//- (void)pushToViewController:(UIViewController*)vc
//{
//    NSArray*array=@[@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"rotate",@"cameraIrisHollowOpen",@"cameraIrisHollowClose",kCATransitionFade,kCATransitionMoveIn,kCATransitionPush,kCATransitionReveal];
//    
//    NSString*type=array[arc4random()%13];
//    
//    CATransition*ani=[CATransition animation];
//    ani.type=type;
//    ani.subtype=kCATransitionFromLeft;
//    ani.duration=1;
//    [self.navigationController.view.layer addAnimation:ani forKey:nil];
//    [self.navigationController pushViewController:vc animated:NO];
//}
//
//#pragma mark- 退栈动画
//- (void)popToViewController
//{
//    NSArray*array=@[@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"rotate",@"cameraIrisHollowOpen",@"cameraIrisHollowClose",kCATransitionFade,kCATransitionMoveIn,kCATransitionPush,kCATransitionReveal];
//    
//    NSString*type=array[arc4random()%13];
//    
//    CATransition*ani=[CATransition animation];
//    ani.type=type;
//    ani.subtype=kCATransitionFromRight;
//    ani.duration=1;
//    [self.navigationController.view.layer addAnimation:ani forKey:nil];
//    [self.navigationController popViewControllerAnimated:NO];
//}

#pragma mark- 添加请求动漫
- (void)addHudViewTo:(id)target
{
    LHHudView* view = [LHHudView sharedManger];
    [view addViewToTarget:target];
}

#pragma mark- 移除请求动漫
- (void)removeHudViewFrom:(id)target
{
    LHHudView* view = [LHHudView sharedManger];
    [view removeViewToTarget:target];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStory
 boardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
