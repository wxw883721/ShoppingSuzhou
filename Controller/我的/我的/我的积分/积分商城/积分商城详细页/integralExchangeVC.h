//
//  integralExchangeVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/6.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "integralMallDetailModel.h"

@interface integralExchangeVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *integralExchangeMessage;
@property (weak, nonatomic) IBOutlet UILabel *integralExchangeAdress;
@property (weak, nonatomic) IBOutlet UITextField *integralExchangePhone;
@property (weak, nonatomic) IBOutlet UILabel *integralExchangePrompt;
@property (weak, nonatomic) IBOutlet UIButton *integralExchangeBtn;

@property (nonatomic,assign) integralMallDetailModel *model;
@property (nonatomic,retain) NSDictionary *exchangeDict;
@property (nonatomic,retain) NSString *integralExchangeNumber;

@end
