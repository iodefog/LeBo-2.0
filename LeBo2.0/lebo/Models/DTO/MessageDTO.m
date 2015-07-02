//
//  MessageDTO.m
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MessageDTO.h"


@implementation MessageDTO

@synthesize MessageID;
@synthesize LocalID;
@synthesize Content;
@synthesize AuthorID;
@synthesize ChaterName;
@synthesize SubmitTime;
@synthesize UpdateTime;
@synthesize PhotoID;
@synthesize ToPhotoID;
@synthesize SessionID;
@synthesize Status;
@synthesize isSend;
@synthesize isShowTime;
@synthesize isFirstChater;
@synthesize DisplayName;
@synthesize ChaterDisplayName;

- (id)init
{
    self = [super init];
    if (self) {
//        [self initValues];
    }
    return self;
}

//- (void)initValues
//{
//    /*
//    MessageID = [[NSString alloc] init];
//    LocalID = [[NSString alloc] init];
//    Content = [[NSString alloc] init];
//    AuthorID = [[NSString alloc] init];
//    ChaterName = [[NSString alloc] init];
//    PhotoID = [[NSString alloc] init];
//    ToPhotoID = [[NSString alloc] init];
//    SessionID = [[NSString alloc] init];
//    isFirstChater = [[NSNumber alloc]init];
//     */
//}

- (BOOL)parse2:(NSDictionary *)result
{
    BOOL tf = YES;
    MessageID = [[self getStrValue:[result objectForKey:@"messageID"]] copy];
    LocalID = [[self getStrValue:[result objectForKey:@"localID"]] copy];
    Content = [[self getStrValue:[result objectForKey:@"content"]] copy];
    AuthorID = [[self getStrValue:[result objectForKey:@"who"]] copy];
    ChaterName = [[self getStrValue:[result objectForKey:@"chaterName"]] copy];
    DisplayName = [[self getStrValue:[result objectForKey:@"displayName"]] copy];
    ChaterDisplayName = [[self getStrValue:[result objectForKey:@"chaterDisplayName"]] copy];
    //
    {
        NSObject *obj = [result objectForKey:@"submitTime"];
        if ([obj isKindOfClass:[NSNumber class]] == YES) {
            SubmitTime = [NSDate convertTimeFromNumber:(NSNumber *)obj];
        } else {
            SubmitTime = [NSDate convertTime:(NSString *)obj];
        }
    }
    {
        NSObject *obj = [result objectForKey:@"updateTime"];
        if ([obj isKindOfClass:[NSNumber class]] == YES) {
            UpdateTime = [NSDate convertTimeFromNumber:(NSNumber *)obj];
        } else {
            UpdateTime = [NSDate convertTime:(NSString *)obj];
        }
    }
    //
    PhotoID = [[self getStrValue:[result objectForKey:@"photoID"]] copy];
    ToPhotoID = [[self getStrValue:[result objectForKey:@"toPhotoID"]] copy];
    SessionID = [[self getStrValue:[result objectForKey:@"sessionID"]] copy];
    //
    NSString *s = [result objectForKey:@"status"];
    if ([s isKindOfClass:[NSString class]] == YES && [s isEqualToString:@"sended"] == YES) {
        Status = MessageSent;
    } else {
        Status = MessageRead;
    }
    isFirstChater = [result objectForKey:@"firstMessage"];
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
    [dict setObject:[self getStrValue:MessageID] forKey:@"messageID"];
    [dict setObject:[self getStrValue:LocalID] forKey:@"localID"];
    [dict setObject:[self getStrValue:Content] forKey:@"content"];
    [dict setObject:[self getStrValue:AuthorID] forKey:@"who"];
    [dict setObject:[self getStrValue:ChaterName] forKey:@"chaterName"];
    [dict setObject:[NSDate convertNumberFromTime:SubmitTime] forKey:@"submitTime"];
    [dict setObject:[self getStrValue:PhotoID] forKey:@"photoID"];
    [dict setObject:[self getStrValue:ToPhotoID] forKey:@"toPhotoID"];
    [dict setObject:[self getStrValue:DisplayName] forKey:@"displayName"];
    [dict setObject:[self getStrValue:ChaterDisplayName] forKey:@"chaterDisplayName"];
    if (isFirstChater) {
         [dict setObject:isFirstChater forKey:@"firstMessage"];
    }
    //[dict setObject:[NSNumber numberWithInt:Status] forKey:@"status"];
    //
    return dict;
}

@end
