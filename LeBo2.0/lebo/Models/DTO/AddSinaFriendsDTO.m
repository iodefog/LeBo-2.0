//
//  AddSinaFriendsDTO.m
//  LeBo
//
//  Created by Li Hongli on 13-2-17.
//
//

#import "AddSinaFriendsDTO.h"

@implementation AddSinaFriendsDTO

@synthesize sinaID, accountID, name, screen_name, sinaHeaderPhotoPath, currentState, mImageData, isFans, isFriends, description;

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    error = [[dict objectForKey:@"error"] copy];
    NSDictionary *result = [dict objectForKey:@"result"];
    if ([error isEqualToString:@"OK"] == YES && (NSObject *)result != [NSNull null] && result != nil) {
        [self parse:result];
    } else {
        tf = NO;
    }
    return tf;
}
- (BOOL)parse2:(NSDictionary *)result
{
    BOOL tf = YES;
    self.sinaID = [self getStrValue:[result objectForKey:@"idstr"]];
    self.name = [self getStrValue:[result objectForKey:@"name"]];
    self.accountID = [self getStrValue:[result objectForKey:@"accountID"]];
    self.screen_name = [self getStrValue:[result objectForKey:@"screen_name"]] ;
    self.sinaHeaderPhotoPath = [self getStrValue:[result objectForKey:@"avatar_large"]];
    self.description = [self getStrValue:[result objectForKey:@"description"]];
    isFriends = [self getBoolValue:[result objectForKey:@"isFriends"]];
    isFans = [self getBoolValue:[result objectForKey:@"isFans"]];
    return tf;
}

- (NSDictionary *)JSON
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //
    [dict setObject:sinaID forKey:@"id"];
    [dict setObject:name forKey:@"name"];
    [dict setObject:accountID forKey:@"accountID"];
    [dict setObject:screen_name forKey:@"screen_name"];
    [dict setObject:sinaHeaderPhotoPath forKey:@"avatar_large"];
    [dict setObject:[NSNumber numberWithBool:isFriends] forKey:@"isFriends"];
    [dict setObject:[NSNumber numberWithBool:isFans] forKey:@"isFans"];
    
    return dict;
}

@end
