## QYCoreDataManagerDmeo
* The easy way to use CoreData
* CoreData简化使用

## 如何使用QYCoreDataManager
* 将QYCoreDataManager文件添加到项目中，在需要使用coreData的文件导入头文件`#import "QYCoreDataManager.h"`

## 具体用法
```objc
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
```