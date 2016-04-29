//
//  WXAFNetwork.m
//  ShoppingSuzhou
//
//  Created by notbadboy on 15/5/27.
//  Copyright (c) 2015年 SU. All rights reserved.
//

#import "WXAFNetwork.h"
#import "AFNetworking.h"

@implementation WXAFNetwork



+ (void)getRequestWithUrl:(NSString *)url parameters:(id)parameter resultBlock:(void(^)(BOOL isSuccessed,id responseObject,NSString * errorDescription))result
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:url
      parameters:parameter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             result(YES,responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             result(NO,nil,error.localizedDescription);
         }];
}

+ (void)postRequestWithUrl:(NSString *)url parameters:(id)parameter resultBlock:(void(^)(BOOL isSuccessed,id resultObject,NSString * errorDescription))result
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:url
       parameters:parameter
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              result(YES,responseObject,nil);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              result(NO,nil,error.localizedDescription);
          }];
}


@end
