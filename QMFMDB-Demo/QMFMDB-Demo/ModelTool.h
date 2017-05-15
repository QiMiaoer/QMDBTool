//
//  ModelTool.h
//  QMFMDB-Demo
//
//  Created by zyx on 17/5/15.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMFMDBManager.h"
#import "Person.h"

@interface ModelTool : NSObject

+ (BOOL)insertToTable:(NSString *)tableName person:(Person *)person;

@end
