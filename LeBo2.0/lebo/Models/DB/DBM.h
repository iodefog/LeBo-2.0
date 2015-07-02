//
//  DBM.h
//  CarRecord
//
//  Created by wu sam on 8/6/10.
//  Copyright 2010 free. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface DBM : NSObject {
	sqlite3 *database;
}

- (BOOL)createTables;
- (void)doExtraWork;
- (BOOL)createTable:(sqlite3*)db SQL:(char *)sql Table:(NSString *)table;
- (BOOL)loadDB:(NSString *)dbName;
- (BOOL)excuteTrigger:(NSString *)trigger;
- (void)checkAddedTables;
- (BOOL)isExistTable:(NSString *)table;

NSString* formatValue(char *name);
const char* getValue(NSString *name);

@end
