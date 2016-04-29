//
//  HJCountdownView.h
//  TimeDownTest
//
//  Created by apple on 15/1/22.
//  Copyright (c) 2015年 HYL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJCountdownView : UIView

@property (nonatomic,copy) NSString * startTime; //活动起始时间
@property (nonatomic,assign) NSInteger amountTime; //活动时间 (小时单位)
@property (nonatomic,strong) NSNumber * leaveTime; //剩余时间
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (weak, nonatomic) IBOutlet UILabel *minute;
@property (weak, nonatomic) IBOutlet UILabel *second;

@end
