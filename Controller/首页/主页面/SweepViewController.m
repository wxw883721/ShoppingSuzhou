//
//  SweepViewController.m
//  ShoppingSuzhou
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "SweepViewController.h"
#import "SuShopDetailViewController.h"
#import "LHGodsDetailViewController.h"
#import "HomeViewController.h"

@interface SweepViewController ()

@end

@implementation SweepViewController
@synthesize captureSession = _captureSession,videoPreviewLayer = _videoPreviewLayer;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
    [self setViewTitle:@"扫描二维码"];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self sweepAction];
    
}

- (void)sweepAction
{
    iScanFinish = NO;
    AVCaptureDevice *captureDevice = [AVCaptureDevice  defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input)
    {
        
        NSLog(@"%@", [error localizedDescription]);
        
    }
    else
    {
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession addInput:input];
        
        AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        
        [_captureSession addOutput:captureMetadataOutput];
        
        //创建一个队列
        dispatch_queue_t dispatchQueue;
        
        dispatchQueue = dispatch_queue_create("myQueue",NULL);
        
        [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
        
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
        
        
        //降捕获的数据流展现出来
        
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
        
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        // [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
        
        // [_viewPreview.layer addSublayer:_videoPreviewLayer];
        
        [_videoPreviewLayer setFrame:self.view.layer.bounds];
        
        
        //添加瞄准视图
        if (scanView!=nil)
        {
            [scanView removeFromSuperview];
        }
        scanView = [[UIView alloc]initWithFrame:CGRectMake(35, 50, 250, 300)];
        scanView.backgroundColor = [UIColor clearColor];
        scanView.layer.borderWidth = 1;
        scanView.layer.borderColor = [[UIColor whiteColor]CGColor];
        
        //那个横着的条
        centerLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250,10)];
        centerLineImgView.image = [UIImage imageNamed:@"qrcode_scan_light_green@2x.png"];
        [scanView addSubview:centerLineImgView];
        
        timer = [NSTimer
                 scheduledTimerWithTimeInterval:3
                 target:self
                 selector:@selector(animationHorizontal)
                 userInfo:nil
                 repeats:YES];
        
        [timer fire];
        
        [self.view.layer addSublayer:_videoPreviewLayer];
        
        [self.view addSubview:scanView];
        
        
        //开始捕获
        [_captureSession startRunning];
    }
}
//这个是动画
- (void)animationHorizontal
{
    centerLineImgView.frame = CGRectMake(0, 0, 250, 10);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:3.0f];
    // centerLineImgView.frame = CGRectMake(0,290, 250, 10);//这地方根据自己图片改
    centerLineImgView.frame = CGRectMake(0,290, 250, 10);//这地方根据自己图片改
    
    [UIView commitAnimations];
}


//获得的数据在AVCaptureMetadataOutputObjectsDelegate 唯一定义的方法中

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    if (iScanFinish)
    {
        return;
    }
    else
    {
        //判断是否有数据，是否是二维码数据
        if (metadataObjects != nil && [metadataObjects count] > 0)
        {
            iScanFinish = YES;
            AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects  objectAtIndex:0];
            
            if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode])
            {
                
                //获得扫描的数据，并结束扫描
                NSLog(@"扫到的数据是：%@",metadataObj);
                
                
                NSLog(@"扫到的stringvalue：%@",metadataObj.stringValue);
                [self performSelectorOnMainThread:@selector(stopReading:)withObject:metadataObj.stringValue  waitUntilDone:NO];
               
            }
        }
    }
}


//参数id就是函数中的Object对象
- (void)stopReading:(id)sender
{
    
    NSLog(@"参数：%@",sender);
    
    NSString *detail = (NSString *)sender;
    
    [_captureSession stopRunning];
    [scanView removeFromSuperview];
    [_videoPreviewLayer removeFromSuperlayer];
    iScanFinish = NO;
    
    if ([detail hasPrefix:@"store"]||[detail hasPrefix:@"goods"])
    {
        if ([detail hasPrefix:@"store"])
        {
            NSString *store_id = [detail substringFromIndex:6];
            
            SuShopDetailViewController *vc = [[SuShopDetailViewController alloc] init];
            vc.store_id = store_id;
            vc.backRootVC = @"1";
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else
        {
            NSString *good_id = [detail substringFromIndex:6];
            
            LHGodsDetailViewController *vc = [[LHGodsDetailViewController alloc] init];
            vc.goods_id = good_id;
            vc.backRootVC = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"codeError" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
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
