//
//  LBModelApiViewController.m
//  lebo
//
//  Created by yong wang on 13-3-21.
//  Copyright (c) 2013年 lebo. All rights reserved.
//
#define pageSize @"20"

#import "LBModelApiViewController.h"
#import "SBJson.h"
#import "LBFileClient.h"
#import "SBJsonParser.h"
#import "LBAppDelegate.h"
#import "LBLoginViewController.h"

@implementation LBModelApiViewController
@synthesize model;

- (id)init{
    self = [super init]; 
    if (self) {
    }
    return self;
}

- (BOOL)isLoading {
    return loading;
}

// --- ---
- (NSURLRequestCachePolicy)getPolicy
{
    NSURLRequestCachePolicy getPolicy = NSURLRequestReloadRevalidatingCacheData;
    return getPolicy;
}

- (API_GET_TYPE)modelApi
{
    return 0;
}

- (void)loadMoreData:(NSNumber *)loadHeader
{
    BOOL loadMore = [loadHeader boolValue];
    [self loadData:loadMore ?NSURLRequestReturnCacheDataElseLoad:NSURLRequestReloadIgnoringLocalAndRemoteCacheData more:loadMore];
}

- (NSString *)getLeboID:(BOOL)more
{
    NSString *leboID = @"";
    if (more) {
        if([self.model count] > 0 && [model isKindOfClass:[NSArray class]])
        {
            leboID = [self.model[[self.model count] -1] objectForKey:@"leboID"];
            if (!leboID) {
                leboID = [self.model[[self.model count] -1] objectForKey:@"accountID"];
            }
            if (!leboID) {
                leboID = @"";
            }
        }
    } else {
        leboID = @"";
    }
    
    return leboID;
}

- (NSString *)channelTitles
{
    return @"";
}

- (int)getNoticeRange:(BOOL)more
{
    if(self.model && [model isKindOfClass:[NSArray class]] && more)
    {
        return [model count];
    }
    
    return 0;
}

- (int)getModelCount
{
    if(self.model == nil)
        return 20;
    else
        return [self.model count];
}

//override
- (NSString *)getTopicLeboID
{
    return @"";
}

- (NSString *)getKey
{
    return @"";
}

