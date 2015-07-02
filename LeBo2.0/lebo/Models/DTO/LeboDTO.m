//
//  LeboDTO.m
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LeboDTO.h"

@implementation LeboDTO

@synthesize LeboID;
@synthesize Content;
@synthesize AuthorID;
@synthesize AuthorDisplayName;
@synthesize AuthorKey;
@synthesize AuthorPhotoID;
@synthesize AuthorPhotoURL;
@synthesize SubmitTime;
@synthesize PhotoID;
@synthesize PhotoURL;
@synthesize MovieID;
@synthesize MovieURL;
@synthesize LoveCount;
@synthesize Love;
@synthesize CommentCount;
@synthesize Comment;
@synthesize Relay;
@synthesize RelayCount;
@synthesize PlayCount;
@synthesize BroadcastDisplayName;
@synthesize expandOffset;
@synthesize LoveUserAttachments;
@synthesize isRecommend;
@synthesize BroadcastAuthor;

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
 
 LeboID = [[NSString alloc] init];
 Content = [[NSString alloc] init];
 AuthorID = [[NSString alloc] init];
 AuthorKey = [[NSString alloc] init];
 AuthorPhotoID = [[NSString alloc] init];
 PhotoID = [[NSString alloc] init];
 Age = [[NSString alloc] init];
 AuthorDisplayName = [[NSString alloc] init];
 
 }
 */
- (BOOL)parse2:(NSDictionary *)result
{
    BOOL tf = YES;
    LeboID = [[self getStrValue:[result objectForKey:@"leboID"]] copy];
    Content = [[self getStrValue:[result objectForKey:@"content"]] copy];
    AuthorID = [[self getStrValue:[result objectForKey:@"authorID"]] copy];
    AuthorKey = [[self getStrValue:[result objectForKey:@"authorKey"]] copy];
    AuthorPhotoID = [[self getStrValue:[result objectForKey:@"authorPhotoID"]] copy];
    AuthorPhotoURL = [[self getStrValue:[result objectForKey:@"authorPhotoUrl"]] copy];
    AuthorDisplayName = [[self getStrValue:[result objectForKey:@"authorDisplayName"]] copy];
    PhotoID = [[self getStrValue:[result objectForKey:@"photoID"]] copy];
    PhotoURL = [[self getStrValue:[result objectForKey:@"photoUrl"]] copy];
    MovieID = [[self getStrValue:[result objectForKey:@"movieID"]] copy];
    MovieURL = [[self getStrValue:[result objectForKey:@"movieUrl"]] copy];
    if (MovieID == nil) {
        MovieID = [[NSString alloc] init];
    }
    LoveCount = [self getIntValue:[result objectForKey:@"loveCount"]];
    Love = [self getIntValue:[result objectForKey:@"love"]];
    CommentCount = [self getIntValue:[result objectForKey:@"commentCount"]];
    Relay = [self getIntValue:[result objectForKey:@"relay"]];
    RelayCount = [self getIntValue:[result objectForKey:@"relayCount"]];
    PlayCount = [self getIntValue:[result objectForKey:@"playCount"]];
    BroadcastDisplayName = [[self getStrValue:[result objectForKey:@"broadcastDisplayName"]] copy];
    isRecommend = [self getIntValue:[result objectForKey:@"isRecommend"]];
    BroadcastAuthor = [[self getStrValue:[result objectForKey:@"broadcastAuthor"]] copy];
    //
    NSObject *obj = [result objectForKey:@"submitTime"];
    if ([obj isKindOfClass:[NSNumber class]] == YES) {
        // since 1970
        SubmitTime = [NSDate convertTimeFromNumber2:(NSNumber *)obj];
    } else if ([obj isKindOfClass:[NSString class]] == YES) {
        // 2012-12-21
        SubmitTime = [NSDate convertTime:(NSString *)obj];
    }
    //
    NSArray *commentArray = [result objectForKey:@"comment"];
    if (commentArray != nil) {
        Comment = [[NSArray alloc] initWithArray:commentArray];
    }
    
    //*/
    NSArray *loveUserAttachmentsArray = [result objectForKey:@"loveUserAttachments"];
    if (loveUserAttachmentsArray != nil) {
        LoveUserAttachments = [[NSArray alloc] initWithArray:loveUserAttachmentsArray];
    }
    //*/
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
    [dict setObject:[self getStrValue:LeboID] forKey:@"leboID"];
    [dict setObject:[self getStrValue:Content] forKey:@"content"];
    [dict setObject:[self getStrValue:AuthorID] forKey:@"authorID"];
    [dict setObject:[self getStrValue:AuthorKey] forKey:@"authorKey"];
    [dict setObject:[self getStrValue:AuthorPhotoID] forKey:@"authorPhotoID"];
    [dict setObject:[self getStrValue:AuthorPhotoURL] forKey:@"authorPhotoUrl"];
    [dict setObject:[NSDate getFormatTime:SubmitTime] forKey:@"submitTime"];
    [dict setObject:[self getStrValue:PhotoID] forKey:@"photoID"];
    [dict setObject:[self getStrValue:PhotoURL] forKey:@"photoUrl"];
    [dict setObject:[self getStrValue:MovieID] forKey:@"movieID"];
    [dict setObject:[self getStrValue:MovieURL] forKey:@"photoUrl"];
    [dict setObject:[NSNumber numberWithInt: LoveCount] forKey:@"loveCount"];
    [dict setObject:[NSNumber numberWithInt: Love] forKey:@"love"];
    [dict setObject:[self getStrValue:AuthorDisplayName] forKey:@"authorDisplayName"];
    [dict setObject:[NSNumber numberWithInt: CommentCount] forKey:@"commentCount"];
    [dict setObject:[NSNumber numberWithInt: Relay] forKey:@"relay"];
    [dict setObject:[NSNumber numberWithInt: RelayCount] forKey:@"relayCount"];
    [dict setObject:[NSNumber numberWithInt: PlayCount] forKey:@"playCount"];
    [dict setObject:[self getStrValue:BroadcastDisplayName] forKey:@"broadcastDisplayName"];
    [dict setObject:[NSNumber numberWithInt:isRecommend] forKey:@"isRecommend"];
    [dict setObject:[self getStrValue:BroadcastAuthor] forKey:@"broadcastAuthor"];
    if (Comment != nil) {
        [dict setObject:Comment forKey:@"attachments"];
    }
    //*/
    if (LoveUserAttachments != nil) {
        [dict setObject:LoveUserAttachments forKey:@"loveUserAttachments"];
    }
    //*/
    //
    return dict;
}

- (NSString *)toParam
{
    NSMutableString *param = [NSMutableString string];
    [param appendFormat:@"&user=%@", [AuthorID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [param appendFormat:@"&content=%@", [Content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [param appendFormat:@"&movieID=%@", MovieID];
    return param;
}

@end
