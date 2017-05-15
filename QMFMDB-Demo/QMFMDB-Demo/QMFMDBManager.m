//
//  QMFMDBManager.m
//  QMFMDB-Demo
//
//  Created by zyx on 17/5/11.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import "QMFMDBManager.h"
#import "FMDB.h"
#import "Person.h"

#ifdef DEBUG
#define DLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define DLog(...)
#endif

#define DBName @"qimiao.db"

static QMFMDBManager *instance;

@implementation QMFMDBManager {
    FMDatabaseQueue *_queue;
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[QMFMDBManager alloc] init];
        }
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
//        NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:DBName];
        NSString *dbPath = [@"/Users/zyx/Desktop" stringByAppendingPathComponent:DBName];
        DLog(@"\n==========\n==========\ndb path is: %@\n==========\n==========\n", dbPath);
        _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

- (BOOL)isExistTable:(NSString *)tableName {
    if (!tableName) { return NO; }
    __block BOOL isExist;
    [_queue inDatabase:^(FMDatabase *db) {
        isExist = [db tableExists:tableName];
    }];
    return isExist;
}

- (BOOL)createTable:(NSString *)tableName fields:(NSDictionary *)fields {
    if (!tableName) { return NO; }
    if ([fields allKeys].count == 0) { return NO; }
    __block BOOL success;
    [_queue inDatabase:^(FMDatabase *db) {
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement", tableName]];
        NSArray *keys = [fields allKeys];
        for (int i = 0; i < keys.count; i++) {
            NSString *key = keys[i];
            [sql appendFormat:@", %@ %@", key, [fields objectForKey:key]];
            if (i == (keys.count - 1)) {
                [sql appendString:@");"];
            }
        }
        DLog(@"\n==========\n==========\ncreate sql is: %@\n==========\n==========\n", sql);
        success = [db executeUpdate:sql];
    }];
    return success;
}

- (BOOL)insertToTable:(NSString *)tableName keyValues:(NSDictionary *)keyValues {
    if (!tableName) { return NO; }
    if ([keyValues allKeys].count == 0) { return NO; }
    __block BOOL success;
    [_queue inDatabase:^(FMDatabase *db) {
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"insert into %@(", tableName]];
        NSArray *keys = [keyValues allKeys];
        NSArray *values = [keyValues allValues];
        for (int i = 0; i < keys.count; i++) {
            [sql appendFormat:@"%@", keys[i]];
            if (i == (keys.count - 1)) {
                [sql appendString:@")"];
            } else {
                [sql appendString:@", "];
            }
        }
        [sql appendString:@" values("];
        for (int i = 0; i < values.count; i++) {
            [sql appendString:@"?"];
            if (i == (values.count - 1)) {
                [sql appendString:@");"];
            } else {
                [sql appendString:@", "];
            }
        }
        DLog(@"\n==========\n==========\ninsert sql is: %@\n==========\n==========\n", sql);
        success = [db executeUpdate:sql withArgumentsInArray:values];
    }];
    return success;
}

- (BOOL)deleteFromTable:(NSString *)tableName where:(NSArray *)where {
    if (!tableName) { return NO; }
    if (where.count == 0 || where.count % 3 != 0) { return NO; }
    __block BOOL success;
    [_queue inDatabase:^(FMDatabase *db) {
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"delete from %@ where ", tableName]];
        for (int i = 0; i < where.count; i+=3) {
            [sql appendFormat:@"%@%@'%@'", where[i], where[i+1], where[i+2]];
            if (i != (where.count - 3)) {
                [sql appendString:@" and "];
            }
        }
        [sql appendString:@";"];
        DLog(@"\n==========\n==========\ndelete sql is: %@\n==========\n==========\n", sql);
        success = [db executeUpdate:sql];
    }];
    return success;
}

- (BOOL)deleteFromTable:(NSString *)tableName {
    if (!tableName) { return NO; }
    __block BOOL success;
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@;", tableName];
        DLog(@"\n==========\n==========\ndelete all sql is: %@\n==========\n==========\n", sql);
        success = [db executeUpdate:sql];
    }];
    return success;
}

