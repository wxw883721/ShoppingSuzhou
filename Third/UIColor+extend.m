/*******************************************
 文件名称	:	UIColor+extend.m
 文件描述	:	UIColor类别，十六进制
 备	注	:	
 作	者	:	lifuzhen
 时	间	:	20120710
 版	权	:	易杰数码科技
 *******************************************/
#import "UIColor+extend.h"

@implementation UIColor(extend)

+ (UIColor *)hexChangeFloat:(NSString *) hexColor {
	unsigned int redInt_, greenInt_, blueInt_;
	NSRange rangeNSRange_;
	rangeNSRange_.length = 2;  // 范围长度为2
	
	// 取红色的值
	rangeNSRange_.location = 0; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]] 
	 scanHexInt:&redInt_];
	
	// 取绿色的值
	rangeNSRange_.location = 2; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]] 
	 scanHexInt:&greenInt_];
	
	// 取蓝色的值
	rangeNSRange_.location = 4; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]] 
	 scanHexInt:&blueInt_];	
	
	return [UIColor colorWithRed:(float)(redInt_/255.0f) 
						   green:(float)(greenInt_/255.0f) 
							blue:(float)(blueInt_/255.0f) 
						   alpha:1.0f];
}

@end