
//
//  FileClient.m
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBFileClient.h"
#import "LBUploadSender.h"

@implementation LBFileClient

#pragma mark -
#pragma mark Client Functions

static LBFileClient* _sharedInstance = nil;

+ (LBFileClient *)sharedInstance
{
    @synchronized(self)
    {
        if (_sharedInstance == nil)
            _sharedInstance = [[LBFileClient alloc] init];
    }
    return _sharedInstance;
}

#pragma mark - Login

/*
// 登录
- (void)login:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    
    LBConfigManager *configManager = [LBConfigManager sharedManager];

    
    NSMutableDictionary *dict = [configManager getPostJsonHeader];
    [dict setObject:@"login" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"user"];
        [params setObject:[array objectAtIndex:1] forKey:@"pass"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 检查邮箱
- (void)checkRegist:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    LBConfigManager *configManager = [LBConfigManager sharedManager];

    NSMutableDictionary *dict = [configManager getPostJsonHeader];
    [dict setObject:@"checkRegist" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"user"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 检查验证码
- (void)checkCaptcha:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    LBConfigManager *configManager = [LBConfigManager sharedManager];

    
    NSMutableDictionary *dict = [configManager getPostJsonHeader];
    [dict setObject:@"checkCaptcha" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"captcha"];
        [params setObject:[array objectAtIndex:1] forKey:@"email"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}
*/

