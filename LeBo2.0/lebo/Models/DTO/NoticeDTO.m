//
//  NoticeDto.m
//  LeBo
//
//  Created by King on 13-3-15.
//

#import "NoticeDTO.h"

@implementation NoticeDTO

@synthesize NoticeType;
@synthesize SubmitTime;
@synthesize SourceTopicID;
@synthesize SourcePhotoID;
@synthesize SourcePhotoUrl;
@synthesize SourceMovieID;
@synthesize SourceMovieUrl;
@synthesize Content;
@synthesize CommentID;
@synthesize Author;
@synthesize AuthorDisplayName;
@synthesize AuthorPhotoID;
@synthesize AuthorPhotoUrl;
@synthesize AlreadyRead;
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
    NoticeType = [[self getStrValue:[result objectForKey:@"noticeType"]] copy];
    SourceTopicID = [[self getStrValue:[result objectForKey:@"sourceTopicID"]] copy];
    SourcePhotoID = [[self getStrValue:[result objectForKey:@"sourcePhotoID"]] copy];
    SourcePhotoUrl = [[self getStrValue:[result objectForKey:@"sourcePhotoUrl"]] copy];
    SourceMovieID = [[self getStrValue:[result objectForKey:@"sourceMovieID"]] copy];
    SourceMovieUrl = [[self getStrValue:[result objectForKey:@"sourceMovieUrl"]] copy];
    Content = [[self getStrValue:[result objectForKey:@"content"]] copy];
    CommentID = [[self getStrValue:[result objectForKey:@"commentID"]] copy];
    Author = [[self getStrValue:[result objectForKey:@"author"]] copy];
    AuthorDisplayName = [[self getStrValue:[result objectForKey:@"authorDisplayName"]] copy];
    AuthorPhotoID = [[self getStrValue:[result objectForKey:@"authorPhotoID"]] copy];
    AuthorPhotoUrl = [[self getStrValue:[result objectForKey:@"authorPhotoUrl"]] copy];
    SubmitTime = [NSDate convertTimeFromNumber:[result objectForKey:@"submitTime"]];
    AlreadyRead = [[self getStrValue:[result objectForKey:@"isRead"]] copy];
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
    [dict setObject:NoticeType forKey:@"noticeType"];
    [dict setObject:SubmitTime forKey:@"submitTime"];
    [dict setObject:SourceTopicID forKey:@"sourceTopicID"];
    [dict setObject:SourcePhotoID forKey:@"sourcePhotoID"];
    [dict setObject:SourcePhotoUrl forKey:@"sourcePhotoUrl"];
    [dict setObject:SourceMovieID forKey:@"sourceMovieID"];
    [dict setObject:SourceMovieUrl forKey:@"sourceMovieUrl"];
    [dict setObject:Content forKey:@"comment"];
    [dict setObject:CommentID forKey:@"commentID"];
    [dict setObject:Author forKey:@"author"];
    [dict setObject:AuthorDisplayName forKey:@"authorDisplayName"];
    [dict setObject:AuthorPhotoID forKey:@"authorPhotoID"];
    [dict setObject:AuthorPhotoUrl forKey:@"authorPhotoUrl"];
    [dict setObject:[NSDate getFormatTime:SubmitTime] forKey:@"submitTime"];
    [dict setObject:AlreadyRead forKey:@"isRead"];
    
    return dict;
}

@end
