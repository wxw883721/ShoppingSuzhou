//
//  HJCountdownView.m
//  TimeDownTest
//
//  Created by apple on 15/1/22.
//  Copyright (c) 2015年 HYL. All rights reserved.
//

#import "HJCountdownView.h"

@implementation HJCountdownView
{
    double passTime;
    double leftTime;
    double CustomLeftTime;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    _hour.superview.layer.cornerRadius=3;
    _minute.superview.layer.cornerRadius=3;
    _second.superview.layer.cornerRadius=3;
}

- (void)setStartTime:(NSString *)startTime
{
    _startTime = startTime;
    
    NSString * currentTime = [self getCurrentDate];
    //NSLog(@"currentTime : %@",currentTime);
    
    passTime = [self getStringTimeDiff:_startTime timeE:currentTime];
    if (passTime<=0)
    {
        
    }
    else{
    //NSLog(@"passTime : %f",passTime);
    [self setAmountTime];
    }

}

- (void)setLeaveTime:(NSNumber *)leaveTime
{
    _leaveTime= leaveTime;
    
    CustomLeftTime =ABS([_leaveTime floatValue]);
    //NSLog(@"剩余时间:%f,leave:%@",CustomLeftTime,_leaveTime);
    if (CustomLeftTime>0)
    {
        passTime=CustomLeftTime;
        [self setAmountTime];
    }
    else
    {
    
    
    }

}
- (void)setAmountTime
{
    _amountTime = passTime;
    
   // double time = _amountTime * 3600;
//    if (passTime > time) {
//        leftTime = 0;
//    } else {
//        leftTime = time - passTime;
//    }
    leftTime=passTime;
    
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(timeFireMethod)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)timeFireMethod
{
    leftTime--;
    //NSLog(@"leftTime : %f",leftTime);
    
    NSString * hour = [self getHour];
    NSString * minute = [self getMinute];
    NSString * second = [self getSecond];
    
    //NSLog(@"hour = %@ minute = %@ second = %@",hour,minute,second);
    
    _hour.text = hour;
    _minute.text = minute;
    _second.text = second;
    
}

- (NSString *)getHour
{
    NSInteger hour = leftTime/3600;
    if (hour > 9) {
        return [NSString stringWithFormat:@"%d",hour];
    } else {
        return [NSString stringWithFormat:@"0%d",hour];
    }
}

- (NSString *)getMinute
{
    NSInteger minute = (NSInteger)leftTime%3600/60;
    if (minute > 9) {
        return [NSString stringWithFormat:@"%d",minute];
    } else {
        return [NSString stringWithFormat:@"0%d",minute];
    }
}

- (NSString *)getSecond
{
    NSInteger second = (NSInteger)leftTime%3600%60;
    if (second > 9) {
        return [NSString stringWithFormat:@"%d",second];
    } else {
        return [NSString stringWithFormat:@"0%d",second];
    }
}

//获取当前时间
- (NSString *)getCurrentDate
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * timeString=[formatter stringFromDate:[NSDate date]];
    
    return timeString;
}


- (double)getStringTimeDiff:(NSString*)timeS timeE:(NSString*)timeE
{
    double timeDiff = 0.0;
    
    NSDateFormatter *formatterS = [[NSDateFormatter alloc] init];
    formatterS.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    [formatterS setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * dateS = [formatterS dateFromString:timeS];
    //NSLog(@"dateS %@",dateS);
    
    NSDateFormatter *formatterE = [[NSDateFormatter alloc] init];
    formatterE.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    [formatterE setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * dateE = [formatterE dateFromString:timeE];
    //NSLog(@"dateE %@",dateE);
    
    timeDiff = [dateS timeIntervalSinceDate:dateE ];
    if (timeDiff<=0)
    {
        return 0;
    }
    return timeDiff;
}

@end
