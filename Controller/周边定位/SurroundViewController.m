//
//  SurroundViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "SurroundViewController.h"
#import "LHZhouBianModel.h"
#import "Size.h"
#import "aroundStoreModel.h"

#import "SuShopDetailViewController.h"

@interface SurroundViewController ()

@end

@implementation SurroundViewController
{
    BOOL _init;
    NSMutableArray* _modelArray;
    
    NSString *longitude;
    NSString *latitude;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /** 1.设置导航栏*/
    [self createNavgation];
    
    m_mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] ;
    m_mapView.backgroundColor = [UIColor redColor];
    [m_mapView setZoomLevel:16];
    m_mapView.showsUserLocation = YES;//拉取附件的洗车店要用到用户当前的位置信息
    m_mapView.scrollEnabled = YES;
    m_mapView.zoomEnabled = YES;
    m_mapView.userInteractionEnabled = YES;
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *lat = [info objectForKey:@"lat"];
    NSString *lon = [info objectForKey:@"lon"];
    
    NSLog(@"%@ %@",lat,lon);
    
    CLLocationCoordinate2D locationCoor = CLLocationCoordinate2DMake([lat floatValue], [lon floatValue]);
    
    [self.view addSubview:m_mapView];
    
    [m_mapView setCenterCoordinate:locationCoor animated:YES];
    
    
    [self requestDataWithLongtitude:lon andLatitude:lat];
    
    
    
}

- (void)startLocation
{
    m_mapView.showsUserLocation = NO;//先关闭显示的定位图层
    m_mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    m_mapView.showsUserLocation = YES;//显示定位图层
}

-(void)viewWillAppear:(BOOL)animated
{
    [m_mapView viewWillAppear];
    self.tabBarController.tabBar.hidden = NO;
    
    m_mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//    m_locaService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [m_mapView viewWillDisappear];
    m_mapView.delegate = nil; // 不用时，置nil
//    m_locaService.delegate =nil;
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

 /** 1.设置导航栏*/
-(void)createNavgation {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"red.png"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    label.text  = @"周边商户";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = label;
    
}

-(void)requestDataWithLongtitude:(NSString *)lng andLatitude:(NSString *)lat
{
    if (!_modelArray)
    {
        _modelArray = [[NSMutableArray alloc]init];
    }
    [_modelArray removeAllObjects];
    
    NSString *url = [NSString stringWithFormat:@"%@&lng=%@&lat=%@",kAroundStore,lng,lat];
    NSLog(@"%@",url);
    [WXAFNetwork getRequestWithUrl:url parameters:nil resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
     {
         if (isSuccessed)
         {
             
             NSNumber *code = [resultObject objectForKey:kCode];
             
             if([code integerValue] == 200)
             {
                 if ([[resultObject objectForKey:kData] isKindOfClass:[NSDictionary class]])
                 {
                 
                     [MBProgressHUD showError:[[resultObject objectForKey:kData]objectForKey:kMessage]];
                 }
             
                 else
                {
                    NSArray *data = [resultObject objectForKey:kData];
                     for (NSDictionary *dict in data) {
                         aroundStoreModel *model = [[aroundStoreModel alloc]init];
                         [model setValuesForKeysWithDictionary:dict];
                         [_modelArray addObject:model];
                     }
                    [self createAnniPoint];
                }
             }
         }
         else
         {
             NSLog(@"%@",errorDescription);
         }
     
    }];

}

- (void)createAnniPoint
{
    NSLog(@"%@",_modelArray);
    
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:m_mapView.annotations];
    [m_mapView removeAnnotations:array];
    
    for (int i = 0;i < _modelArray.count; i ++) {
        
        goDetailBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 25)];
        goDetailBtn.tag = 100+i;
        [goDetailBtn setImage:[UIImage imageNamed:@"jiantou2"] forState:UIControlStateNormal];
        [goDetailBtn addTarget:self action:@selector(goDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        
        aroundStoreModel*model = _modelArray[i];
        
        BMKPointAnnotation *poi = [[BMKPointAnnotation alloc] init];
        poi.title = model.store_name;
        
        poi.coordinate = CLLocationCoordinate2DMake([model.store_y floatValue], [model.store_x floatValue]);
        
        [m_mapView addAnnotation:poi];
        
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    
//   annotationView.image = [UIImage imageNamed:@"datouzhen"];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 20);
    btn.backgroundColor = [UIColor redColor];
    annotationView.rightCalloutAccessoryView = goDetailBtn;
     
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}


- (void)goDetailAction:(UIButton *)sender
{
    int i = sender.tag - 100;
    
    aroundStoreModel *model = _modelArray[i];
    
    SuShopDetailViewController *vc = [[SuShopDetailViewController alloc] init];
    vc.store_id = model.store_id;
    vc.backRootVC = @"0";
    [self.navigationController pushViewController:vc animated:NO];
    
}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    //[mapView bringSubviewToFront:view];
    //[mapView setNeedsDisplay];
    
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    
    NSLog(@"didAddAnnotationViews");
}




@end
