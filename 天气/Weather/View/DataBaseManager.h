//
//  DataBaseManager.h
//  数据库
//
//  Created by  wyzc02 on 16/11/17.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseManager : NSObject
@property (nonatomic,strong)NSArray * allCityArray;
@property (nonatomic,strong)NSArray * allzhishuArray;
@property (nonatomic,strong)NSArray * allthreeArray;
@property (nonatomic,strong)NSArray * allshikuangArray;
/**
 *  打开数据库 1
 */
- (void)openDataBase;

/**
 *  关闭数据库 1
 */
- (void)closeDataBase;
/**
 *  创建数据表 1
 */
- (void)createTableViewName:(NSString *)name;

- (void)insertDataToTableName:(NSString *)tableName WithCTName:(NSString *)ctName;
- (void)selectAllCityFromTable:(NSString *)table;

- (void)selectAllShiKuangFromTable:(NSString *)table;

- (void)selectAllThreeFromTable:(NSString *)table;

- (void)selectAllZhiShuFromTable:(NSString *)table;
- (void)deleteTable:(NSString *)tableName;
@end
