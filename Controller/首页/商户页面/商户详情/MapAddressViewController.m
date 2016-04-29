//
//  MapAddressViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "MapAddressViewController.h"

@interface MapAddressViewController ()

@end

@implementation MapAddressViewController

- (void)viewDidLoad {
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
    
    
    CLLocationCoordinate2D locationCoor = CLLocationCoordinate2DMake([_lat floatValue], [_lng floatValue]);
    
    [self.view addSubview:m_mapView];

    [m_mapView setCenterCoordinate:locationCoor animated:YES];
    
    [self createAnniPoint];
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
    label.text  = @"商户地址";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = label;
    
}

- (void)createAnniPoint
{
    
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:m_mapView.annotations];
    [m_mapView removeAnnotations:array];
    
    
        
        BMKPointAnnotation *poi = [[BMKPointAnnotation alloc] init];
        poi.title = _store_name;
        
        poi.coordinate = CLLocationCoordinate2DMake([_lat floatValue], [_lng floatValue]);
        
        [m_mapView addAnnotation:poi];
        
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
    
    
    
    
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
