//
//  PSBCachesManager.h
//  满座网
//
//  Created by 潘松彪 on 15/3/6.
//  Copyright (c) 2015年 PSB. All rights reserved.
//

#import <Foundation/Foundation.h>

/**缓存管理类，单例对象*/
@interface PSBCachesManager : NSObject

/**有效时长，单位秒*/
@property (nonatomic, assign) NSTimeInterval validTime;

/**类方法创建单例对象*/
+ (PSBCachesManager *)defaultManager;

/**写入缓存*/
- (void)insertCacheWithURL:(NSString *)url data:(NSData *)data;

/**删除缓存*/
- (void)removeCacheWithURL:(NSString *)url;

/**判断缓存是否存在，是否过期*/
- (NSData *)dataFromCachesWithURL:(NSString *)url;

@end









