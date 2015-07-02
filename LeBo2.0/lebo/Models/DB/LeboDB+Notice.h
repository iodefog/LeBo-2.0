//
//  LeboDB+Notice.h
//  LeBo
//
//  Created by Li Hongli on 13-3-16.
//
//

#import "LeboDB.h"
@class NoticeDTO;
@interface LeboDB (Notice)
- (BOOL)createTable_Notice:(sqlite3*)db;
+ (BOOL)saveNotice:(NoticeDTO *)dto;
+ (BOOL)getNotices:(NSMutableArray *)array;
+ (BOOL)clearNotices;

- (BOOL)clearNotices;
- (BOOL)getNotices:(NSMutableArray *)array;

@end
