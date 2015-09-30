//
//  ViewController.m
//  QYCoreDataManagerDemo
//
//  Created by qianye on 15/8/15.
//  Copyright (c) 2015年 qianye. All rights reserved.
//

#import "ViewController.h"
#import "QYCoreDataManager.h"


#import "Person.h"


@interface ViewController ()

@end

@implementation ViewController
{
    QYCoreDataManager *_coreDataManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _coreDataManager = [QYCoreDataManager shareMyCoreDataManager];
    
    [self insertDataModel];
    [self selectDataModel];
}


// 存储数据模型
- (void)insertDataModel
{
    [_coreDataManager insertDataWithModelName:@"Person" setAttributWithDic:@{@"name":@"小明",@"age":@12}];
    [_coreDataManager insertDataWithModelName:@"Person" setAttributWithDic:@{@"name":@"小胖",@"age":@15}];
}


// 查询数据
- (void)selectDataModel
{
    NSArray * resultArray = [_coreDataManager selectDataWithModelName:@"Person" predicateString:nil sort:nil ascending:NO];
    
    for (Person *person in resultArray) {
        NSLog(@"-------%@",person);
    }
}

// 更新数据
- (void)updateDataModel
{
    if ([_coreDataManager updateDataWithModelName:@"Person" predicateString:@"self.name = '小明'" setAttributWithDic:@{@"name":@"大明"}]) {
        NSLog(@"修改成功");
    }
}

// 删除数据
- (void)deleteDataModel
{
    if ([_coreDataManager updateDataWithModelName:@"Person" predicateString:@"self.name = '小胖'" setAttributWithDic:@{@"name":@"大明"}]) {
        NSLog(@"删除成功");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
