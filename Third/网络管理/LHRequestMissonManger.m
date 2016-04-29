//
//  LHRequestMissonManger.m
//  ManzuoDemo
//
//  Created by qianfeng on 15-4-14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "LHRequestMissonManger.h"
#import "LHRequest.h"

@implementation LHRequestMissonManger
{
    NSMutableDictionary* _currentMissionDict;
    NSMutableArray* _waitMissionArray;
}

-(instancetype)init
{
    if (self = [super init]) {
        _currentMissionDict  = [[NSMutableDictionary alloc] init];
        _waitMissionArray = [[NSMutableArray alloc] init];
        self.maxCurrent = 5;
    }
    return self;
}

+ (LHRequestMissonManger*)manager
{
    static LHRequestMissonManger* manager;
    if (manager == nil) {
        manager = [[LHRequestMissonManger alloc] init];
    }
    return manager;
}

#pragma mark- 下载任务管理
- (void)addGETMissionWithURL:(NSString*)url success:(void(^)(LHRequest* request,NSData* data))success failed:(void(^)(LHRequest* request))failed
{
    if (_currentMissionDict[url]) {
        return;
    }
    LHRequest* request = [[LHRequest alloc] init];
    request.url = url;
    request.success = success;
    request.failed = failed;
    if (_currentMissionDict.count < self.maxCurrent) {
        [request request];
        [_currentMissionDict setObject:request forKey:request.url];
    }else{
        [self pushStack:request];
    }
}

- (void)removeRequest:(LHRequest*)request
{
    [_currentMissionDict removeObjectForKey:request.url];
    LHRequest* kRequest = [self popStack];
    if (kRequest == nil) {
        return;
    }else{
        [kRequest request];
        [_currentMissionDict setObject:kRequest forKey:kRequest.url];
    }
}

#pragma mark- 栈操作
- (void)pushStack:(LHRequest*)request
{
    for (NSUInteger i=0; i<_waitMissionArray.count; i++) {
        NSString* url = [_waitMissionArray[i] url];
        if ([url isEqualToString:request.url]) {
            [_waitMissionArray removeObject:_waitMissionArray[i]];
            break;
        }
    }
    [_waitMissionArray addObject:request];
}

- (LHRequest*)popStack
{
    if (_waitMissionArray.count == 0) {
        return nil;
    }else{
        LHRequest* request = _waitMissionArray.lastObject;
        [_waitMissionArray removeLastObject];
        return request;
    }
}



@end
