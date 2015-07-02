//
//  CommentDTO.m
//  LeBo
//
//  Created by King on 13-3-13.
//
//

#import "CommentDTO.h"


@implementation CommentDTO

@synthesize CommentID;
@synthesize Content;
@synthesize CommentAuthorID;
@synthesize CommentAuthorDisplayName;
@synthesize CommentAuthorPhotoID;
@synthesize CommentAuthorPhotoUrl;
@synthesize CommentSubmitTime;
@synthesize CommentTo;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)parse2:(NSDictionary *)result {
    BOOL tf = YES;
    CommentID = [[self getStrValue:[result objectForKey:@"commentID"]] copy];
    Content = [[self getStrValue:[result objectForKey:@"content"]] copy];
    CommentAuthorID = [[self getStrValue:[result objectForKey:@"commentAuthorID"]] copy];
    CommentAuthorDisplayName = [[self getStrValue:[result objectForKey:@"commentAuthorDisplayName"]] copy];
    CommentAuthorPhotoID = [[self getStrValue:[result objectForKey:@"commentAuthorPhotoID"]] copy];
    CommentAuthorPhotoUrl = [[self getStrValue:[result objectForKey:@"commentAuthorPhotoUrl"]] copy];
    CommentTo = [[self getStrValue:[result objectForKey:@"commentTo"]] copy];
    NSObject *obj = [result objectForKey:@"commentSubmitTime"];
    CommentSubmitTime = [NSDate convertTimeFromNumber2:(NSNumber *)obj];
    
    return tf;
}

- (BOOL)parse:(NSDictionary *)dict {
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

- (NSDictionary *)JSON {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[self getStrValue:CommentID] forKey:@"commentID"];
    [dict setObject:[self getStrValue:Content] forKey:@"content"];
    [dict setObject:[self getStrValue:CommentAuthorID] forKey:@"commentAuthorID"];
    [dict setObject:[self getStrValue:CommentAuthorDisplayName] forKey:@"commentAuthorDisplayName"];
    [dict setObject:[self getStrValue:CommentAuthorPhotoID] forKey:@"commentAuthorPhotoID"];
    [dict setObject:[self getStrValue:CommentAuthorPhotoUrl] forKey:@"commentAuthorPhotoUrl"];
    [dict setObject:[NSDate getFormatTime:CommentSubmitTime] forKey:@"commentSubmitTime"];
    [dict setObject:[self getStrValue:CommentTo] forKey:@"commentTo"];
    
    return dict;
}

@end