// sina登录   //***************   √   ***************
- (void)loginBySinaToken:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"loginBySinaToken" forKey:@"method"];
    {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"platformType"];
        [params setObject:[array objectAtIndex:1] forKey:@"sinaID"];
        [params setObject:[array objectAtIndex:2] forKey:@"token"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 登出   //***************   √   ***************
- (void)logout:(NSString*)user cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"logout" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //user可以是空
        [dict setObject:params forKey:@"params"];
    }
     
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//
- (void)registerDeviceInfo:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"registerDeviceInfo" forKey:@"method"];
    {        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"accessToken"];
        [params setObject:[array objectAtIndex:1] forKey:@"accountID"];
        [params setObject:[array objectAtIndex:2] forKey:@"deviceType"];
        [params setObject:[array objectAtIndex:3] forKey:@"deviceToken"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 
- (void)logoutDevice:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    //[account Token], [account AccountID], @"Lebo_iPhone", deviceToken,
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    if (array.count==0) {
        return;
    }
    [dict setObject:@"logoutDevice" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"platformType"];
        [params setObject:[array objectAtIndex:1] forKey:@"deviceType"];
        [params setObject:[array objectAtIndex:2] forKey:@"deviceToken"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//***************   √   ***************
- (void)waitLoginBySinaToken:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"waitLoginBySinaToken" forKey:@"method"];
    {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"platformType"];
        [params setObject:[array objectAtIndex:1] forKey:@"sinaID"];
        [params setObject:[array objectAtIndex:2] forKey:@"token"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 移除新浪账号
- (void)debugRemoveSina:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"debugRemoveSina" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"platformType"];
        [params setObject:[array objectAtIndex:1] forKey:@"sinaID"];
        [params setObject:[array objectAtIndex:2] forKey:@"token"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 使用token登录
- (void)loginByToken:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"loginByToken" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"platformType"];
        [params setObject:[[array objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [params setObject:[array objectAtIndex:2] forKey:@"token"];
        [params setObject:[array objectAtIndex:3] forKey:@"session"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 获取用户信息   //***************   √   ***************
- (void)getAccountInfo:(NSString*)accountID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    if (!accountID) {
        return;
    }
    
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getAccountInfo" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:accountID forKey:@"accountID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 获取新浪好友
//- (void)checkSinaUser:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
//{
//    NSMutableDictionary *dict = [Global getPostJsonHeader];
//    
//    [dict setObject:@"checkSinaUser" forKey:@"method"];
//    {
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        [params setObject:array forKey:@"sinaIDs"];
//        [dict setObject:params forKey:@"params"];
//    }
//    
//    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
//                                                                   usePost:NO
//                                                                     param:dict
//                                                               cachePolicy:cholicy
//                                                                  delegate:theDelegate
//                                                          completeSelector:theSelector
//                                                             errorSelector:theSelectorError
//                                                          selectorArgument:nil];
//    [requestSender send];
//}

- (void)checkSinaUser:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getSinaFriends" forKey:@"method"];
    {
        //getSinaFriends
        //start
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"startPos"];
        [params setObject:[array objectAtIndex:1] forKey:@"endPos"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 获取分享文案
- (void)getShareTextAndImage:(NSString*)type cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getShareTextAndImage" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (type)
        [params setObject:type forKey:@"type"];
        //publish share invite
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

#pragma mark ---------

// 关注列表     //***************   √   ***************
- (void)getMyAttendList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getMyAttendList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"acquireUser"];   //发送获取资料请求的用户ID
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:1] integerValue]] forKey:@"pageSize"];
        [params setObject:[array objectAtIndex:2] forKey:@"fromLeboID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 粉丝列表     //***************   √   ***************
- (void)getMyFansList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getMyFansList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"acquireUser"];   // 发送获取资料请求的用户ID
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:1] integerValue]] forKey:@"pageSize"];
        [params setObject:[array objectAtIndex:2] forKey:@"fromLeboID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 红心列表     //***************   √   ***************
- (void)getMyHeartList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getMyHeartList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:0] integerValue]] forKey:@"pageSize"];
        [params setObject:[array objectAtIndex:1] forKey:@"fromLeboID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 黑名单列表
- (void)getMyBlackList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getMyBlackList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:0] integerValue]] forKey:@"pageSize"];
        [params setObject:[array objectAtIndex:1] forKey:@"fromLeboID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 关注   //***************   √   ***************
- (void)follow:(NSString*)attendUser cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"follow" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[attendUser stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"attendUser"]; //被关注的用户ID
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 取消关注     //***************   √   ***************
- (void)unFollow:(NSString*)unAttendUser cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"unFollow" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[unAttendUser stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"unAttendUser"];     //取消关注用户ID
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

/*
// 拉黑
- (void)black:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    LBConfigManager *configManager = [LBConfigManager sharedManager];
    
    NSMutableDictionary *dict = [configManager getPostJsonHeader];
    [dict setObject:@"black" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [params setObject:[array objectAtIndex:1] forKey:@"black"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 取消拉黑
- (void)unBlack:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    LBConfigManager *configManager = [LBConfigManager sharedManager];
    
    NSMutableDictionary *dict = [configManager getPostJsonHeader];
    [dict setObject:@"unBlack" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [params setObject:[array objectAtIndex:1] forKey:@"unBlack"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 将多人取消拉黑
- (void)unBlackList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    LBConfigManager *configManager = [LBConfigManager sharedManager];
    
    NSMutableDictionary *dict = [configManager getPostJsonHeader];
    [dict setObject:@"unBlackList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [params setObject:[array objectAtIndex:1] forKey:@"list"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}
*/
 
// 举报并拉黑    //***************   √   ***************
- (void)reportAccount:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"reportAccount" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [params setObject:[array objectAtIndex:0] forKey:@"reportUser"];
        [params setObject:[array objectAtIndex:1] forKey:@"reportLeboID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

/*
// 密码设置
- (void)passSetting:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    LBConfigManager *configManager = [LBConfigManager sharedManager];
    
    NSMutableDictionary *dict = [configManager getPostJsonHeader];
    [dict setObject:@"passSetting" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [params setObject:[array objectAtIndex:1] forKey:@"oldPass"];
        [params setObject:[array objectAtIndex:2] forKey:@"newPass"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 隐私设置
- (void)secretSetting:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    LBConfigManager *configManager = [LBConfigManager sharedManager];
    
    NSMutableDictionary *dict = [configManager getPostJsonHeader];
    [dict setObject:@"secretSetting" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [params setObject:[array objectAtIndex:1] forKey:@"secretType"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 找回密码
- (void)findPassword:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    LBConfigManager *configManager = [LBConfigManager sharedManager];
    
    NSMutableDictionary *dict = [configManager getPostJsonHeader];
    [dict setObject:@"findPassword" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [params setObject:[array objectAtIndex:1] forKey:@"email"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}
 */

#pragma mark - fristPage

// 首页
- (void)getMyFriendList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getMyFriendList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:0] integerValue]] forKey:@"pageSize"];
        [params setObject:[array objectAtIndex:1] forKey:@"fromLeboID"];
        //
        [params setObject:@"time" forKey: @"filter"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]/*[Global getServerUrl2]*/
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 所有喜欢帖子的人
- (void)getLovePeople:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getLovePeople" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[array objectAtIndex:0] forKey:@"user"];
        [params setObject:[array objectAtIndex:0] forKey:@"leboID"];
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:1] integerValue]] forKey:@"pageSize"];
        [params setObject:[array objectAtIndex:2] forKey:@"fromCommentID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 某个帖子     //***************   √   ***************
- (void)getLebo:(NSString*)leboID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getLebo" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:leboID forKey:@"leboID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 赞帖子  //***************   √   ***************
- (void)loveTopic:(NSString*)topicID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"loveTopic" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:topicID forKey:@"topicID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 转载帖子
- (void)broadcastTopic:(NSString*)leboID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"broadcastTopic" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:leboID forKey:@"leboID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//排行榜上面
- (void)getTopHeadList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getTopHeadList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:0] integerValue]] forKey:@"pageSize"];
        [params setObject:[array objectAtIndex:1] forKey:@"fromLeboID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//排行榜
- (void)getHotList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getHotList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:0] integerValue]] forKey:@"pageSize"];
        [params setObject:[array objectAtIndex:1] forKey:@"fromLeboID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

#pragma mark - find
// 频道   //***************   √   ***************
- (void)getChannelList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getChannelList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[[AccountHelper getAccount] AccountID] forKey:@"accountID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//频道详情  //***************   √   ***************
- (void)getChannelTopicList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getChannelTopicList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"channel"];
        [params setObject:[array objectAtIndex:1] forKey:@"fromLeboID"];
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:2] integerValue]] forKey:@"pageSize"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//搜索频道
- (void)searchChannel:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"searchChannel" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"key"];
        [params setObject:[array objectAtIndex:1] forKey:@"fromLeboID"];
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:2] integerValue]] forKey:@"pageSize"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//搜索user
- (void)searchUser:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"searchUser" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"key"];
        [params setObject:[array objectAtIndex:1] forKey:@"fromAccountID"];
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:2] integerValue]] forKey:@"pageSize"];;
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//推荐
- (void)getRecommendList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getRecommendList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"fromLeboID"];
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:1] integerValue]] forKey:@"pageSize"];
        [dict setObject:params forKey:@"params"];
    }
     
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                           completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//粉丝最多
- (void)getTopFansList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getTopFansList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"fromAccountID"];
        [params setObject:[array objectAtIndex:1] forKey:@"pageSize"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//最受欢迎
- (void)getTopLoveList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getTopLoveList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"fromAccountID"];
        [params setObject:[array objectAtIndex:1] forKey:@"pageSize"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//票房最高
- (void)getTopPlayList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"getTopPlayList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"fromAccountID"];
        [params setObject:[array objectAtIndex:1] forKey:@"pageSize"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

#pragma mark - message(Comment)
// 增加帖子的评论     //***************   √   ***************
- (void)addCommentOfLebo:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    
    [dict setObject:@"addCommentOfLebo" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"leboID"];
        [params setObject:[array objectAtIndex:1] forKey:@"content"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 增加评论的评论  //***************   √   ***************
- (void)addCommentOfComment:(NSArray *)array cachePolicy:(NSURLRequestCachePolicy)cholicy delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
     NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"addCommentOfComment" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"leboID"];
        [params setObject:[array objectAtIndex:1] forKey:@"commentID"];
        [params setObject:[array objectAtIndex:2] forKey:@"content"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 某个贴字的评论  //***************   √   ***************
- (void)getCommentList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
     NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"getCommentList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"leboID"];
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:1] integerValue]] forKey:@"pageSize"];
        [params setObject:[array objectAtIndex:2] forKey:@"fromCommentID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 消息页  //***************   √   ***************
- (void)getAllNotices:(int)startPos endPos:(int)endPos cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
     NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"getAllNotices" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [params setObject:[NSNumber numberWithInt:startPos] forKey:@"startPos"];
        [params setObject:[NSNumber numberWithInt:endPos] forKey:@"endPos"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

- (void)getNewCommentsCount:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
     NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"getNewCommentsCount" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [params setObject:[array objectAtIndex:0] forKey:@"setZero"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

#pragma mark - person
// 个人的发布    //***************   √   ***************
- (void)getMyLeboList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    if(array && [array count] < 2)
    {
        return;
    }
    
     NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"getMyLeboList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"accountID"];
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:1] integerValue]] forKey:@"pageSize"];
        [params setObject:[array objectAtIndex:2] forKey:@"fromLeboID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//我的喜欢
- (void)getMyLoveList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
     NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"getMyLoveList" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"accountID"];
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:1] integerValue]] forKey:@"pageSize"];
        [params setObject:[array objectAtIndex:2] forKey:@"fromLeboID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 删除某一帖子   //***************   √   ***************
- (void)deleteTopic:(NSString*)topicID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
     NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"deleteTopic" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:topicID forKey:@"topicID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 新增粉丝红心数      //***************   √   ***************     //user 可以不填
- (void)getNewPersonalAndFriendsCount:(NSString*)user cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError  
{
     NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"getNewPersonalAndFriendsCount" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[user stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//新增粉丝数清零   //***************   √   ***************     //user 可以不填
- (void)setNewFansCountZero:(NSString*)user cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
     NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"setNewFansCountZero" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[user stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

//新增红心清零    //***************   √   ***************     //user 可以不填
- (void)setNewHeartsCountZero:(NSString*)user cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
     NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"setNewHeartsCountZero" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[user stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

/*
- (void)setNewFriendsCountZero:(NSString*)user cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    LBConfigManager *configManager = [LBConfigManager sharedManager];

    NSMutableDictionary *dict = [configManager getPostJsonHeader];
    [dict setObject:@"setNewFriendsCountZero" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[user stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"user"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}
*/

// 得到新浪好友   //***************   √   ***************
- (void)getSinaFriends:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError         
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"getSinaFriends" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"fromSinaID"];
        [params setObject:[array objectAtIndex:1] forKey:@"isLeboUser"];
        [params setObject:[array objectAtIndex:2] forKey:@"isNotLeboUser"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 搜索乐播好友
- (void)userQuest:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"userQuest" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"user"];
        [params setObject:[array objectAtIndex:1] forKey:@"key"];
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:2] integerValue]] forKey:@"pageSize"];
        [params setObject:[array objectAtIndex:3] forKey:@"fromAccountID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 搜索新浪非乐播好友
- (void)searchSinaFriend:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"searchSinaFriend" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[array objectAtIndex:0] forKey:@"user"];
        [params setObject:[array objectAtIndex:0] forKey:@"key"];
        [params setObject:[NSNumber numberWithInt:[[array objectAtIndex:1] integerValue]] forKey:@"pageSize"];
        [params setObject:[array objectAtIndex:2] forKey:@"fromAccountID"];
        
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 推送开关
- (void)setNotice:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"setNotice" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //[params setObject:[array objectAtIndex:0] forKey:@"user"];
        [params setObject:[array objectAtIndex:0] forKey:@"comment"];
        [params setObject:[array objectAtIndex:1] forKey:@"love"];
        [params setObject:[array objectAtIndex:2] forKey:@"fans"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

#pragma mark - upload
// 更新用户 //***************   √   ***************
- (void)updateAccount:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"updateAccount" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"accountID"];
        [params setObject:[array objectAtIndex:1] forKey:@"photoID"];   //头像图片ID
        [params setObject:[array objectAtIndex:2] forKey:@"sign"];      //签名
        [params setObject:[array objectAtIndex:3] forKey:@"personal"];  //个人介绍
        [params setObject:[array objectAtIndex:4] forKey:@"name"];
        [params setObject:@"" forKey:@"birthday"];
        [params setObject:@"" forKey:@"company"];
        [params setObject:@"" forKey:@"place"];
        [params setObject:@"" forKey:@"attachments"];   //头像
        [params setObject:@"" forKey:@"school"];
        [params setObject:@"" forKey:@"interest"];
        [params setObject:@"" forKey:@"job"];
        [dict setObject:params forKey:@"params"];
        
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getPublishUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

