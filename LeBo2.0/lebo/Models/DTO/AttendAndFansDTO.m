//
//  AttendAndFansDTO.m
//  lebo
//
//  Created by King on 13-4-1.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "AttendAndFansDTO.h"

@implementation AttendAndFansDTO

@synthesize AccountID;
@synthesize DisplayName;
@synthesize AccountPhotoID;
@synthesize AccountPhotoUrl;
@synthesize Gender;
@synthesize LastLoginTime;
@synthesize is_visible;
@synthesize Sign;
@synthesize Age;
@synthesize Attended;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)parse2:(NSDictionary *)result
{
    BOOL tf = YES;
    AccountID = [[self getStrValue:[result objectForKey:@"accountID"]] copy];
    DisplayName = [[self getStrValue:[result objectForKey:@"displayName"]] copy];
    AccountPhotoID = [[self getStrValue:[result objectForKey:@"accountPhotoID"]] copy];
    AccountPhotoUrl = [[self getStrValue:[result objectForKey:@"accountPhotoUrl"]] copy];
    Gender = [self getIntValue:[result objectForKey:@"gender"]];
    LastLoginTime = [NSDate convertTimeFromNumber:[result objectForKey:@"lastLoginTime"]];
    Sign = [[self getStrValue:[result objectForKey:@"sign"]] copy];
    Age = [self getIntValue:[result objectForKey:@"age"]];
    Attended = [self getIntValue: [result objectForKey: @"attended"]];
    
    
    return tf;
}

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    error = [[dict objectForKey:@"error"] copy];
    NSDictionary *result = [dict objectForKey:@"result"];
    if ([error isEqualToString:@"OK"] == YES && (NSObject *)result != [NSNull null] && result != nil) {
        [self parse2:result];
    } else {
        tf = NO;
    }
    //
    return tf;
}

- (NSDictionary *)JSON
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //
    [dict setObject:AccountID forKey:@"accountID"];
    [dict setObject:DisplayName forKey:@"displayName"];
    [dict setObject:AccountPhotoID forKey:@"accountPhotoID"];
    [dict setObject:AccountPhotoUrl forKey:@"accountPhotoUrl"];
    [dict setObject:[NSNumber numberWithFloat: Gender] forKey:@"gender"];
    [dict setObject:[NSDate getFormatTime:LastLoginTime] forKey:@"lastLoginTime"];
    [dict setObject:is_visible forKey:@"is_visible"];
    [dict setObject:Sign forKey:@"sign"];
    [dict setObject:[NSNumber numberWithFloat: Age] forKey:@"age"];
    [dict setObject:[NSNumber numberWithFloat: Attended] forKey:@"attended"];
    //
    return dict;
}

@end
