//
//  TopDTO.m
//  lebo
//
//  Created by King on 13-4-19.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "TopDTO.h"

@implementation TopDTO

@synthesize AccountID;
@synthesize DisplayName;
@synthesize PhotoID;
@synthesize PhotoUrl;
@synthesize Sign;
@synthesize Attended;
@synthesize FansCount;
@synthesize TotalLoveCount;
@synthesize TotalPlayCount;

-(id)init
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
    Attended = [self getIntValue:[result objectForKey:@"attended"]];
    FansCount = [self getIntValue:[result objectForKey:@"fansCount"]];
    TotalLoveCount = [self getIntValue:[result objectForKey:@"totalLoveCount"]];
    TotalPlayCount = [self getIntValue:[result objectForKey:@"totalPlayCount"]];
    return  tf;
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
    [dict setObject:AccountID forKey:@"accountID"];
    [dict setObject:DisplayName forKey:@"displayName"];
    [dict setObject:PhotoID forKey:@"photoID"];
    [dict setObject:PhotoUrl forKey:@"photoUrl"];
    [dict setObject:Sign forKey:@"sign"];
    [dict setObject:[NSNumber numberWithInt:Attended] forKey:@"attended"];
    [dict setObject:[NSNumber numberWithInt:FansCount] forKey:@"fansCount"];
    [dict setObject:[NSNumber numberWithInt:TotalLoveCount] forKey:@"totalLoveCount"];
    [dict setObject:[NSNumber numberWithInt:TotalPlayCount] forKey:@"totalPlayCount"];
    return dict;
}

@end
