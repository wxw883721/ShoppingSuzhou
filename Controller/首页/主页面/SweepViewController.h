//
//  SweepViewController.h
//  ShoppingSuzhou
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "DesViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface SweepViewController : DesViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    
    UIView *scanView;//添加的动画效果背景图
    UIImageView  *centerLineImgView;//扫描框中间的那条线
    NSTimer     *timer;
    
    BOOL    iScanFinish;
    
}

@property (nonatomic,strong) AVCaptureSession *captureSession;

@property (nonatomic,strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end
