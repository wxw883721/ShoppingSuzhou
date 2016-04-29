//
//  LHRequest.h
//  ManzuoDemo
//
//  Created by qianfeng on 15-4-14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHRequest : NSObject

@property (nonatomic,strong) NSString* url;
@property (nonatomic,copy) void (^success)(LHRequest*,NSData*);
@property (nonatomic,copy) void (^failed)(LHRequest*);

- (void)request;

- (void)requestPost:(id)parameters url:(NSString*)urlstring;

@end
