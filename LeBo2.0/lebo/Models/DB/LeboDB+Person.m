//
//  LeboDB+Person.m
//  LeBo
//
//  Created by Li Hongli on 13-3-11.
//
//

#import "LeboDB+Person.h"

#import "LeboDTO.h"
#import "JSON.h"

@implementation LeboDB (Person)
- (BOOL)createTable_Person:(sqlite3*)db
{
	char *sql = "create table person ( \
	ROWID integer primary key, \
	LeboID text, \
    Info text, \
    UpdateTime timestamp, \
    reverse1 text, \
    reverse2 text, \
	reverse3 text)";
	BOOL tf = [self createTable:db SQL:sql Table:@"person"];
    return tf;
}

- (BOOL)insertPerson:(LeboDTO *)dto
{
    BOOL isOK = YES;
	sqlite3_stmt *statement;
    
	static char *sql = "INSERT INTO person (LeboID, Info, UpdateTime, reverse1, reverse2, reverse3) VALUES(?,?,?,?,?,?)";
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

- (BOOL)isExistPerson:(NSString *)leboID
{
    BOOL isOK = NO;
    sqlite3_stmt *statement = nil;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT LeboID FROM person WHERE LeboID=\'%@\'", leboID];
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

- (BOOL)getPersons:(NSMutableArray *)array
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"SELECT Info FROM person"];
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

- (BOOL)updatePerson:(LeboDTO*)dto
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    static char *sql = "UPDATE person SET Info=?, UpdateTime=? WHERE LeboID=?";
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

- (BOOL)clearPersons
{
    BOOL isOK = YES;
    sqlite3_stmt *statement = nil;
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"DELETE FROM person"];
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

+ (BOOL)getPersons:(NSMutableArray *)array
{
    return [[LeboDB shareInstance] getPersons:array];
}

+ (BOOL)savePerson:(LeboDTO *)dto
{
    BOOL isOK = YES;
    if ([[LeboDB shareInstance] isExistPerson:dto.LeboID] == YES) {
        isOK = [[LeboDB shareInstance] updatePerson:dto];
    } else {
        isOK = [[LeboDB shareInstance] insertPerson:dto];
    }
    return isOK;
}

+ (BOOL)clearPersons
{
    return [[LeboDB shareInstance] clearPersons];
}

@end
