//
//  LHRequestMissonManger.h
//  ManzuoDemo
//
//  Created by qianfeng on 15-4-14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LHRequest;
@interface LHRequestMissonManger : NSObject

@property (nonatomic) NSUInteger maxCurrent;

+ (LHRequestMissonManger*)manager;

- (void)addGETMissionWithURL:(NSString*)url success:(void(^)(LHRequest* request,NSData* data))success failed:(void(^)(LHRequest* request))failed;

- (void)removeRequest:(LHRequest*)request;

@end
