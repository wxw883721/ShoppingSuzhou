//
//  SurroundViewController.h
//  ShoppingSuzhou
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "LHRootViewController.h"
#import "BMapKit.h"

@interface SurroundViewController : LHRootViewController<BMKMapViewDelegate,BMKLocationServiceDelegate>
{

    BMKMapView * m_mapView;
    
    UIButton *goDetailBtn;
}

@end
