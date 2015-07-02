//
//  LeboDB+Notice.m
//  LeBo
//
//  Created by Li Hongli on 13-3-16.
//
//

#import "LeboDB+Notice.h"
#import "NoticeDTO.h"
#import "JSON.h"

@implementation LeboDB (Notice)
- (BOOL)createTable_Notice:(sqlite3*)db
{
	char *sql = "create table Notice ( \
	ROWID integer primary key, \
    Info text, \
    LeboID text, \
    reverse1 text, \
    reverse2 text, \
	reverse3 text)";
	BOOL tf = [self createTable:db SQL:sql Table:@"Notice_Table"];
    return tf;
}

- (BOOL)insertNotice:(NoticeDTO *)dto
{
    BOOL isOK = YES;
	sqlite3_stmt *statement;
    
	static char *sql = "INSERT INTO Notice (Info, LeboID, reverse1, reverse2, reverse3) VALUES(?,?,?,?,?)";
	int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	if (success != SQLITE_OK) {
		isOK = NO;
	} else {
		int i = 1;
        sqlite3_bind_text(statement, i++, getValue([[dto JSON] JSONRepresentation]), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, i++, getValue(dto.SourceTopicID), -1, SQLITE_TRANSIENT);
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

- (BOOL)isExistNotice:(NSString *)leboID
{
    BOOL isOK = NO;
    sqlite3_stmt *statement = nil;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT LeboID FROM Notice WHERE LeboID=\'%@\'", leboID];
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

- (BOOL)getNotices:(NSMutableArray *)array
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"SELECT Info FROM Notice"];
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
            NoticeDTO *dto = [[NoticeDTO alloc] init];
            [dto parse2:dict];
            [array addObject:dto];
		}
		sqlite3_finalize(statement);
    }
    return isOK;
}

- (BOOL)updateNotice:(NoticeDTO*)dto
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    static char *sql = "UPDATE Notice SET Info=? WHERE LeboID=? ";
    int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	if (success != SQLITE_OK) {
		isOK = NO;
    } else {
        int i = 1;
		sqlite3_bind_text(statement, i++, getValue([[dto JSON] JSONRepresentation]), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, i++, getValue(dto.SourceTopicID), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, i++, getValue(dto.CommentID), -1, SQLITE_TRANSIENT);
        success = sqlite3_step(statement);
		sqlite3_finalize(statement);
		
		if (success != SQLITE_DONE) {
			isOK = NO;
		}
	}
	return isOK;
}

- (BOOL)clearNotices
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"DELETE FROM Notice"];
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

+ (BOOL)getNotices:(NSMutableArray *)array
{
    return [[LeboDB shareInstance] getNotices:array];
}

+ (BOOL)saveNotice:(NoticeDTO *)dto
{
    BOOL isOK = YES;
    if ([[LeboDB shareInstance] isExistNotice:dto.SourceTopicID] == YES) {
        isOK = [[LeboDB shareInstance] updateNotice:dto];
    } else {
        isOK = [[LeboDB shareInstance] insertNotice:dto];
    }
    return isOK;
}

+ (BOOL)clearNotices
{
    return [[LeboDB shareInstance] clearNotices];
}
@end
