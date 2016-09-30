//
//  OpeartorSqlite.m
//  LazyNotes
//
//  Created by yaosixu on 2016/9/29.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

#import "OpeartorSqlite.h"

@implementation OpeartorSqlite {
    ///数据库指针
    sqlite3 *db;
    ///表是否存在
    BOOL tabelExits;
}

+(instancetype)shared {
    static OpeartorSqlite *opSqlite = nil;
    
    if (!opSqlite) {
        opSqlite = [[self alloc] initPrivate];
    }
    
    return opSqlite;
}

-(instancetype)initPrivate {
    if (self = [super init]){
        tabelExits = NO;
        [self createTabel];
    }
    return self;
}

-(instancetype)init {
    return [OpeartorSqlite shared];
}

///数据库存放笔记创建时间和笔记所存放文件的路径，笔记存放的文件名为笔记创建的时间.其中创建时间为主键 tiems messagePath

///插入
-(void)insertDataToSqlite:(NSString *)times messagePath:(NSString *)path {
    [self openDb];
    sqlite3_stmt *stmt = nil;
    NSString *sql = [NSString stringWithFormat:@"insert into notes values('%@','%@')",times,path];
    
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil);
    if (result == SQLITE_OK ) {
        NSLog(@"%s,插入成功",__FUNCTION__);
    } else {
        NSLog(@"%s,插入失败",__FUNCTION__);
    }
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    [self closeDb];
}

///更新
-(void)upDateForSqlite:(NSString *)times messagePath:(NSString *)path {
    
    [self openDb];
    sqlite3_stmt *stmt = nil;
    NSString *sql = [NSString stringWithFormat:@"update notes set messagePath = %@ where times = %@",path,times];
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil);
    if (result == SQLITE_OK) {
        NSLog(@"%s,更新成功",__FUNCTION__);
    } else {
        NSLog(@"%s,更新失败",__FUNCTION__);
    }
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    [self closeDb];
}

///查询
-(NSArray<NSDictionary *> *)checkDataFromSqlite {
    [self openDb];
    NSMutableArray<NSDictionary *> *mutableArray = [[NSMutableArray alloc] init];
    NSString *sql = @"select * from notes order by times desc";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil);
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            const unsigned char *times = sqlite3_column_text(stmt, 0);
            const unsigned char *messagePath = sqlite3_column_text(stmt, 1);
            dict[TIMES] = [NSString stringWithUTF8String:(const char *)times];
            dict[MESSAGE_PATH] = [NSString stringWithUTF8String:(const char *)messagePath];
            [mutableArray addObject:dict];
        }
    } else {
        NSLog(@"%s,查询失败",__FUNCTION__);
    }
    sqlite3_finalize(stmt);
    [self closeDb];
    NSArray *messageArray = [mutableArray copy];
    return messageArray;
}

///删除
-(void)deleteDateFromSqlite:(NSString *)time {
    [self openDb];
    sqlite3_stmt *stmt = nil;
    NSString *sql = @"delete from notes where times = ?";
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil);
    
    if (result == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [time UTF8String], -1, nil);
        sqlite3_step(stmt);
    } else {
        NSLog(@"%s,删除失败",__FUNCTION__);
    }
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    [self closeDb];
}

///创建表
-(void)createTabel {
    NSString *sql = @"create table if not exists notes (times text primary key, messagePath text not null)";
    [self openDb];
    int result = sqlite3_exec(db, [sql UTF8String], nil, nil, nil);
    
    if (result == SQLITE_OK) {
        NSLog(@"创建成功");
        tabelExits = YES;
    } else {
        NSLog(@"创建失败");
    }
    [self closeDb];
}

///打开数据库
-(sqlite3 *)openDb {
    if (!db) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [path stringByAppendingPathComponent:@"note.sqlite"];
        sqlite3_open([filePath UTF8String], &db);
    }
    return db;
}

///关闭数据库
-(void)closeDb {
    sqlite3_close(db);
    db = nil;
}

@end
