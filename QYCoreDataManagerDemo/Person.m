//
//  Person.m
//  QYCoreDataManagerDemo
//
//  Created by qianye on 15/8/22.
//  Copyright (c) 2015年 qianye. All rights reserved.
//

#import "Person.h"

@implementation Person

@dynamic name;
@dynamic age;

- (NSString *)description
{
    return [NSString stringWithFormat:@"姓名：%@---------年龄：%@",self.name,self.age];
}

@end
