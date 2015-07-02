//
//  NewCountDTO.m
//  lebo
//
//  Created by King on 13-4-1.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "NewCountDTO.h"

@implementation NewCountDTO


@synthesize NewFansCount;
@synthesize NewNoticeCount;

- (id)init
{
    self = [super init];
    if (self) {
        //        [self initValues];
    }
    return self;
}

/*
 - (void)initValues
 {
 NewFansCount = [[NSString alloc] init];
 NewNoticeCount = [[NSString alloc] init];
 }
*/

- (BOOL)parse2:(NSDictionary *)result
{
    BOOL tf = YES;
    NewFansCount = [[self getStrValue:[result objectForKey:@"newFansCount"]] copy];
    NewNoticeCount = [[self getStrValue:[result objectForKey:@"newNoticeCount"]] copy];
    return tf;
}

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    
    error = [[dict objectForKey:@"error"] copy];
    NSDictionary *result = [dict objectForKey:@"result"];
    if ([error isEqualToString:@"OK"] == YES && (NSObject *)result != [NSNull null] && result != nil) {
        [self parse2:result];
    } else {
        tf = NO;
    }
    
    return tf;
}

- (NSDictionary *)JSON
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //
    [dict setObject:NewFansCount forKey:@"newFansCount"];
    [dict setObject:NewNoticeCount forKey:@"newNoticeCount"];
    
    return dict;
}

@end
