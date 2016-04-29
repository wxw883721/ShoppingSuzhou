//
//  feedBackVC.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/21.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface feedBackVC : UIViewController<UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic,strong) UITextView *feedTextView;

@property (nonatomic,retain) UILabel *defaultLabel;

@property (nonatomic,retain) UITextField *nameField;

@end
