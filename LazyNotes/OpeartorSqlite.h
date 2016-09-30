//
//  OpeartorSqlite.h
//  LazyNotes
//
//  Created by yaosixu on 2016/9/29.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ConstValue.h"

@interface OpeartorSqlite : NSObject

+(instancetype)shared;

///插入
-(void)insertDataToSqlite:(NSString *)times messagePath:(NSString *)path;
///更新
-(void)upDateForSqlite:(NSString *)times messagePath:(NSString *)path;
///查询
-(NSArray<NSDictionary *> *)checkDataFromSqlite;
///删除
-(void)deleteDateFromSqlite:(NSString *)time;

@end