- (void)uploadPhoto:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{

    NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"uploadPhoto" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[array objectAtIndex:0] forKey:@"user"];
        [params setObject:[array objectAtIndex:1] forKey:@"comment"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getPublishUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 上传视频     //***************   √   ***************
- (void)publishLebo:(NSDictionary*)info cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError progressSelector:(SEL)progressSelector
{
    NSString * content = info[@"content"];
    NSString * urlPath = nil;
    NSString * uploadURL = [NSString stringWithFormat:@"%@%@", [Global getPublishUrl2], @" publishLebo/?content="];
    if(content.length == 0)
        urlPath =  uploadURL;
    else
        urlPath = [NSString stringWithFormat:@"%@%@",uploadURL,content];
    LBUploadSender *requestSender = [LBUploadSender requestSenderWithURL:urlPath
                                                                   usePost:YES
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    requestSender.stringEncoding = NSASCIIStringEncoding;
    requestSender.videoPath = info[@"movie"];
    requestSender.image = info[@"photo"];
    requestSender.progressSelector = progressSelector;

    [requestSender send];
}

// 上传头像
- (void)uploadAvatar:(UIImage*)image cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSString * uploadURL =[NSString stringWithFormat:@"%@%@", [Global getPublishUrl2], @" uploadMime/?"];
    LBUploadSender *requestSender = [LBUploadSender requestSenderWithURL:uploadURL
                                                                 usePost:YES
                                                             cachePolicy:cholicy
                                                                delegate:theDelegate
                                                        completeSelector:theSelector
                                                           errorSelector:theSelectorError
                                                        selectorArgument:nil];
    requestSender.stringEncoding = NSASCIIStringEncoding;
    requestSender.image = image;
    [requestSender send];
}

// 修改签名
- (void)setSign:(NSString*)sign cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"updateAccount" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:sign forKey:@"sign"];        
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

// 修改头像
- (void)setAvatar:(NSString*)photoID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"updateAccount" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:photoID forKey:@"photoID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

#pragma mark - end.
- (void)shareFileName:(NSString*)movieID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"shareFileName" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:movieID forKey:@"movieID"];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}

- (void)setAllReaded:(NSString*)user cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError
{
    NSMutableDictionary *dict = [Global getPostJsonHeader];
    [dict setObject:@"setAllReaded" forKey:@"method"];
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [dict setObject:params forKey:@"params"];
    }
    
    LBRequestSender *requestSender = [LBRequestSender requestSenderWithURL:[Global getServerUrl2]
                                                                   usePost:NO
                                                                     param:dict
                                                               cachePolicy:cholicy
                                                                  delegate:theDelegate
                                                          completeSelector:theSelector
                                                             errorSelector:theSelectorError
                                                          selectorArgument:nil];
    [requestSender send];
}


@end
