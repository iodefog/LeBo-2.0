//
//  SearchDTO.m
//  lebo
//
//  Created by King on 13-4-19.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "SearchDTO.h"

@implementation SearchDTO

@synthesize AccountID;
@synthesize DisplayName;
@synthesize PhotoID;
@synthesize PhotoUrl;
@synthesize Sign;
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
    PhotoID = [[self getStrValue:[result objectForKey:@"photoID"]] copy];
    PhotoUrl = [[self getStrValue:[result objectForKey:@"photoUrl"]] copy];
    Sign = [[self getStrValue:[result objectForKey:@"sign"]] copy];
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
    [dict setObject:PhotoID forKey:@"photoID"];
    [dict setObject:PhotoUrl forKey:@"photoUrl"];
    [dict setObject:Sign forKey:@"sign"];
    [dict setObject:[NSNumber numberWithFloat: Attended] forKey:@"attended"];
    //
    return dict;
}

@end
