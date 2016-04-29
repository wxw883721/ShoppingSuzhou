//
//  WXAFNetwork.h
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXAFNetwork : NSObject

+ (void)getRequestWithUrl:(NSString *)url parameters:(id)parameter resultBlock:(void(^)(BOOL isSuccessed,id responseObject,NSString * errorDescription))result;

+ (void)postRequestWithUrl:(NSString *)url parameters:(id)parameter resultBlock:(void(^)(BOOL isSuccessed,id resultObject,NSString * errorDescription))result;

@end
