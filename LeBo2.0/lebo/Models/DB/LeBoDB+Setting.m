//
//  LeBoDB+Setting.m
//  LeBo
//
//  Created by Qiang Zhuang on 1/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "LeBoDB+Setting.h"
#import "JSON.h"

@implementation LeboDB (Setting)

- (BOOL)createTable_Setting:(sqlite3*)db
{
	char *sql = "create table setting ( \
	ROWID integer primary key, \
	AccountID text, \
    Info text, \
    reverse1 text, \
    reverse2 text, \
	reverse3 text)";
	BOOL tf = [self createTable:db SQL:sql Table:@"setting"];
    return tf;
}

- (BOOL)selectSetting:(NSDictionary *)info accountID:(NSString *)aID
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
	
    NSString *sql = [NSString stringWithFormat:@"SELECT Info FROM setting WHERE AccountID=\'%@\'",aID];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        isOK = NO;
    } else {
        
        if (sqlite3_step(statement) == SQLITE_ROW) {
            int i = 0;
            char *name = (char *)sqlite3_column_text(statement, i++);
            [(NSMutableDictionary *)info setDictionary: [formatValue(name) JSONValue]];
        } else {
            isOK = NO;
        }
		sqlite3_finalize(statement);
    }
    return isOK;
}

- (BOOL)insertSetting:(NSDictionary *)info accountID:(NSString *)aID
{
    BOOL isOK = YES;
	sqlite3_stmt *statement;
    
	static char *sql = "INSERT INTO setting (AccountID, Info, reverse1, reverse2, reverse3) VALUES(?,?,?,?,?)";
	int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	if (success != SQLITE_OK) {
		isOK = NO;
	} else {
		int i = 1;
		sqlite3_bind_text(statement, i++, getValue(aID), -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(statement, i++, getValue([info JSONRepresentation]), -1, SQLITE_TRANSIENT);
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

- (BOOL)updateSetting:(NSDictionary *)info accountID:(NSString *)aID
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    static char *sql = "UPDATE setting SET Info=? WHERE AccountID=?";
    int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	if (success != SQLITE_OK) {
		isOK = NO;
    } else {
        int i = 1;
		sqlite3_bind_text(statement, i++, getValue([info JSONRepresentation]), -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(statement, i++, getValue(aID), -1, SQLITE_TRANSIENT);
        
		if (sqlite3_step(statement) != SQLITE_DONE) {
			isOK = NO;
		}
		sqlite3_finalize(statement);
	}
	return isOK;
}

@end
