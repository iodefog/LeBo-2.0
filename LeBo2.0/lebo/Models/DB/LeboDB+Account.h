//
//  LeboDB+Account.h
//
//  Created by sam on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeboDB.h"

@class AccountDTO;

@interface LeboDB (Account)

- (BOOL)createTable_Account:(sqlite3*)db;

- (BOOL)selectAccount:(AccountDTO *)dto accountID:(NSString *)acID;
- (BOOL)insertAccount:(AccountDTO *)dto;
- (BOOL)updateAccount:(AccountDTO *)dto;

@end
