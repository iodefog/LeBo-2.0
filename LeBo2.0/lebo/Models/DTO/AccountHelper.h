//
//  AccountHelper.h
//  mcare-core
//
//  Created by sam on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define LightGray           [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]

#define LightBlue           [UIColor colorWithRed:0/255.0 green:106/255.0 blue:153/255.0 alpha:1]

#define Black               [UIColor colorWithRed:4/255.0 green:52/255.0 blue:81/255.0 alpha:1]

#import <Foundation/Foundation.h>

@class AccountDTO;

extern NSString * const LoginDidChangeNotification;

@interface AccountHelper : NSObject {
    AccountDTO *cur_Account;
}

+ (void)setAccount:(AccountDTO *)account;
+ (AccountDTO *)getAccount;
+ (void)clearData:(id)delegate;

+ (void)save;

+ (void)loginDidChange;

@end
