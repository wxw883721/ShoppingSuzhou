//
//  predepositDetailVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/8.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface predepositDetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *predepositMoney;
@property (weak, nonatomic) IBOutlet UILabel *predepositTime;
@property (weak, nonatomic) IBOutlet UILabel *predepositInstructions;

@property (nonatomic,retain) NSString *lg_id;

@end
