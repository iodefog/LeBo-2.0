//
//  DBM.m
//  CarRecord
//
//  Created by wu sam on 8/6/10.
//  Copyright 2010 free. All rights reserved.
//

#import "DBM.h"

@implementation DBM

- (BOOL)loadDB:(NSString *)dbName
{
	BOOL isLoad = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:dbName];
    if (find) {
        if (sqlite3_open_v2([dbName UTF8String], &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_FULLMUTEX, NULL) != SQLITE_OK) {            sqlite3_close(database);
            isLoad = NO;
        } else {
            [self checkAddedTables];
			//[self doExtraWork];
            isLoad = YES;
        }
    } else {
        if (sqlite3_open_v2([dbName UTF8String], &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, NULL) == SQLITE_OK) {
			isLoad = [self createTables];
			//[self doExtraWork];
		} else {
			sqlite3_close(database);
			//NSLog(@"Error: open database file.");
			isLoad = NO;
		}        
    }
	return isLoad;
}

- (BOOL)isExistTable:(NSString *)table
{
    BOOL isOK = YES;
	sqlite3_stmt *statement = nil;
	
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@", table];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        isOK = NO;
    } else {
        // do nothing
    }
    return isOK;
}

- (BOOL)createTables
{
    return YES;
}

- (void)doExtraWork
{
    
}

- (void)checkAddedTables
{
    
}

- (BOOL)createTable:(sqlite3*)db SQL:(char *)sql Table:(NSString *)table
{
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK) {
        //NSLog(@"Error: failed to prepare statement:create %@ table", table);
        return NO;
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if ( success != SQLITE_DONE) {
        //NSLog(@"Error: failed to dehydrate:CREATE TABLE %@", table);
        return NO;
    }
    //NSLog(@"Create table %@ successed.", table);
    return YES;
}

- (BOOL)excuteTrigger:(NSString *)trigger
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
	if (sqlite3_prepare_v2(database, [trigger UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        isOK = NO;
    } else {
		if (sqlite3_step(statement) != SQLITE_DONE) {
			isOK = NO;
		}
		sqlite3_finalize(statement);
	}
    return isOK;
}

NSString* formatValue(char *name)
{
    NSString *value = [[NSString alloc] initWithUTF8String:name != nil ? name : ""];
    //NSLog(@"formatValue %@ %@", value, [NSThread callStackSymbols]);
    return value;
}

const char* getValue(NSString *name)
{
    if (name == nil || (NSObject *)name == [NSNull null]) {
        return "";
    } else {
        return [name UTF8String];
    }
}

@end
