//
//  LeBoDB+Setting.h
//  LeBo
//
//  Created by Qiang Zhuang on 1/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeboDB.h"


@interface LeboDB (Setting)

- (BOOL)createTable_Setting:(sqlite3*)db;

- (BOOL)selectSetting:(NSDictionary *)info accountID:(NSString *)aID;
- (BOOL)insertSetting:(NSDictionary *)info accountID:(NSString *)aID;
- (BOOL)updateSetting:(NSDictionary *)info accountID:(NSString *)aID;


@end
