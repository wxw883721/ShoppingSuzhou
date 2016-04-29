//
//  orderHeadView.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/28.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void (^orderBtnTagBlock)(NSInteger tag);

@interface orderHeadView : UIView

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentBtn;

//传值
//@property (copy,nonatomic) orderBtnTagBlock orderBtnTagBlock;

@end
