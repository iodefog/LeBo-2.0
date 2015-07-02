//
//  LeboDB+Message.h
//
//  Created by sam on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeboDB.h"

@class MessageDTO;

@interface LeboDB (Message)

- (BOOL)createTable_Message:(sqlite3*)db;
+ (BOOL)saveMessage:(MessageDTO *)dto;
+ (BOOL)getMessages:(NSMutableArray *)array sessionID:(NSString *)sessionID start:(NSInteger)start count:(NSInteger)count;
+ (BOOL)getMessages:(NSMutableArray *)array sessionID:(NSString *)sessionID after:(NSDate *)afterTime;
+ (NSInteger)getMessageUnreadCount:(NSString *)sessionID after:(NSDate *)afterTime;
+ (NSInteger)getMessageUnreadCounts:(NSArray *)array after:(NSDate *)afterTime;
+ (NSInteger)getSentMessageReadCount:(NSString *)sessionID after:(NSDate *)afterTime;
+ (BOOL)getSentMessageReadList:(NSMutableArray *)array sessionID:(NSString *)sessionID after:(NSDate *)afterTime;

- (BOOL)clearMessages:(NSString *)sessionID;
- (BOOL)getMessages:(NSMutableArray *)array sessionID:(NSString *)sessionID start:(NSInteger)start count:(NSInteger)count;
- (BOOL)updateMessageStatus:(NSInteger)status messageID:(NSString *)messageID;
- (BOOL)updateMessageStatus:(NSInteger)status sessionID:(NSString *)sessionID;

- (BOOL)markAllMessageRead;
- (BOOL)deleteAllMessage;

@end
