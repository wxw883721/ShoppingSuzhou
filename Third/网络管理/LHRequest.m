//
//  LHRequest.m
//  ManzuoDemo
//
//  Created by qianfeng on 15-4-14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "LHRequest.h"
#import "AFNetworking.h"

@implementation LHRequest

- (void)request
{
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:self.url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.success(self,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.failed != nil) {
            self.failed(self);
        }
    }];
}

//POST请求
- (void)requestPost:(id)parameters url:(NSString*)urlstring
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlstring parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.success(self,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.failed != nil) {
            self.failed(self);
        }
    }];
}

@end
