//
//  LeboDB+Message.m
//
//  Created by sam on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LeboDB+Message.h"
#import "MessageDTO.h"
#import "JSON.h"

@implementation LeboDB (Message)

- (BOOL)createTable_Message:(sqlite3*)db
{
	char *sql = "create table message ( \
	ROWID integer primary key, \
	MessageID text, \
    SessionID text, \
    Info text, \
    SubmitTime timestamp, \
    UpdateTime timestamp, \
    Status integer, \
    reverse1 text, \
    reverse2 text, \
	reverse3 text)";
	BOOL tf = [self createTable:db SQL:sql Table:@"message"];
    return tf;
}

- (BOOL)insertMessage:(MessageDTO *)dto
{
    BOOL isOK = YES;
	sqlite3_stmt *statement;

	static char *sql = "INSERT INTO message (MessageID, SessionID, Info, SubmitTime, UpdateTime, Status, reverse1, reverse2, reverse3) VALUES(?,?,?,?,?,?,?,?,?)";
	int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	if (success != SQLITE_OK) {
		isOK = NO;
	} else {
		int i = 1;
		sqlite3_bind_text(statement, i++, getValue(dto.MessageID), -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(statement, i++, getValue(dto.SessionID), -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(statement, i++, getValue([[dto JSON] JSONRepresentation]), -1, SQLITE_TRANSIENT);
		sqlite3_bind_double(statement, i++, [[NSDate convertNumberFromTime:dto.SubmitTime] doubleValue]);
		sqlite3_bind_double(statement, i++, [[NSDate convertNumberFromTime:dto.UpdateTime] doubleValue]);
        sqlite3_bind_int(statement, i++, dto.Status);
		sqlite3_bind_text(statement, i++, getValue(dto.isSend == YES ? @"1" : @"0"), -1, SQLITE_TRANSIENT);
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

- (BOOL)isExistMessage:(NSString *)messageID
{
    BOOL isOK = NO;
    sqlite3_stmt *statement = nil;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT MessageID FROM message WHERE MessageID=\'%@\'", messageID];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        isOK = NO;
    } else {
		while (sqlite3_step(statement) == SQLITE_ROW) {
            int i = 0;
            char *name = (char *)sqlite3_column_text(statement, i++);
            NSLog(@"isExistMessage %s", name);
            isOK = YES;
            break;
        }
    }
    return isOK;
}

- (BOOL)getMessages:(NSMutableArray *)array sessionID:(NSString *)sessionID start:(NSInteger)start count:(NSInteger)count
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"SELECT Info, Status, reverse1 FROM message WHERE SessionID=\'%@\'", sessionID];
    //[sql appendFormat:@" AND UpdateTime <> 0"];
    [sql appendString:[NSString stringWithFormat:@" ORDER BY SubmitTime DESC LIMIT %d, %d", start, count]];
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
            int n = sqlite3_column_int(statement, i++);
            
            MessageDTO *dto = [[MessageDTO alloc] init];
            [dto parse:dict];
            dto.Status = n;
            [array insertObject:dto atIndex:0];

            name = (char *)sqlite3_column_text(statement, i++);
            if ([formatValue(name) isEqualToString:@"1"] == YES) {
                dto.isSend = YES;
            }
		}
		sqlite3_finalize(statement);
    }
    return isOK;
}

- (BOOL)getMessages:(NSMutableArray *)array sessionID:(NSString *)sessionID after:(NSDate *)afterTime
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"SELECT Info, Status, reverse1 FROM message WHERE SessionID=\'%@\'", sessionID];
    if (afterTime != nil) {
        [sql appendString:[NSString stringWithFormat:@" AND UpdateTime > %f", [[NSDate convertNumberFromTime:afterTime] doubleValue]]];
    }
    [sql appendString:[NSString stringWithFormat:@" ORDER BY SubmitTime ASC"]];
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
            [dict setObject:@"OK" forKey:@"error"];
            int n = sqlite3_column_int(statement, i++);
            
            MessageDTO *dto = [[MessageDTO alloc] init];
            [dto parse:dict];
            dto.Status = n;
            [array addObject:dto];
            
            name = (char *)sqlite3_column_text(statement, i++);
            if ([formatValue(name) isEqualToString:@"1"] == YES) {
                dto.isSend = YES;
            }
		}
		sqlite3_finalize(statement);
    }
    return isOK;
}

