//
//  QYCoreDataManager.m
//  QYCoreDataManager
//
//  Created by qianye on 14-10-31.
//  Copyright (c) 2014年 qianye. All rights reserved.
//

#import "QYCoreDataManager.h"

@implementation QYCoreDataManager

static QYCoreDataManager *myCoreDataManager = nil;

- (instancetype)init
{
    if (self = [super init]) {
       // 数据模型对象化
        NSURL *modelURl = [[NSBundle mainBundle] URLForResource:MODEL_NAME withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURl];
        
        //创建本地持久化文件对象
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        
        //设置本地数据保存位子
        NSURL *fileURL = [NSURL fileURLWithPath:PATH];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:fileURL options:nil error:nil];
        
        // 创建管理数据对象
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
    }
    return self;
}

//生成单例方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myCoreDataManager = [super allocWithZone:zone];
    });
    return myCoreDataManager;
}
+ (QYCoreDataManager *)shareMyCoreDataManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myCoreDataManager = [[QYCoreDataManager alloc] init];
    });
    return myCoreDataManager;
}

// 添加数据
- (BOOL)insertDataWithModelName:(NSString *)modelName
             setAttributWithDic:(NSDictionary *)params
{
    // 创建实体对象
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:modelName inManagedObjectContext:_managedObjectContext];
    // 遍历字典，通过字典的key生成实体对象的set方法
    for (NSString *key in params) {
        SEL selector = [self selectorWithKeyName:key];
        if ([entity respondsToSelector:selector]) {
            [entity performSelector:selector withObject:params[key]];
        }
    }
    // 将实体添加到管理对象
    [_managedObjectContext insertObject:entity];
    return [_managedObjectContext save:nil];
}

// 查找数据
/*
 modelName           :实体对象类的名字
 predicateString     :谓词条件
 identifers          :排序字段集合
 ascending           :是否升序
 */
- (NSArray *)selectDataWithModelName:(NSString *)modelName
                     predicateString:(NSString *)predicateString
                                sort:(NSArray *)identifers
                           ascending:(BOOL)ascending
{
    // 创建实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:modelName inManagedObjectContext:_managedObjectContext];
    // 创建查询对象
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 添加查询的类型
    request.entity = entity;
    // 创建查询条件
    if (predicateString != nil && ![predicateString isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        request.predicate = predicate;
    }
    // 创建排序条件
    NSMutableArray *sortArray = [NSMutableArray array];
    for (NSString *identifer in identifers) {
        // 创建排序对象
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:identifer ascending:ascending];
        // 将排序对象添加到数组
        [sortArray addObject:sortDescriptor];
    }
    // 将排序对象数组添加到查询对象中
    request.sortDescriptors = sortArray;
    // 开始查询
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

// 修改数据
- (BOOL)updateDataWithModelName:(NSString *)modelName
                predicateString:(NSString *)predicateString
             setAttributWithDic:(NSDictionary *)params
{
    // 调用查找数据的方法，获取所有需要修改的实体对象
    NSArray *entitys = [self selectDataWithModelName:modelName predicateString:predicateString sort:nil ascending:NO];
    
    // 遍历所有取得的实体对象修改属性
    for (NSEntityDescription *entity in entitys) {
        // 遍历字典，通过字典的key生成实体对象的set方法
        for (NSString *key in params) {
            SEL selector = [self selectorWithKeyName:key];
            if ([entity respondsToSelector:selector]) {
                [entity performSelector:selector withObject:params[key]];
            }
        }
    }
    return [_managedObjectContext save:nil];
}

// 删除数据
- (BOOL)deleteDataWithModelName:(NSString *)modelName
                predicateString:(NSString *)predicateString
{
    // 调用查找数据的方法，获取所有需要修改的实体对象
    NSArray *entitys = [self selectDataWithModelName:modelName predicateString:predicateString sort:nil ascending:NO];
    
    // 遍历所有取得的实体对象并删除
    for (NSEntityDescription *entity in entitys) {
        [_managedObjectContext deleteObject:entity];
    }
    return [_managedObjectContext save:nil];
}


// 通过字符串生成set方法
- (SEL)selectorWithKeyName:(NSString *)key
{
    // 取得key的第一个字符并转化为大写
    NSString *first = [[key substringToIndex:1] uppercaseString];
    // 取到后面的字符
    NSString *end = [key substringFromIndex:1];
    // 拼接得到set方法名
    NSString *selectorString = [NSString stringWithFormat:@"set%@%@:",first,end];
    // 通过set名转换成set方法
    return NSSelectorFromString(selectorString);
}
@end
