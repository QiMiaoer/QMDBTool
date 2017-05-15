//
//  Person.h
//  QMFMDB-Demo
//
//  Created by zyx on 17/5/15.
//  Copyright © 2017年 其妙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) UIImage *icon;

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age height:(CGFloat)height icon:(UIImage *)icon;

@end
