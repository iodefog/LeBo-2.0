//
//  AccountDTO.m
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AccountDTO.h"

@implementation AccountDTO

@synthesize AccountID;
@synthesize AccountSN;
@synthesize AttendCount;
@synthesize CommentMode;
@synthesize DisplayName;
@synthesize FansCount;
@synthesize FansMode;
@synthesize HeartCount;
@synthesize LoveMode;
@synthesize PhotoID;
@synthesize PhotoUrl;
@synthesize SessionID;
@synthesize Sign;
@synthesize Token;
@synthesize TopicCount;
@synthesize LoveTopicCount;
@synthesize TotalLoveCount;
@synthesize TotalPlayCount;

@synthesize Age;
@synthesize Attachments;
@synthesize Birthday;
@synthesize Company;
@synthesize Gender;
@synthesize Interest;
@synthesize Job;
@synthesize LastLoginTime;
@synthesize loginType;
@synthesize Password;
@synthesize Personal;
@synthesize Place;
@synthesize RegisterTime;
@synthesize School;
@synthesize StarSign;

@synthesize Realname;
@synthesize Email;
@synthesize Location;
@synthesize AuthorTopicCount;
@synthesize Attended;
@synthesize Blacked;
@synthesize isLogin;
@synthesize user;
@synthesize Name;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
/*
 - (void)initValues
 {
 user = [[NSString alloc] init];
 AccountID = [[NSString alloc] init];
 Age = [[NSString alloc] init];
 Birthday = [[NSString alloc] init];
 StarSign = [[NSString alloc] init];
 Location = [[NSString alloc] init];
 Job = [[NSString alloc] init];
 Company = [[NSString alloc] init];
 School = [[NSString alloc] init];
 Interest = [[NSString alloc] init];
 Place = [[NSString alloc] init];
 Personal = [[NSString alloc] init];
 Sign = [[NSString alloc] init];
 Password = [[NSString alloc] init];
 Token = [[NSString alloc] init];
 Realname = [[NSString alloc] init];
 //
 PhotoID = [[NSString alloc] init];
 Attachments = [[NSArray alloc] init];
 SessionID = [[NSString alloc] init];
 DisplayName = [[NSString alloc] init];
 Name = [[NSString alloc] init];
 loginType = [[NSString alloc] init];
 }
 */

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    error = [[dict objectForKey:@"error"] copy];
    NSDictionary *result = [dict objectForKey:@"result"];
    if ([error isEqualToString:@"OK"] == YES && (NSObject *)result != [NSNull null] && result != nil) {
        AccountID = [[self getStrValue:[result objectForKey:@"accountID"]] copy];
        Password = [[self getStrValue:[result objectForKey:@"password"]] copy];
        Token = [[self getStrValue:[result objectForKey:@"token"]] copy];
        DisplayName = [[self getStrValue:[result objectForKey:@"displayName"]] copy];
        Name = [[self getStrValue:[result objectForKey:@"name"]] copy];
        Realname = [[self getStrValue:[result objectForKey:@"realname"]] copy];
        Birthday = [[self getStrValue:[result objectForKey:@"birthday"]] copy];
        Gender = [self getIntValue:[result objectForKey:@"gender"]];
        Age = [[self getStrValue:[result objectForKey:@"age"]] copy];
        StarSign = [[self getStrValue:[result objectForKey:@"starSign"]] copy];
        Location = [[self getStrValue:[result objectForKey:@"location"]] copy];
        Job = [[self getStrValue:[result objectForKey:@"job"]] copy];
        Company = [[self getStrValue:[result objectForKey:@"company"]] copy];
        School = [[self getStrValue:[result objectForKey:@"school"]] copy];
        Interest = [[self getStrValue:[result objectForKey:@"interest"]] copy];
        Place = [[self getStrValue:[result objectForKey:@"place"]] copy];
        Personal = [[self getStrValue:[result objectForKey:@"personal"]] copy];
        Sign = [[self getStrValue:[result objectForKey:@"sign"]] copy];
        loginType = [[self getStrValue:[result objectForKey:@"loginType"]] copy];
        //
        LastLoginTime = [NSDate convertTimeFromNumber:[result objectForKey:@"lastLoginTime"]];
        PhotoID = [[self getStrValue:[result objectForKey:@"photoID"]] copy];
        PhotoUrl = [[self getStrValue:[result objectForKey:@"photoUrl"]] copy];
        //
        NSArray *array = [result objectForKey:@"attachments"];
        if (array != nil) {
            Attachments = [[NSArray alloc] initWithArray:array];
        }
        AccountSN = [self getIntValue: [result objectForKey: @"accountSN"]];
        TopicCount = [self getIntValue: [result objectForKey: @"topicCount"]];
        LoveTopicCount = [self getIntValue: [result objectForKey: @"loveTopicCount"]];
        AttendCount = [self getIntValue: [result objectForKey: @"attendCount"]];
        FansCount = [self getIntValue: [result objectForKey: @"fansCount"]];
        HeartCount = [self getIntValue: [result objectForKey: @"heartCount"]];
        AuthorTopicCount = [self getIntValue:[result objectForKey:@"authorTopicCount"]];
        TotalLoveCount = [self getStrValue:[result objectForKey:@"totalLoveCount"]];
        TotalPlayCount = [self getStrValue:[result objectForKey:@"totalPlayCount"]];
        
        //
        Attended = [self getIntValue: [result objectForKey: @"attended"]];
        Blacked = [self getIntValue: [result objectForKey: @"blacked"]];
        isLogin = YES;
        SessionID = [[self getStrValue:[result objectForKey:@"sessionID"]] copy];
        user = [[self getStrValue:[result objectForKey:@"user"]] copy];
        
        CommentMode = [[self getStrValue:[result objectForKey:@"commentMode"]] copy];
        LoveMode = [[self getStrValue:[result objectForKey:@"loveMode"]] copy];
        FansMode = [[self getStrValue:[result objectForKey:@"fansMode"]] copy];
    } else {
        tf = NO;
    }
    //
    return tf;
}

