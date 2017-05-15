//
//  ModelTool.m
//  QMFMDB-Demo
//
//  Created by zyx on 17/5/15.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import "ModelTool.h"

@implementation ModelTool

+ (BOOL)insertToTable:(NSString *)tableName person:(Person *)person {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:person.name forKey:@"name"];
    [dic setObject:[NSNumber numberWithInteger:person.age] forKey:@"age"];
    [dic setObject:[NSNumber numberWithFloat:person.height] forKey:@"height"];
    [dic setObject:UIImageJPEGRepresentation(person.icon, 0.7) forKey:@"icon"];
    BOOL success;
    if (dic) {
        success = [QMDB insertToTable:tableName keyValues:dic];
    }
    return success;
}

@end
