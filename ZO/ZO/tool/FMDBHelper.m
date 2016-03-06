//
//  FMDBHelper.m
//  ZO
//
//  Created by JiFeng on 16/3/6.
//  Copyright © 2016年 jeffssss. All rights reserved.
//

#import "FMDBHelper.h"
#import <FMDB/FMDB.h>

NSString * const db_path = @"ZOdb.db";
NSString * const TABLENAME = @"zofont";
NSString * const NAME = @"name";
NSString * const ZOID = @"zoid";
NSString * const TYPE = @"type";
NSString * const PATH = @"path";
NSString * const CREATETIME = @"createtime";

@interface FMDBHelper ()

@property(nonatomic,strong)FMDatabase *db;

@end

@implementation FMDBHelper

+ (FMDBHelper *)sharedManager
{
    static FMDBHelper *ManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        ManagerInstance = [[self alloc] init];
    });
    return ManagerInstance;
}

-(instancetype)init{
    self = [super init];
    if(self){
        //如果表不存在,创建表
        if ([self.db open]) {
            /*
             zofont (
             id integer PRIMARY KEY AUTOINCREMENT,//字的id,自增
             name text,//字名
             path text,//字存放的路径
             type integer,//类型：1，一级汉子，2，二级汉子，4，其他
             createtime text//保存的时间
             )
             */
            NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' INTEGER, '%@' text)",TABLENAME,ZOID,NAME,PATH,TYPE,CREATETIME];
            BOOL res = [self.db executeUpdate:sqlCreateTable];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"success to creating db table");
            }
            [self.db close];
            
        }
    }
    return self;
}
-(FMDatabase*)db{
    if(nil == _db){
        _db =[FMDatabase databaseWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:db_path]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [_db setDateFormat:dateFormatter];
    }
    return _db;
}

-(BOOL)insertData:(ZOFontModel *)model{
    if ([self.db open]) {
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%d', '%@')",
                               TABLENAME, NAME, PATH, TYPE,CREATETIME, model.name, model.path, (int)model.type,[model.createtime stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
        BOOL res = [self.db executeUpdate:insertSql1];
        [self.db close];
        return res;
    }
    return NO;
}

-(NSMutableArray *)query:(NSString *)sql{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    if ([self.db open]) {
        FMResultSet * rs = [self.db executeQuery:sql];
        while ([rs next]) {
            int Id = [rs intForColumn:ZOID];
            NSString * name = [rs stringForColumn:NAME];
            NSString * path = [rs stringForColumn:PATH];
            int type = [rs intForColumn:TYPE];
            NSDate * createtime = [rs dateForColumn:CREATETIME];
            
            ZOFontModel *model = [[ZOFontModel alloc] init];
            model.zoid = Id;
            model.path = path;
            model.type = type;
            model.name = name;
            model.createtime = createtime;
            
            [resultArray addObject:model];
        }
        [self.db close];
    }
    return resultArray;
}

-(BOOL)exec:(NSString *)sql{
    if ([self.db open]) {
        BOOL res = [self.db executeUpdate:sql];
        [self.db close];
        return res;
    }
    return NO;
}
@end