- (BOOL)getSentMessageReadList:(NSMutableArray *)array sessionID:(NSString *)sessionID after:(NSDate *)afterTime
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"SELECT Info, Status, reverse1 FROM message WHERE SessionID=\'%@\'", sessionID];
    [sql appendString:[NSString stringWithFormat:@" AND reverse1=\'1\' AND Status=%d", MessageRead]];
    if (afterTime != nil) {
        [sql appendString:[NSString stringWithFormat:@" AND UpdateTime > %f", [[NSDate convertNumberFromTime:afterTime] doubleValue]]];
    }
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
            [dict setObject:@"OK" forKey:@"error"];
            int n = sqlite3_column_int(statement, i++);
            
            MessageDTO *dto = [[MessageDTO alloc] init];
            [dto parse:dict];
            dto.Status = n;
            [array insertObject:dto atIndex:0];
            
            name = (char *)sqlite3_column_text(statement, i++);
            if ([formatValue(name) isEqualToString:@"1"] == YES) {
                dto.isSend = YES;
            }
		}
		sqlite3_finalize(statement);
    }
    return isOK;
}

+ (BOOL)getSentMessageReadList:(NSMutableArray *)array sessionID:(NSString *)sessionID after:(NSDate *)afterTime
{
    return [[LeboDB shareInstance] getSentMessageReadList:array sessionID:sessionID after:afterTime];
}

- (BOOL)updateMessage:(MessageDTO*)dto from:(NSInteger)from
{   
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;

    static char *sql = "UPDATE message SET MessageID=?, Info=?, SubmitTime=?, UpdateTime=?, Status=?, reverse1=? WHERE MessageID=?";
    int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	if (success != SQLITE_OK) {
		isOK = NO;
    } else {
        int i = 1;
        sqlite3_bind_text(statement, i++, getValue(dto.MessageID), -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(statement, i++, getValue([[dto JSON] JSONRepresentation]), -1, SQLITE_TRANSIENT);
		sqlite3_bind_double(statement, i++, [[NSDate convertNumberFromTime:dto.SubmitTime] doubleValue]);
		sqlite3_bind_double(statement, i++, [[NSDate convertNumberFromTime:dto.UpdateTime] doubleValue]);
        sqlite3_bind_int(statement, i++, dto.Status);
		sqlite3_bind_text(statement, i++, getValue(dto.isSend == YES ? @"1" : @"0"), -1, SQLITE_TRANSIENT);
        if (from == 0) {
            sqlite3_bind_text(statement, i++, getValue(dto.MessageID), -1, SQLITE_TRANSIENT);
        } else {
            sqlite3_bind_text(statement, i++, getValue(dto.LocalID), -1, SQLITE_TRANSIENT);
        }

        success = sqlite3_step(statement);
		sqlite3_finalize(statement);
		
		if (success != SQLITE_DONE) {
			isOK = NO;
		}
	}
	return isOK;
}

- (BOOL)updateMessageStatus:(NSInteger)status messageID:(NSString *)messageID
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    static char *sql = "UPDATE message SET Status=? WHERE MessageID=?";
    int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	if (success != SQLITE_OK) {
		isOK = NO;
    } else {
        int i = 1;
        sqlite3_bind_int(statement, i++, status);
		sqlite3_bind_text(statement, i++, getValue(messageID), -1, SQLITE_TRANSIENT);
        
        success = sqlite3_step(statement);
		sqlite3_finalize(statement);
		
		if (success != SQLITE_DONE) {
			isOK = NO;
		}
	}
	return isOK;
}

- (BOOL)updateMessageStatus:(NSInteger)status sessionID:(NSString *)sessionID
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    static char *sql = "UPDATE message SET Status=? WHERE SessionID=? AND reverse1=\'0\'";
    int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	if (success != SQLITE_OK) {
		isOK = NO;
    } else {
        int i = 1;
        sqlite3_bind_int(statement, i++, status);
		sqlite3_bind_text(statement, i++, getValue(sessionID), -1, SQLITE_TRANSIENT);
        
        success = sqlite3_step(statement);
		sqlite3_finalize(statement);
		
		if (success != SQLITE_DONE) {
			isOK = NO;
		}
	}
	return isOK;
}

- (BOOL)clearMessages:(NSString *)sessionID
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"DELETE FROM message WHERE SessionID=%@", sessionID];
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

+ (BOOL)saveMessage:(MessageDTO *)dto
{
    BOOL isOK = YES;
    if ([[LeboDB shareInstance] isExistMessage:dto.MessageID] == YES) {
        isOK = [[LeboDB shareInstance] updateMessage:dto from:0];
    } else if ([[LeboDB shareInstance] isExistMessage:dto.LocalID] == YES) {
        isOK = [[LeboDB shareInstance] updateMessage:dto from:1];
    } else {
        isOK = [[LeboDB shareInstance] insertMessage:dto];
    }
    return isOK;
}

+ (BOOL)getMessages:(NSMutableArray *)array sessionID:(NSString *)sessionID start:(NSInteger)start count:(NSInteger)count
{
    return [[LeboDB shareInstance] getMessages:array sessionID:sessionID start:start count:count];
}

