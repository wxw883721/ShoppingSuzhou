//
//  PSBCachesManager.m
//  满座网
//
//  Created by 潘松彪 on 15/3/6.
//  Copyright (c) 2015年 PSB. All rights reserved.
//

#import "PSBCachesManager.h"
#import "PSBDataBaseManager.h"

//缓存文件的路径
#define CACHES_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/caches.db"]

#define CACHES_TABLE_NAME @"caches"
#define URL_COLUME @"url"
#define DATA_COLUME @"data"
#define DATE_COLUME @"insertDate"

//缓存的默认有效时长
#define DEFAULT_VALID_TIME 0

@implementation PSBCachesManager
{
    //数据库管理
    PSBDataBaseManager * _dataBaseManager;
}

- (void)dealloc
{
    [_dataBaseManager release];
    [super dealloc];
}

/**类方法创建单例对象*/
+ (PSBCachesManager *)defaultManager
{
    //因为静态变量会保留上一次执行的结果，所以只有第一次调用创建对象，以后调用直接返回manager，即上一次执行的结果，即同一个对象的地址。
    //另外，单例对象不释放。
    static PSBCachesManager * manager = nil;
    if (manager == nil) {
        manager = [[PSBCachesManager alloc] init];
    }
    return manager;
}

//构造方法
- (instancetype)init
{
    
    if (self = [super init]) {
        //实例化数据库管理对象
        _dataBaseManager = [[PSBDataBaseManager alloc] initWithDataBasePath:CACHES_PATH];
        self.validTime = DEFAULT_VALID_TIME;
        [self createTable];
    }
    return self;
}

//创建数据库的表单
- (void)createTable
{
    NSDictionary * colums = @{DATA_COLUME:@"text", DATE_COLUME:@"datetime"};
    [_dataBaseManager createTable:CACHES_TABLE_NAME primaryKey:URL_COLUME primaryType:@"varchar(256)" otherColums:colums];

}

/**写入缓存*/
- (void)insertCacheWithURL:(NSString *)url data:(NSData *)data
{
    [_dataBaseManager insertRecordIntoTable:CACHES_TABLE_NAME withColumsAndValues:@{URL_COLUME:url, DATA_COLUME:data, DATE_COLUME:[NSDate date]}];
}

/**删除缓存*/
- (void)removeCacheWithURL:(NSString *)url
{
    [_dataBaseManager deleteRecordFromTable:CACHES_TABLE_NAME where:@{URL_COLUME:url}];
}

/**判断缓存是否存在，是否过期*/
- (NSData *)dataFromCachesWithURL:(NSString *)url
{
    FMResultSet * set = [_dataBaseManager select:@[DATA_COLUME, DATE_COLUME] fromTable:CACHES_TABLE_NAME where:@{URL_COLUME:url}];
    //判断set中是否存在元素
    if ([set next] == NO)
        return nil;
    
    //如果存在，取出时间
    NSDate * date = [set dateForColumn:DATE_COLUME];
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    if (-timeInterval > self.validTime) {
        //将过时的缓存清除
        [self removeCacheWithURL:url];
        return nil;
    }
    
    //存在且有效
    NSData * data = [set dataForColumn:DATA_COLUME];
    return data;
}


@end










