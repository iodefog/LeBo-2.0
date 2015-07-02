//
//  LeboDB+Session.m
//
//  Created by sam on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LeboDB+Session.h"
#import "MessageDTO.h"
#import "JSON.h"

@implementation LeboDB (Session)

- (BOOL)createTable_Session:(sqlite3*)db
{
	char *sql = "create table session ( \
	ROWID integer primary key, \
	SessionID text, \
    Info text, \
    UpdateTime timestamp, \
    reverse1 text, \
    reverse2 text, \
	reverse3 text)";
	BOOL tf = [self createTable:db SQL:sql Table:@"session"];
    return tf;
}

- (BOOL)insertSession:(MessageDTO *)dto
{
    BOOL isOK = YES;
	sqlite3_stmt *statement;
    
	static char *sql = "INSERT INTO session (SessionID, Info, UpdateTime, reverse1, reverse2, reverse3) VALUES(?,?,?,?,?,?)";
	int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	if (success != SQLITE_OK) {
		isOK = NO;
	} else {
		int i = 1;
		sqlite3_bind_text(statement, i++, getValue(dto.SessionID), -1, SQLITE_TRANSIENT);
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

- (BOOL)isExistSession:(NSString *)sessionID
{
    BOOL isOK = NO;
    sqlite3_stmt *statement = nil;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT SessionID FROM session WHERE SessionID=\'%@\'", sessionID];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        isOK = NO;
    } else {
		while (sqlite3_step(statement) == SQLITE_ROW) {
            int i = 0;
            char *name = (char *)sqlite3_column_text(statement, i++);
            NSLog(@"isExistSession %s", name);
            isOK = YES;
            break;
        }
    }
    return isOK;
}

- (BOOL)getSessions:(NSMutableArray *)array
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"SELECT SessionID, Info FROM session"];
    [sql appendString:@" ORDER BY UpdateTime DESC"];
    //
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        isOK = NO;
    } else {
		while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            //
            int i = 0;
            char *name = (char *)sqlite3_column_text(statement, i++);
            NSString *sessionID = formatValue(name);
            name = (char *)sqlite3_column_text(statement, i++);
            //
            NSDictionary *result = [formatValue(name) JSONValue];
            if (result != nil) {
                [dict setObject:result forKey:@"result"];
                [dict setObject:@"OK" forKey:@"error"];
            }
            //
            MessageDTO *dto = [[MessageDTO alloc] init];
            [dto parse:dict];
            dto.SessionID = sessionID;
            [array addObject:dto];
		}
		sqlite3_finalize(statement);
    }
    return isOK;
}

- (BOOL)updateSession:(MessageDTO*)dto
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    static char *sql = "UPDATE session SET Info=?, UpdateTime=? WHERE SessionID=?";
    int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	if (success != SQLITE_OK) {
		isOK = NO;
    } else {
        int i = 1;
		sqlite3_bind_text(statement, i++, getValue([[dto JSON] JSONRepresentation]), -1, SQLITE_TRANSIENT);
		sqlite3_bind_double(statement, i++, [[NSDate convertNumberFromTime:dto.SubmitTime] doubleValue]);
		sqlite3_bind_text(statement, i++, getValue(dto.SessionID), -1, SQLITE_TRANSIENT);
        
        success = sqlite3_step(statement);
		sqlite3_finalize(statement);
		
		if (success != SQLITE_DONE) {
			isOK = NO;
		}
	}
	return isOK;
}

- (BOOL)clearSessions
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"DELETE FROM session"];
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

- (BOOL)deleteSession:(NSString *)sessionID
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"DELETE FROM session"];
    [sql appendFormat:@" WHERE SessionID=\'%@\'", sessionID];
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

+ (BOOL)saveSession:(MessageDTO *)dto
{
    BOOL isOK = YES;
    if ([[LeboDB shareInstance] isExistSession:dto.SessionID] == YES) {
        isOK = [[LeboDB shareInstance] updateSession:dto];
    } else {
        isOK = [[LeboDB shareInstance] insertSession:dto];
    }
    return isOK;
}

+ (BOOL)getSessions:(NSMutableArray *)array
{
    return [[LeboDB shareInstance] getSessions:array];
}

@end
