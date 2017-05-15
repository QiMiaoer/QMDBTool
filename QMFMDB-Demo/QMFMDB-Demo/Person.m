//
//  Person.m
//  QMFMDB-Demo
//
//  Created by zyx on 17/5/15.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age height:(CGFloat)height icon:(UIImage *)icon {
    self = [super init];
    if (self) {
        self.name = name;
        self.age = age;
        self.height = height;
        self.icon = icon;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name=%@   age=%ld   height=%.2f   icon=%@", _name, _age, _height, _icon];
}

@end
