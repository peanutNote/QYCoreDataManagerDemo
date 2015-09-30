//
//  QYCoreDataManager.h
//  QYCoreDataManager
//
//  Created by qianye on 14-10-31.
//  Copyright (c) 2014年 qianye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#define MODEL_NAME @"QYModel"

// 本地文件存储的路径
#define PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/sqlite.db"]

@interface QYCoreDataManager : NSObject
{
    // 1.数据模型对象
    NSManagedObjectModel *_managedObjectModel;
    
    // 2.创建本地持久文件对象
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    
    // 3.管理数据对象
    NSManagedObjectContext *_managedObjectContext;
}

// 生成单例方法
+ (QYCoreDataManager *)shareMyCoreDataManager;

// 添加数据
- (BOOL)insertDataWithModelName:(NSString *)modelName
             setAttributWithDic:(NSDictionary *)params;

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
                           ascending:(BOOL)ascending;

// 修改数据
- (BOOL)updateDataWithModelName:(NSString *)modelName
                predicateString:(NSString *)predicateString
             setAttributWithDic:(NSDictionary *)params;

// 删除数据
- (BOOL)deleteDataWithModelName:(NSString *)modelName
                predicateString:(NSString *)predicateString;
@end
