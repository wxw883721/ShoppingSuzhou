/*******************************************
 文件名称	:	UIColor+extend.h
 文件描述	:	UIColor类别，十六进制
 备	注	:	
 作	者	:	liuleting
 时	间	:	20120710
 版	权	:	易杰数码科技
 *******************************************/

#import <Foundation/Foundation.h>


// iphone/ipad不支持十六进制的颜色表示，对UIColor进行扩展
@interface UIColor(extend)

// 将十六进制颜色的字符串转化为复合iphone/ipad的颜色
// 字符串为"FFFFFF"
+ (UIColor *)hexChangeFloat:(NSString *) hexColor;

@end
