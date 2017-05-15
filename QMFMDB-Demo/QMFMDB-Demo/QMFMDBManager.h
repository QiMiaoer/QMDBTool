//
//  QMFMDBManager.h
//  QMFMDB-Demo
//
//  Created by zyx on 17/5/11.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DBBlob @"blob"          // 二进制
#define DBInteger @"integer"    // 整形
#define DBReal @"real"          // 浮点型
#define DBText @"text"          // 字符串

#define QMDB [QMFMDBManager shared]

@interface QMFMDBManager : NSObject

/// 单例
+ (instancetype)shared;

/// 根据表名判断该表是否存在
- (BOOL)isExistTable:(NSString *)tableName;

/// 创建表：field格式：@{@"age": DBInteger, @"name": DBText, @"height": DBReal, @"iconData": DBBlob}
- (BOOL)createTable:(NSString *)tableName fields:(NSDictionary *)fields;

/// 插入到表：keyValues格式：@{@"age": 22, @"name": @"小明", @"height": 170.2, @"iconData": data类型}
- (BOOL)insertToTable:(NSString *)tableName keyValues:(NSDictionary *)keyValues;

/// 删除数据：where格式：@[@"age", @">", @"20", @"height", @">=", @"170"]
- (BOOL)deleteFromTable:(NSString *)tableName where:(NSArray *)where;

/// 根据表名删除所有数据
- (BOOL)deleteFromTable:(NSString *)tableName;

/// 更新数据：keyValues格式：@{@"icon": data(某个头像的二进制)}  where格式：@[@"age", @">=", @"20"]    where可以传空数组，表示无条件更新
- (BOOL)updateToTable:(NSString *)tableName keyValues:(NSDictionary *)keyValues where:(NSArray *)where;

/// 查找指定字段：keys格式：@[@"age", @"name"]  where格式：@[@"age", @">=", @"20"]    where可以传空数组，表示无条件查询
- (NSArray *)queryFromTable:(NSString *)tableName keys:(NSArray *)keys where:(NSArray *)where;

/// 根据表名查询所有数据
- (NSArray *)queryFromTable:(NSString *)tableName;

/// 根据表名删除表
- (BOOL)dropTable:(NSString *)tableName;

@end
