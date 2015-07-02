//
//  AccountHelper.m
//  mcare-core
//
//  Created by sam on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AccountHelper.h"
#import "AccountDTO.h"
#import "FileUtil.h"
#import "DateUtil.h"
#import "LeboDB+Public.h"

NSString * const LoginDidChangeNotification = @"LoginDidChangeNotification";

@implementation AccountHelper

+ (AccountHelper *)shareInstance
{
    static AccountHelper *instance = nil;
    if (instance == nil) {
        instance = [[AccountHelper alloc] init];
    }
    return instance;
}

- (void)setAccount:(AccountDTO *)account
{
    cur_Account = account;
}

- (AccountDTO *)getAccount
{
    if (cur_Account == nil) {
        AccountDTO *dto = [[AccountDTO alloc] init];
        [dto parse:[[NSUserDefaults standardUserDefaults] objectForKey:@"dto"]];
        [AccountHelper setAccount:dto];
        [AccountHelper save];
        cur_Account = dto;
    }
    return cur_Account;
}

+ (void)setAccount:(AccountDTO *)account
{
    [[AccountHelper shareInstance] setAccount:account];
    
    AccountDTO *dto = [[AccountDTO alloc] init];
    [[LeboDB shareInstance] selectAccount:dto accountID:account.AccountID];
    
    if (dto.AccountID == nil || [dto.AccountID isEqualToString:account.AccountID] == NO) {
        [[LeboDB shareInstance] insertAccount:account];
    } else {
        [[LeboDB shareInstance] updateAccount:account];
    }
}

+ (AccountDTO *)getAccount
{
    return [[AccountHelper shareInstance] getAccount];
}

+ (void)clearData:(id)delegate
{
    if ([delegate respondsToSelector:@selector(showProgress:)] == YES) {
        [delegate performSelectorOnMainThread:@selector(showProgress:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    }
    //
    [FileUtil clearDir:[FileUtil getPicPath]];
    [FileUtil clearDir:[FileUtil getAudioPath]];
    [FileUtil clearDir:[FileUtil getInquiryAudioPath]];
    [FileUtil clearDir:[FileUtil getPhotoPath]];
    //
    if ([delegate respondsToSelector:@selector(showProgress:)] == YES) {
        [delegate performSelectorOnMainThread:@selector(showProgress:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:YES];
    }
}

+ (void)save
{
    [AccountHelper setAccount: [AccountHelper getAccount]];
}

+ (void)loginDidChange
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginDidChangeNotification object:nil userInfo:nil];
}

@end
