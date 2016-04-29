//
//  MapAddressViewController.h
//  ShoppingSuzhou
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "DesViewController.h"
#import "BMapKit.h"

@interface MapAddressViewController : DesViewController<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKMapView * m_mapView;
    
}

@property (copy,nonatomic)  NSString *lat;
@property (copy,nonatomic)  NSString *lng;
@property (copy,nonatomic)  NSString *store_name;

@end
