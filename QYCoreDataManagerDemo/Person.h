//
//  Person.h
//  QYCoreDataManagerDemo
//
//  Created by qianye on 15/9/30.
//  Copyright © 2015年 qianye. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Person : NSManagedObject

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSNumber *age;

@end
