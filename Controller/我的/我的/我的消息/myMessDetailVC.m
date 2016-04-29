//
//  myMessDetailVC.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/28.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "myMessDetailVC.h"

@interface myMessDetailVC ()
{
    UIButton *leftBtn;
    UILabel *receivingLabel;
    UILabel *contentMessLabel;

}

@property (nonatomic,retain)NSMutableArray *messDetailArr;

@end

@implementation myMessDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self createView];
    [self requestData];
    
    self.messDetailArr = [[NSMutableArray alloc]init];
    
}


-(void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"消息详情";
    leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    [leftBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = item;

}

-(void)requestData
{

    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *key = [info objectForKey:kKey];
    NSLog(@"%@",self.message_id);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",self.message_id,@"message_id", nil];
    [WXAFNetwork getRequestWithUrl:kMessDetail parameters:parameters resultBlock:^(BOOL isSuccessed, id resultObject, NSString *errorDescription)
     {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (isSuccessed) {
             
             NSNumber *code = [resultObject objectForKey:kCode];
             NSArray *data = [resultObject objectForKey:kData];
             
             if ([code integerValue] == 200) {
                
                for (NSDictionary *dict in data) {
                    contentMessLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 80,KScr_W - 16, KScr_H - 80)];
                    contentMessLabel.numberOfLines = 0;
                    contentMessLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    contentMessLabel.text = [dict valueForKey:@"message_body"];
                    CGSize size = [contentMessLabel sizeThatFits:CGSizeMake(contentMessLabel.frame.size.width, MAXFLOAT)];
                    contentMessLabel.frame = CGRectMake(8,80 , KScr_W - 16, size.height);
                    
                    contentMessLabel.layer.borderColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0].CGColor;
                    contentMessLabel.layer.borderWidth = 1.0;
                    contentMessLabel.font = [UIFont systemFontOfSize:Text_Normal];
                    [contentMessLabel setTextColor:[UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0]];
                    
                    [self.view addSubview:contentMessLabel];

                    receivingLabel.text = [NSString stringWithFormat:@"接收时间: %@",[dict  valueForKey:@"message_update_time" ]];
                 
             }
         }
    }
     else
     {
         [MBProgressHUD showError:kError];
     
     }
     
     }];


}

-(void)createView
{
    
    receivingLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, KScr_W -16, 24)];
    
    receivingLabel.font = [UIFont systemFontOfSize:Text_Big];
    [receivingLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:receivingLabel];
    
    UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(8, 39, KScr_W - 16, 1)];
    imageLine.backgroundColor = kLineImage;
    [self.view addSubview:imageLine];
    
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 48, KScr_W -16, 24)];
    messageLabel.text = @"消息内容:";
    messageLabel.font = [UIFont systemFontOfSize:Text_Big];
    [messageLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:messageLabel];
    
//    UIView *contentMessView = [[UIView alloc]initWithFrame:CGRectMake(8, 80, KScr_W - 16, 120)];
//    contentMessView.layer.borderColor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0].CGColor;
//    contentMessView.layer.borderWidth =  1.0;
//    [self.view addSubview:contentMessView];
   
    
}


-(void)touchBtn:(UIButton *)btn
{

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
