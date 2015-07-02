//
//  LeboDB+Session.h
//
//  Created by sam on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeboDB.h"

@class MessageDTO;

@interface LeboDB (Session)

- (BOOL)createTable_Session:(sqlite3*)db;
+ (BOOL)saveSession:(MessageDTO *)dto;
+ (BOOL)getSessions:(NSMutableArray *)array;

- (BOOL)clearSessions;
- (BOOL)getSessions:(NSMutableArray *)array;
- (BOOL)deleteSession:(NSString *)sessionID;

@end