- (void)loadData:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    API_GET_TYPE api_type = [self modelApi];
    loading = YES;
    
    LBFileClient *client = [LBFileClient sharedInstance];
    switch (api_type) {
        case API_GET_HOME_LIST:
            [client getMyFriendList:[NSArray arrayWithObjects:pageSize, [self getLeboID:more], nil] cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_HOT_VIDEO_LIST:            
            [client getHotList:[NSArray arrayWithObjects:pageSize, [self getLeboID:more], nil] cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_CHANNEL_LIST:
            [client getChannelList:nil cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_CHANNEL_TOPIC_LIST:
            [client getChannelTopicList:[NSArray arrayWithObjects:[self channelTitles], [self getLeboID:more], [NSNumber numberWithInt:20], nil] cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_MY_VIDEO_LIST:
            [client getMyLeboList:[NSArray arrayWithObjects:pageSize, [self getLeboID:more], nil] cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_MY_LOVE_VIDEO_LIST:
            [client getMyLoveList:[NSArray arrayWithObjects:pageSize, [self getLeboID:more], nil] cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_COMMENT_LIST:
            [client getCommentList:[NSArray arrayWithObjects:@"", pageSize, @"", nil] cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_MESSAGE_LIST:
            [client getAllNotices:[self getNoticeRange:more] endPos:[self getNoticeRange:more] + 20 cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_FOllOW_LIST:
            [client getMyAttendList:[NSArray arrayWithObjects:[[AccountHelper getAccount] AccountID], pageSize, [self getLeboID:more], nil] cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_FANS_LIST:
            [client getMyFansList:[NSArray arrayWithObjects:[[AccountHelper getAccount] AccountID], pageSize, [self getLeboID:more], nil] cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_FRIEND_LIST:
            
            break;
        case API_GET_TOPIC_LIST:
            [client getLebo:[self getTopicLeboID] cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_BROADCAST_LIST:
            [client broadcastTopic:[self getTopicLeboID] cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_SEARCH_USER:
            [client searchUser:[NSArray arrayWithObjects:[self getKey], [self getLeboID:more], pageSize, nil] cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_SEARCH_CHANNEL:
            [client searchChannel:[NSArray arrayWithObjects:[self getKey], [self getLeboID:more], pageSize, nil] cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_RECOMMEND_LIST:
            [client getRecommendList:[NSArray arrayWithObjects:[self getLeboID:more], pageSize, nil] cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_TOPFANS_LIST:
            [client getTopFansList:[NSArray arrayWithObjects:[self getLeboID:more], pageSize, nil] cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_TOPLOVE_LIST:
            [client getTopLoveList:[NSArray arrayWithObjects:[self getLeboID:more], pageSize, nil] cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_TOPPLAY_LIST:
            [client getTopPlayList:[NSArray arrayWithObjects:[self getLeboID:more], pageSize, nil] cachePolicy:cachePolicy  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        default:
            loading = NO;
            break;
    }
}

- (void)didFinishLoad:(id)object {

    if (model) {
        // is loading more here
        [model addObjectsFromArray:object];
    } else {
        self.model = object;
    }
}
 
- (BOOL)shouldLoad {
    return !loading;
}

#pragma mark -

- (void)reloadData {
    if ([self shouldLoad] && ![self isLoading]) {
        [self loadData:NSURLRequestReloadIgnoringCacheData more:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.model == nil)
    [self reloadData];
}

#pragma mark -

- (void)setLogout:(AccountDTO *)account
{
    LBFileClient *client = [LBFileClient sharedInstance];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"partAccountDTO"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    BOOL bindDevice = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bindDevice"] boolValue];
    if (bindDevice == YES && deviceToken.length > 20) {
        AccountDTO *account = [AccountHelper getAccount];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"bindDevice"];
#ifdef __OPTIMIZE__
        [client logoutDevice:[NSArray arrayWithObjects:[account Token], [account AccountID], @"Lebo_iPhone", deviceToken, nil] cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
#else
        [client logoutDevice:[NSArray arrayWithObjects:[account Token], [account AccountID], @"Lebo_iPhone_Dev", deviceToken, nil] cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
#endif
    }
}

- (void)requestDidFinishLoad:(NSData*)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", [json_string JSONValue]);
    if(json_string.length > 0)
    {
        NSDictionary *dict = [json_string JSONValue];
        NSString *error = [dict objectForKey:@"error"];
        if ([error isEqualToString:@"NOTLOGIN"]) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"未登录,请登陆"];
        }else if ([error isEqualToString:@"REDUPLICATION"]) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"重复登陆,请重新登陆"];
        }
        
        if ([error isEqualToString:@"NOTLOGIN"] || [error isEqualToString:@"REDUPLICATION"])
        {
            LBAppDelegate *LBdelegate = (LBAppDelegate*)[UIApplication sharedApplication].delegate;
            if ([LBdelegate respondsToSelector:@selector(changedRootVCToLogin)]) {
                [LBdelegate performSelector:@selector(changedRootVCToLogin)];
                if ([error isEqualToString:@"REDUPLICATION"]) {
                    AccountDTO *account = [AccountHelper getAccount];
                    [self setLogout:account];
                }
            }
            return;
        }

        id responseObject = [[json_string JSONValue] objectForKey:@"error"];
        
        if(responseObject)
        {
            if([responseObject isKindOfClass:[NSString class]] && [responseObject isEqualToString:@"OK"])
            {
               id array = [[json_string JSONValue] objectForKey:@"result"];
               if(array){
                    [self didFinishLoad:array];
                }
            }
        }
    }
    else
    {
        [self didFinishLoad:nil];
    }
    
    loading = NO;
    
}

- (void)didFailWithError:(int)type
{
    //override
}

- (void)requestError:(NSError*)error{
    loading = NO;
    [self didFailWithError:error.code];
}

@end
