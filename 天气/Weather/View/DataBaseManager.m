//
//  DataBaseManager.m
//  数据库
//
//  Created by  wyzc02 on 16/11/17.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "DataBaseManager.h"
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface DataBaseManager ()
@property (nonatomic, strong)NSMutableArray * cityNameArray;
@property (nonatomic,strong)NSMutableArray * shikuangArray;
@property (nonatomic,strong)NSMutableArray * threeArray;
@property (nonatomic,strong)NSMutableArray * zhishuArray;
@property (nonatomic,strong)FMDatabase * database;
@end
@implementation DataBaseManager
-(instancetype)init{
    if (self = [super init]) {
        _cityNameArray = [NSMutableArray array];
        _shikuangArray = [NSMutableArray array];
        _threeArray = [NSMutableArray array];
        _zhishuArray = [NSMutableArray array];
    }
    return self;
}
//获取数据库地址
- (NSString *)dataBasePath{
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"UserDataBase.sqlite"];
    NSLog(@"%@",path);
    return path;
    
}
//打开数据库
- (void)openDataBase{
    NSString * path = [self dataBasePath];
    _database = [FMDatabase databaseWithPath:path];
    BOOL open = [_database open];
    if (open) {
        NSLog(@"数据库打开成功");
    }
}
//关闭数据库
- (void)closeDataBase{
    BOOL close = [_database close];
    if (close) {
        NSLog(@"数据库关闭成功");
    }
}
//创建表
- (void)createTableViewName:(NSString *)name{
    [self openDataBase];
    NSString * createTabelSql = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key autoincrement not null, cityName text)",name];
    BOOL c1 = [_database executeUpdate:createTabelSql];
    if (c1) {
        NSLog(@"创建表成功");
    }
    [self closeDataBase];
}
- (void)insertDataToTableName:(NSString *)tableName WithCTName:(NSString *)ctName{
    [self openDataBase];
    NSString * sql = [NSString stringWithFormat:@"insert into %@(cityName)values('%@')",tableName,ctName];
    BOOL inflag1 = [_database executeUpdate:sql];
    if (inflag1) {
        NSLog(@"插入城市成功");
    }else{
        NSLog(@"error = %@", [_database lastErrorMessage]);
    }
    [self closeDataBase];
}
- (void)selectAllCityFromTable:(NSString *)table{
    [self openDataBase];
    NSString * sql = [NSString stringWithFormat:@"select * from %@",table];
    FMResultSet * result = [_database executeQuery:sql];
    while (result.next) {
        NSString * cityName = [result stringForColumn:@"cityName"];
        [_cityNameArray addObject:cityName];
    }
    
    [self closeDataBase];
}
- (void)selectAllShiKuangFromTable:(NSString *)table{
    [self openDataBase];
    NSString * sql = [NSString stringWithFormat:@"select * from %@",table];
    FMResultSet * result = [_database executeQuery:sql];
    while (result.next) {
        NSString * cityName = [result stringForColumn:@"cityName"];
        [_shikuangArray addObject:cityName];
    }
    
    [self closeDataBase];

}
- (void)selectAllThreeFromTable:(NSString *)table{
    [self openDataBase];
    NSString * sql = [NSString stringWithFormat:@"select * from %@",table];
    FMResultSet * result = [_database executeQuery:sql];
    while (result.next) {
        NSString * cityName = [result stringForColumn:@"cityName"];
        [_threeArray addObject:cityName];
    }
    
    [self closeDataBase];
}
- (void)selectAllZhiShuFromTable:(NSString *)table{
    [self openDataBase];
    NSString * sql = [NSString stringWithFormat:@"select * from %@",table];
    FMResultSet * result = [_database executeQuery:sql];
    while (result.next) {
        NSString * cityName = [result stringForColumn:@"cityName"];
        [_zhishuArray addObject:cityName];
    }
    
    [self closeDataBase];
}
- (void)deleteTable:(NSString *)tableName{
    [self openDataBase];
    NSString * sql = [NSString stringWithFormat:@"drop table %@",tableName];
    BOOL inflag1 = [_database executeUpdate:sql];
    if (inflag1) {
        NSLog(@"删除表成功");
    }else{
        NSLog(@"error = %@", [_database lastErrorMessage]);
    }

    [self closeDataBase];
}

- (NSArray *)allCityArray{
    return _cityNameArray;
}
- (NSArray *)allshikuangArray{
    return _shikuangArray;
}
- (NSArray *)allthreeArray{
    return _threeArray;
}
- (NSArray *)allzhishuArray{
    return _zhishuArray;
}
@end
