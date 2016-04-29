//
//  integralMallDetailVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/7/1.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface integralMallDetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *integralMallDetailView;
@property (weak, nonatomic) IBOutlet UIImageView *integralMallDetailImage;
@property (weak, nonatomic) IBOutlet UILabel *integralMallDetailScore;
@property (weak, nonatomic) IBOutlet UILabel *cashNeedsIntegral;
@property (weak, nonatomic) IBOutlet UILabel *numberRemaining;
@property (weak, nonatomic) IBOutlet UITextField *exchangeNumber;
@property (weak, nonatomic) IBOutlet UILabel *exchangeMostNumber;
@property (weak, nonatomic) IBOutlet UIButton *exchageIntegralBtn;

@property (copy,nonatomic)NSString *pgoods_id;


@end
