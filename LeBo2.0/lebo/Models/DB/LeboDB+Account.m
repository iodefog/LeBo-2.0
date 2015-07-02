//
//  LeboDB+Account.m
//
//  Created by sam on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LeboDB+Account.h"
#import "AccountDTO.h"
#import "JSON.h"

@implementation LeboDB (Account)

- (BOOL)createTable_Account:(sqlite3*)db
{
	char *sql = "create table account ( \
	ROWID integer primary key, \
	AccountID text, \
    Token text, \
	Info text, \
    reverse1 text, \
    reverse2 text, \
	reverse3 text)";
	BOOL tf = [self createTable:db SQL:sql Table:@"account"];
    return tf;
}

- (BOOL)insertAccount:(AccountDTO *)dto
{
    BOOL isOK = YES;
	sqlite3_stmt *statement;
    
	static char *sql = "INSERT INTO account (AccountID, Token, Info, reverse1, reverse2, reverse3) VALUES(?,?,?,?,?,?)";
	int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	if (success != SQLITE_OK) {
		isOK = NO;
	} else {
		int i = 1;
		sqlite3_bind_text(statement, i++, getValue(dto.AccountID), -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(statement, i++, getValue(dto.Token), -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(statement, i++, getValue([[dto JSON] JSONRepresentation]), -1, SQLITE_TRANSIENT);
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

- (BOOL)selectAccount:(AccountDTO *)dto accountID:(NSString *)acID
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
	
    NSString *sql = [NSString stringWithFormat:@"SELECT Info FROM account WHERE AccountID=\'%@\'",acID];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        isOK = NO;
    } else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		while (sqlite3_step(statement) == SQLITE_ROW) {
            int i = 0;
            char *name = (char *)sqlite3_column_text(statement, i++);
            //
            NSDictionary *result = [formatValue(name) JSONValue];
            if (result != nil) {
                [dict setObject:result forKey:@"result"];
                [dict setObject:@"OK" forKey:@"error"];
            }
            //
			[dto parse:dict];
            break;
		}
		sqlite3_finalize(statement);
    }
    return isOK;
}

- (BOOL)updateAccount:(AccountDTO *)dto
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    static char *sql = "UPDATE account SET Token=?, Info=? WHERE AccountID=?";
    int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	if (success != SQLITE_OK) {
		isOK = NO;
    } else {
        int i = 1;
        sqlite3_bind_text(statement, i++, getValue(dto.Token), -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(statement, i++, getValue([[dto JSON] JSONRepresentation]), -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(statement, i++, getValue(dto.AccountID), -1, SQLITE_TRANSIENT);
        
		if (sqlite3_step(statement) != SQLITE_DONE) {
			isOK = NO;
		}
		sqlite3_finalize(statement);
	}
	return isOK;
}

@end
