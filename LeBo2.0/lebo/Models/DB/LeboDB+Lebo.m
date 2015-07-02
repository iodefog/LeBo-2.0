//
//  LeboDB+Lebo.m
//
//  Created by sam on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LeboDB+Lebo.h"
#import "LeboDTO.h"

#import "JSON.h"

@implementation LeboDB (Lebo)

- (BOOL)createTable_Lebo:(sqlite3*)db
{
	char *sql = "create table lebo ( \
	ROWID integer primary key, \
	LeboID text, \
    Info text, \
    UpdateTime timestamp, \
    reverse1 text, \
    reverse2 text, \
	reverse3 text)";
	BOOL tf = [self createTable:db SQL:sql Table:@"lebo"];
    return tf;
}

- (BOOL)insertLebo:(LeboDTO *)dto
{
    BOOL isOK = YES;
	sqlite3_stmt *statement;
    
	static char *sql = "INSERT INTO lebo (LeboID, Info, UpdateTime, reverse1, reverse2, reverse3) VALUES(?,?,?,?,?,?)";
	int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	if (success != SQLITE_OK) {
		isOK = NO;
	} else {
		int i = 1;
		sqlite3_bind_text(statement, i++, getValue(dto.LeboID), -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(statement, i++, getValue([[dto JSON] JSONRepresentation]), -1, SQLITE_TRANSIENT);
		sqlite3_bind_double(statement, i++, [[NSDate convertNumberFromTime:dto.SubmitTime] doubleValue]);
		sqlite3_bind_text(statement, i++, getValue(@""), -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(statement, i++, getValue(@""), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, i++, getValue(@""), -1, SQLITE_TRANSIENT);
        
        success = sqlite3_step(statement);
		sqlite3_finalize(statement);
		
		if (success != SQLITE_DONE) {
			isOK = NO;
		} else {
			//NSLog(@"insert %d\n", id);
		}
    }
    return isOK;
}

- (BOOL)isExistLebo:(NSString *)leboID
{
    BOOL isOK = NO;
    sqlite3_stmt *statement = nil;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT LeboID FROM lebo WHERE LeboID=\'%@\'", leboID];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        isOK = NO;
    } else {
		while (sqlite3_step(statement) == SQLITE_ROW) {
            int i = 0;
            char *name = (char *)sqlite3_column_text(statement, i++);
            NSLog(@"isExistLebo %s", name);
            isOK = YES;
            break;
        }
    }
    return isOK;
}

- (BOOL)getLebos:(NSMutableArray *)array
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"SELECT Info FROM lebo"];
    //    [sql appendString:@" ORDER BY UpdateTime DESC"];
    //
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        isOK = NO;
    } else {
		while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            //
            int i = 0;
            char *name = (char *)sqlite3_column_text(statement, i++);
            //
            NSDictionary *result = [formatValue(name) JSONValue];
            if (result != nil) {
                [dict setObject:result forKey:@"result"];
                [dict setObject:@"OK" forKey:@"error"];
            }
            //
            LeboDTO *dto = [[LeboDTO alloc] init];
            [dto parse:dict];
            [array addObject:dto];
		}
		sqlite3_finalize(statement);
    }
    return isOK;
}

- (BOOL)updateLebo:(LeboDTO*)dto
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    static char *sql = "UPDATE lebo SET Info=?, UpdateTime=? WHERE LeboID=?";
    int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	if (success != SQLITE_OK) {
		isOK = NO;
    } else {
        int i = 1;
		sqlite3_bind_text(statement, i++, getValue([[dto JSON] JSONRepresentation]), -1, SQLITE_TRANSIENT);
		sqlite3_bind_double(statement, i++, [[NSDate convertNumberFromTime:dto.SubmitTime] doubleValue]);
		sqlite3_bind_text(statement, i++, getValue(dto.LeboID), -1, SQLITE_TRANSIENT);
        
        success = sqlite3_step(statement);
		sqlite3_finalize(statement);
		
		if (success != SQLITE_DONE) {
			isOK = NO;
		}
	}
	return isOK;
}

- (BOOL)clearLebos
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"DELETE FROM lebo"];
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

+ (BOOL)getLebos:(NSMutableArray *)array
{
    return [[LeboDB shareInstance] getLebos:array];
}

+ (BOOL)saveLebo:(LeboDTO *)dto
{
    BOOL isOK = YES;
    if ([[LeboDB shareInstance] isExistLebo:dto.LeboID] == YES) {
        isOK = [[LeboDB shareInstance] updateLebo:dto];
    } else {
        isOK = [[LeboDB shareInstance] insertLebo:dto];
    }
    return isOK;
}

+ (BOOL)clearLebos
{
    return [[LeboDB shareInstance] clearLebos];
}

@end
