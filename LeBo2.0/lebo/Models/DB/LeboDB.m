//
//  LeboDB.m
//  TestCall
//
//  Created by Sam on 11-11-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LeboDB+Public.h"
#import "LeboDB+Account.h"

@implementation LeboDB

+ (id)shareInstance
{
    static LeboDB *instance;
    if (instance == nil) {
        instance = [[LeboDB alloc] init];
        [instance doExtraWork];
        
//        NSString *dbfile;
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        dbfile = [documentsDirectory stringByAppendingPathComponent:@"lebo.db"];
//        NSLog(@"loadDB %@", dbfile);
//		[instance loadDB: dbfile];
        
    }
    return instance;
}

- (BOOL)loadDB:(NSString *)dbName
{
    NSString *dbfile;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dbfile = [documentsDirectory stringByAppendingPathComponent:dbName];
    NSLog(@"loadDB %@", dbfile);
    return [super loadDB: dbfile];
}

- (BOOL)createTables
{
    [self createTable_Account:database];
    [self createTable_Lebo:database];
    [self createTable_Session:database];
    [self createTable_Message:database];
    [self createTable_Setting:database];
    [self createTable_Person:database];
    [self createTable_Notice:database];
    return YES;
}

- (BOOL)clearTable:(NSString *)table
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", table];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        isOK = NO;
    } else {
        if (sqlite3_step(statement) != SQLITE_DONE) {
            isOK = NO;
        }
        sqlite3_finalize(statement);
    }
    return isOK;
}

- (void)checkAddedTables
{

}

- (void)createDir:(NSString *)dirPath
{
	NSFileManager *fileManage = [NSFileManager defaultManager];
	BOOL isDir;
	BOOL isExist = [fileManage fileExistsAtPath:dirPath isDirectory:&isDir];
	if (isExist == NO || isDir == NO) {
		NSError *error;
		isDir = [fileManage createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
		NSLog(@"Create dir %@ %@", dirPath, isDir == YES ? @"OK":@"Fail");
	}
}

- (void)doExtraWork
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dirPath1 = [documentsDirectory stringByAppendingPathComponent:@"buttons"];
	[self createDir:dirPath1];
	NSString *dirPath2 = [documentsDirectory stringByAppendingPathComponent:@"backgrounds"];
	[self createDir:dirPath2];
	NSString *dirPath3 = [documentsDirectory stringByAppendingPathComponent:@"sounds"];
	[self createDir:dirPath3];
	NSString *dirPath4 = [documentsDirectory stringByAppendingPathComponent:@"movie"];
	[self createDir:dirPath4];
}

@end
