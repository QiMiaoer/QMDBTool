//
//  ViewController.m
//  QMFMDB-Demo
//
//  Created by zyx on 17/5/11.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import "ViewController.h"
#import "QMFMDBManager.h"
#import "ModelTool.h"

@interface ViewController ()  

@end

@implementation ViewController

- (IBAction)createTable:(id)sender {
    if (![QMDB isExistTable:@"T_Qimiao"]) {
        [QMDB createTable:@"T_Qimiao" fields:@{@"name": DBText, @"age": DBInteger, @"height": DBReal, @"icon": DBBlob}];
    } else {
        NSLog(@"该表已存在");
    }
}

- (IBAction)insert:(id)sender {
    UIImage *image = [UIImage imageNamed:@"头像.jpg"];
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    [QMDB insertToTable:@"T_Qimiao" keyValues:@{@"name": @"小明1", @"age": @19, @"height": @170.3, @"icon": data}];
    [QMDB insertToTable:@"T_Qimiao" keyValues:@{@"name": @"小明2", @"age": @18, @"height": @174.5, @"icon": data}];
    [QMDB insertToTable:@"T_Qimiao" keyValues:@{@"name": @"小明3", @"age": @29, @"height": @173.3, @"icon": data}];
    [QMDB insertToTable:@"T_Qimiao" keyValues:@{@"name": @"小明4", @"age": @25, @"height": @177.6, @"icon": data}];
    [QMDB insertToTable:@"T_Qimiao" keyValues:@{@"name": @"小明5", @"age": @22, @"height": @178.7, @"icon": data}];
    
    // 使用model方式
    Person *per1 = [[Person alloc] initWithName:@"小兰1" age:10 height:150.3 icon:image];
    [ModelTool insertToTable:@"T_qimiao" person:per1];
    Person *per2 = [[Person alloc] initWithName:@"小兰2" age:12 height:155.6 icon:image];
    [ModelTool insertToTable:@"T_qimiao" person:per2];
    Person *per3 = [[Person alloc] initWithName:@"小兰3" age:15 height:159.7 icon:image];
    [ModelTool insertToTable:@"T_qimiao" person:per3];
}

- (IBAction)query:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSArray *arr;
    if (sender.selected) {
        arr = [QMDB queryFromTable:@"T_Qimiao" keys:@[@"name", @"age"] where:@[@"height", @">", @"175"]];
    } else {
        arr = [QMDB queryFromTable:@"T_Qimiao"];
    }
    
    for (id per in arr) {
        if ([per isKindOfClass:[Person class]]) {
            NSLog(@"拿到的是 Person 这个模型的数组，打印如下：");
            NSLog(@"query result is: \n%@", per);
        } else {
            NSLog(@"拿到的是包含字典的数组，打印如下：");
            NSLog(@"query result is: \n%@", per);
        }
    }
}

- (IBAction)update:(id)sender {
    [QMDB updateToTable:@"T_Qimiao" keyValues:@{@"name": @"小红"} where:@[@"age", @">=", @"25"]];
}

- (IBAction)delete:(id)sender {
    [QMDB deleteFromTable:@"T_Qimiao" where:@[@"height", @"<", @"175", @"age", @">", @"20"]];
}

- (IBAction)deleteAll:(id)sender {
    [QMDB deleteFromTable:@"T_Qimiao"];
}

- (IBAction)drop:(id)sender {
    [QMDB dropTable:@"T_Qimiao"];
}


@end