+ (BOOL)getMessages:(NSMutableArray *)array sessionID:(NSString *)sessionID after:(NSDate *)afterTime
{
    return [[LeboDB shareInstance] getMessages:array sessionID:sessionID after:afterTime];
}

- (NSInteger)getMessageUnreadCount:(NSString *)sessionID after:(NSDate *)afterTime
{
    NSInteger count = 0;
    //BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"SELECT Count(*) FROM message WHERE SessionID=\'%@\'", sessionID];
    [sql appendString:[NSString stringWithFormat:@" AND reverse1=\'0\' AND Status=%d", MessageSent]];
    if (afterTime != nil) {
        [sql appendString:[NSString stringWithFormat:@" AND SubmitTime > %f", [[NSDate convertNumberFromTime:afterTime] doubleValue]]];
    }
    //
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        //isOK = NO;
    } else {
		while (sqlite3_step(statement) == SQLITE_ROW) {
            int i = 0;
            int n = sqlite3_column_int(statement, i++);
            count = n;
		}
		sqlite3_finalize(statement);
    }
    return count;
}

- (NSInteger)getMessageUnreadCounts:(NSArray *)array after:(NSDate *)afterTime
{
    NSInteger count = 0;
    //BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"SELECT Count(*) FROM message WHERE ("];
    for (int i=0; i<array.count; i++) {
        NSString *sessionID = [array objectAtIndex:i];
        [sql appendFormat:@" SessionID=\'%@\'", sessionID];
        if (i < array.count-1) {
            [sql appendFormat:@" OR"];
        }
    }
    [sql appendString:[NSString stringWithFormat:@") AND reverse1=\'0\' AND Status=%d", MessageSent]];
    if (afterTime != nil) {
        [sql appendString:[NSString stringWithFormat:@" AND SubmitTime > %f", [[NSDate convertNumberFromTime:afterTime] doubleValue]]];
    }
    //
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        //isOK = NO;
    } else {
		while (sqlite3_step(statement) == SQLITE_ROW) {
            int i = 0;
            int n = sqlite3_column_int(statement, i++);
            count = n;
		}
		sqlite3_finalize(statement);
    }
    return count;
}

+ (NSInteger)getMessageUnreadCount:(NSString *)sessionID after:(NSDate *)afterTime
{
    NSInteger count = [[LeboDB shareInstance] getMessageUnreadCount:sessionID after:afterTime];
    return count;
}

+ (NSInteger)getMessageUnreadCounts:(NSArray *)array after:(NSDate *)afterTime
{
    NSInteger count = [[LeboDB shareInstance] getMessageUnreadCounts:array after:afterTime];
    return count;
}

+ (NSInteger)getSentMessageReadCount:(NSString *)sessionID after:(NSDate *)afterTime
{
    NSInteger count = [[LeboDB shareInstance] getSentMessageReadCount:sessionID after:afterTime];
    return count;
}

- (BOOL)markAllMessageRead
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    static char *sql = "UPDATE message SET Status=? WHERE reverse1=? AND Status=?";
    int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	if (success != SQLITE_OK) {
		isOK = NO;
    } else {
        int i = 1;
        sqlite3_bind_int(statement, i++, MessageIgnore);
        sqlite3_bind_text(statement, i++, "0", -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, i++, MessageSent);
        
        success = sqlite3_step(statement);
		sqlite3_finalize(statement);
		
		if (success != SQLITE_DONE) {
			isOK = NO;
		}
    }
    return isOK;
}

- (BOOL)deleteAllMessage
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    static char *sql = "DELETE FROM message";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
        isOK = NO;
    } else {
        if (sqlite3_step(statement) != SQLITE_DONE) {
            isOK = NO;
        }
        sqlite3_finalize(statement);
    }
    return isOK;
}

- (NSInteger)getSentMessageReadCount:(NSString *)sessionID after:(NSDate *)afterTime
{
    NSInteger count = 0;
    //BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"SELECT Count(*) FROM message WHERE SessionID=\'%@\'", sessionID];
    [sql appendString:[NSString stringWithFormat:@" AND reverse1=\'1\' AND Status=%d", MessageRead]];
    if (afterTime != nil) {
        [sql appendString:[NSString stringWithFormat:@" AND UpdateTime > %f", [[NSDate convertNumberFromTime:afterTime] doubleValue]]];
    }
    //
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        //isOK = NO;
    } else {
		while (sqlite3_step(statement) == SQLITE_ROW) {
            int i = 0;
            int n = sqlite3_column_int(statement, i++);
            count = n;
		}
		sqlite3_finalize(statement);
    }
    return count;
}

@end
