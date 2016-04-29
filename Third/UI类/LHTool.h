//
//  LHTool.h
//  DriverAssistant
//
//  Created by qianfeng on 15-4-14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHTool : UIView

- (UILabel*)createLabelWithFrame:(CGRect)frame Font:(UIFont*)font TextColor:(UIColor*)color TextPosin:(NSTextAlignment)posi BackgourndColor:(UIColor*)backColor text:(NSString*)text;

- (UIButton*)createButtonWithFrame:(CGRect)frame image:(UIImage*)image title:(NSString*)title titleColor:(UIColor*)color target:(id)target action:(SEL)action;

- (UIButton*)createButtonWithFrame:(CGRect)frame image:(UIImage*)image title:(NSString*)title titleColor:(UIColor*)color WithBackgroundImage:(UIImage*)backgroudImage target:(id)target action:(SEL)action;

- (UIImageView*)createImageViewWithFrame:(CGRect)frame image:(UIImage*)image;

+ (UILabel*)LabelWithFrame:(CGRect)frame Font:(UIFont*)font TextColor:(UIColor*)color TextPosin:(NSTextAlignment)posi BackgourndColor:(UIColor*)backColor text:(NSString*)text;

+ (UIButton*)ButtonWithFrame:(CGRect)frame image:(UIImage*)image title:(NSString*)title titleColor:(UIColor*)color target:(id)target action:(SEL)action;

+ (UIButton*)ButtonWithFrame:(CGRect)frame image:(UIImage*)image title:(NSString*)title titleColor:(UIColor*)color WithBackgroundImage:(UIImage*)backgroudImage target:(id)target action:(SEL)action;

+ (UIImageView*)ImageViewWithFrame:(CGRect)frame image:(UIImage*)image;

@end