- (BOOL)parse2:(NSDictionary *)result
{
    BOOL tf = YES;
    Password = [[self getStrValue:[result objectForKey:@"password"]] copy];
    AccountID = [[self getStrValue:[result objectForKey:@"accountID"]] copy];
    Gender = [self getIntValue:[result objectForKey:@"gender"]];
    Email = [[self getStrValue:[result objectForKey:@"email"]] copy];
    Birthday = [[self getStrValue:[result objectForKey:@"birthday"]] copy];
    return tf;
}

- (NSString *)toParam
{
    NSMutableString *param = [NSMutableString string];
    [param appendFormat:@"&accountID=%@", [AccountID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [param appendFormat:@"&password=%@", [Password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [param appendFormat:@"&gender=%@", [NSNumber numberWithInt: Gender]];
    [param appendFormat:@"&email=%@", [Email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [param appendFormat:@"&birthday=%@", Birthday];
    return param;
}

- (NSDictionary *)JSON
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //
    [dict setObject:user forKey:@"user"];
    [dict setObject:AccountID forKey:@"accountID"];
    [dict setObject:[NSNumber numberWithInteger:AccountSN] forKey:@"accountSN"];
    [dict setObject:Password forKey:@"password"];
    [dict setObject:Token forKey:@"token"];
    [dict setObject:Realname forKey:@"realname"];
    [dict setObject:[NSNumber numberWithInt:Gender] forKey:@"gender"];
    [dict setObject:Age forKey:@"age"];
    [dict setObject:Birthday forKey:@"birthday"];
    [dict setObject:StarSign forKey:@"starSign"];
    [dict setObject:Location forKey:@"location"];
    [dict setObject:Job forKey:@"job"];
    [dict setObject:Company forKey:@"company"];
    [dict setObject:School forKey:@"school"];
    [dict setObject:Interest forKey:@"interest"];
    [dict setObject:Place forKey:@"place"];
    [dict setObject:Personal forKey:@"personal"];
    [dict setObject:Sign forKey:@"sign"];
    [dict setObject:DisplayName forKey:@"displayName"];
    [dict setObject:Name forKey:@"name"];
    [dict setObject:loginType forKey:@"loginType"];
    //
    [dict setObject:[NSDate getFormatTime:LastLoginTime] forKey:@"lastLoginTime"];
    [dict setObject:PhotoID forKey:@"photoID"];
    [dict setObject:PhotoUrl forKey:@"photoUrl"];
    [dict setObject:Attachments forKey:@"attachments"];
    [dict setObject:SessionID forKey:@"sessionID"];    //
    [dict setObject:CommentMode forKey:@"commentMode"];
    [dict setObject:LoveMode forKey:@"loveMode"];
    [dict setObject:FansMode forKey:@"fansMode"];
    [dict setObject:[NSNumber numberWithInt:AttendCount] forKey:@"attendCount"];
    [dict setObject:[NSNumber numberWithInt:FansCount] forKey:@"fansCount"];
    [dict setObject:[NSNumber numberWithInt:HeartCount] forKey:@"heartCount"];
    [dict setObject:[NSNumber numberWithInt:TopicCount] forKey:@"topicCount"];
    [dict setObject:[NSNumber numberWithInt:LoveTopicCount] forKey:@"loveTopicCounttCount"];
    [dict setObject:TotalLoveCount forKey:@"totalLoveCount"];
    [dict setObject:TotalPlayCount forKey:@"totalPlayCount"];
     
    return dict;
}

#pragma mark - Copy

- (id)copyWithZone:(NSZone *)zone {
    AccountDTO *dto = [super copyWithZone: zone];
    dto->AccountID = [AccountID copy];
    dto->AccountSN = AccountSN;
    dto->Password = [Password copy];
    dto->Realname = [Realname copy];
    dto->Gender = Gender;
    dto->Age = [Age copy];
    dto->Birthday = [Birthday copy];
    dto->StarSign = [StarSign copy];
    dto->Location = [Location copy];
    dto->Job = [Job copy];
    dto->Company = [Company copy];
    dto->School = [School copy];
    dto->Interest = [Interest copy];
    dto->Place = [Place copy];
    dto->Personal = [Personal copy];
    dto->Sign = [Sign copy];
    dto->Token = [Token copy];
    dto->LastLoginTime = [LastLoginTime copy];
    dto->RegisterTime = [RegisterTime copy];
    dto->PhotoID = [PhotoID copy];
    dto->PhotoUrl = [PhotoUrl copy];
    dto->Attachments = [Attachments copy];
    dto->AttendCount = AttendCount;
    dto->FansCount = FansCount;
    dto->HeartCount = HeartCount;
    dto->TopicCount = TopicCount;
    dto->LoveTopicCount = LoveTopicCount;
    dto->AuthorTopicCount = AuthorTopicCount;
    dto->Attended = Attended;
    dto->Blacked = Blacked;
    dto->isLogin = isLogin;
    dto->SessionID = SessionID;
    dto->user = user;
    dto->DisplayName = [DisplayName copy];
    dto->Name = [Name copy];
    dto->loginType = [loginType copy];
    dto->CommentMode = [CommentMode copy];
    dto->LoveMode = [LoveMode copy];
    dto->FansMode = [FansMode copy];
    dto->TotalLoveCount = [TotalLoveCount copy];
    dto->TotalPlayCount = [TotalPlayCount copy];
    
    return dto;
}

@end
