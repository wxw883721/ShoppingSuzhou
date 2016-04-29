//
//  setUpVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/6/18.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface setUpVC : UIViewController 

@property (strong, nonatomic) IBOutlet UIButton *VersionUpdateBtn;

@property (strong, nonatomic) IBOutlet UISwitch *switchBtn;
- (IBAction)switchChange:(id)sender;

@end