- (BOOL)updateToTable:(NSString *)tableName keyValues:(NSDictionary *)keyValues where:(NSArray *)where {
    if (!tableName) { return NO; }
    if ([keyValues allKeys].count == 0) { return NO; }
    __block BOOL success;
    [_queue inDatabase:^(FMDatabase *db) {
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"update %@ set ", tableName]];
        NSArray *keys = [keyValues allKeys];
        for (int i = 0; i < keys.count; i++) {
            [sql appendFormat:@"%@='%@'", keys[i], keyValues[keys[i]]];
            if (i == (keys.count - 1)) {
                [sql appendString:@" "];
            } else {
                [sql appendString:@", "];
            }
        }
        if (where.count > 0 && where.count % 3 == 0) {
            [sql appendString:@"where "];
            for (int i = 0; i < where.count; i+=3) {
                [sql appendFormat:@"%@%@'%@'", where[i], where[i+1], where[i+2]];
                if (i != (where.count - 3)) {
                    [sql appendString:@" and "];
                }
            }
        }
        [sql appendString:@";"];
        DLog(@"\n==========\n==========\nupdate sql is: %@\n==========\n==========\n", sql);
        success = [db executeUpdate:sql];
    }];
    return success;
}

- (NSArray *)queryFromTable:(NSString *)tableName keys:(NSArray *)keys where:(NSArray *)where {
    if (!tableName) { return nil; }
    if (keys.count == 0) { return nil; }
    __block NSMutableArray *result = [NSMutableArray array];
    [_queue inDatabase:^(FMDatabase *db) {
        NSMutableString *sql = [[NSMutableString alloc] initWithString:@"select "];
        for (int i = 0; i < keys.count; i++) {
            [sql appendFormat:@"%@", keys[i]];
            if (i != (keys.count - 1)) {
                [sql appendString:@", "];
            }
        }
        [sql appendFormat:@" from %@", tableName];
        if (where.count > 0 && where.count % 3 ==0) {
            [sql appendString:@" where "];
            for (int i = 0; i < where.count; i+=3) {
                [sql appendFormat:@"%@%@'%@'", where[i], where[i+1], where[i+2]];
                if (i != (where.count - 3)) {
                    [sql appendString:@" and "];
                }
            }
        }
        [sql appendString:@";"];
        DLog(@"\n==========\n==========\nquery sql is: %@\n==========\n==========\n", sql);
        FMResultSet *set = [db executeQuery:sql];
        while (set.next) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (int i = 0; i < keys.count; i++) {
                dic[keys[i]] = [set stringForColumn:keys[i]];
            }
            [result addObject:dic];
        }
    }];
    return result;
}

- (NSArray *)queryFromTable:(NSString *)tableName {
    if (!tableName) { return nil; }
    __block NSMutableArray *result = [NSMutableArray array];
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select * from %@", tableName];
        DLog(@"\n==========\n==========\nquery sql is: %@\n==========\n==========\n", sql);
        FMResultSet *set = [db executeQuery:sql];
//        NSArray *keys = [[set columnNameToIndexMap] allKeys];
        while (set.next) {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            for (int i = 0; i < keys.count; i++) {
//                dic[[set columnNameForIndex:i]] = [set stringForColumnIndex:i];
//            }
//            [result addObject:dic];
            
            Person *person = [Person new];
            person.name = [set stringForColumn:@"name"];
            person.age = [set intForColumn:@"age"];
            person.height = [set doubleForColumn:@"height"];
            NSData *icon = [set dataForColumn:@"icon"];
            person.icon = [UIImage imageWithData:icon];
            
            [result addObject:person];
        }
    }];
    return result;
}

- (BOOL)dropTable:(NSString *)tableName {
    if (!tableName) { return NO; }
    __block BOOL success;
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"drop table if exists %@;", tableName];
        DLog(@"\n==========\n==========\ndrop sql is: %@\n==========\n==========\n", sql);
        success = [db executeUpdate:sql];
    }];
    return success;
}

@end
