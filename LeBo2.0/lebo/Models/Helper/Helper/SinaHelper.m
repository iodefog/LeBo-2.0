//
//  SinaHelper.m
//  LeBo
//
//  Created by Qiang Zhuang on 1/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SinaHelper.h"
#import "LBAppDelegate.h"
#import "SBJSON.h"
#import "SinaWeibo.h"
#import "LBFileClient.h"

@implementation SinaHelper

+ (SinaHelper *)getHelper {
    static SinaHelper *helper = nil;
    if (helper == nil) {
        helper = [[SinaHelper alloc] init];
    }
    return helper;
}

- (BOOL)sinaIsAuthValid{
   
    return  [[self sinaweibo] isAuthValid];
}

- (SinaWeibo *)sinaweibo
{
    LBAppDelegate *appDelegate = (LBAppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.sinaweibo;
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - API

- (void)login//登陆
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSLog(@"%@", [keyWindow subviews]);
    
    
     _userInfo = nil;
     _statuses = nil;

    SinaWeibo *sinaweibo = [self sinaweibo];
//    sinaweibo.delegate = _delegate;
    [sinaweibo logIn];
}

- (void)logout//登出
{
    SinaWeibo *sinaweibo = [self sinaweibo];
//    sinaweibo.delegate = _delegate;
//    [self removeAuthData];
    [sinaweibo logOut];
}

- (void)getUserInfo//获取用户信息
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

- (void)getFriendsCount:(NSInteger)count cursor:(NSInteger)cursor
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    NSString *userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:userID,@"uid", [NSString stringWithFormat:@"%d",count], @"count", [NSString stringWithFormat:@"%d",cursor],@"cursor",nil];
    [sinaweibo requestWithURL:@"friendships/friends.json"
                       params:dict
                   httpMethod:@"GET"
                     delegate:self];
}

- (void)getFriends:(BOOL)isReload count:(NSInteger)count cursor:(NSInteger)cursor
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    NSString *userID = [sinaweiboInfo objectForKey:@"UserIDKey"];

   NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:userID,@"uid", [NSString stringWithFormat:@"%d",count], @"count", [NSString stringWithFormat:@"%d",cursor],@"cursor",nil];
    NSLog(@"%@",dict);
    [sinaweibo requestWithURL:@"friendships/friends.json"
                       params:dict
                   httpMethod:@"GET"
                     isReload:isReload
                     delegate:self];
}

- (void)getFollowers
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"friendships/followers.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

#pragma mark - SinaWeibo Delegate

// 用户成功登陆
// 注意需要将登陆成功的用户信息缓存下来以便下次使用
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate);
    [self storeAuthData];
    
    if ([_delegate respondsToSelector: @selector(sinaDidLogin:)]) {
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.userID, LB_SINA_USERID,
                              sinaweibo.accessToken, LB_SINA_TOKEN,
                              sinaweibo.expirationDate, LB_SINA_EXPTIME, nil];
        [_delegate performSelector: @selector(sinaDidLogin:) withObject: info];
    }
}

// 用户退出登录
// 注意需要清除已经缓存的用户信息
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
    
    if ([_delegate respondsToSelector: @selector(sinaDidLogout)]) {
        [_delegate performSelector: @selector(sinaDidLogout)];
    }
}

// 用户取消登陆过程
- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
    
    
}

// 登陆失败
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
    
    if ([_delegate respondsToSelector: @selector(sinaDidFailLogin:)]) {
        [_delegate performSelector: @selector(sinaDidFailLogin:) withObject: error];
    }
}

// 缓存的 token 无效或者已经过期
// 注意需要清除缓存的用户信息
- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
    
    if ([_delegate respondsToSelector: @selector(sinaTokenInvalid:)]) {
        [_delegate performSelector: @selector(sinaTokenInvalid:) withObject: error];
    }
}

#pragma mark - SinaWeiboRequest Delegate 

// 请求失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    // 当一个 delegate 需要处理多个请求回调时,可以通过 url 来判断当前的 request
    if ([request.url hasSuffix:@"users/show.json"])
    {
        _userInfo = nil;
        
        if ([_delegate respondsToSelector: @selector(sinaGetFailUserInfo:)]) {
            [_delegate performSelector: @selector(sinaGetFailUserInfo:) withObject: _userInfo];
        }
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"]) {
        // 图片和文字微博上传失败
        if ([_delegate respondsToSelector: @selector(sinaUploadFail:)]) {
            [_delegate performSelector: @selector(sinaUploadFail:) withObject: _userInfo];
        }
    }
    
    else if ([request.url hasSuffix:@"statuses/update.json"]) {
        // 文字微博上传失败
        if ([_delegate respondsToSelector: @selector(sinaUpdateFail:)]) {
            [_delegate performSelector: @selector(sinaUpdateFail:) withObject: _userInfo];
        }
    }
    else if ([request.url hasSuffix:@"short_url/shorten.json"]){
        // 长连接转短链接失败
        if ([_delegate respondsToSelector: @selector(shortUrlFail:)]) {
            [_delegate performSelector: @selector(shortUrlFail:) withObject: _userInfo];
        }
    }
    else if ([request.url hasSuffix:@" friendships/friends.json"]){
        if ([_delegate respondsToSelector:@selector(getFriendFail:)]) {
            [_delegate performSelector: @selector(getFriendFail:) withObject: _userInfo];
        }
    }
    
    //    [self resetButtons];
}

// 请求成功
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    // 当一个 delegate 需要处理多个请求回调时,可以通过 url 来判断当前的 request
    if ([request.url hasSuffix:@"users/show.json"]) {
      
        _userInfo = result ;

        if ([_delegate respondsToSelector: @selector(sinaGetUserInfo:)]) {
            [_delegate performSelector: @selector(sinaGetUserInfo:) withObject: _userInfo];
        }
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"]) {
        // 图片发送成功
        if ([_delegate respondsToSelector: @selector(sinaUploadSuccess:)]) {
            [_delegate performSelector: @selector(sinaUploadSuccess:) withObject: _userInfo];
        }
    }
    // 获取我关注人的list
    else if ([request.url hasSuffix:@"friendships/friends.json"]) {
        _userInfo = result ;
        
        if ([_delegate respondsToSelector: @selector(sinaGetFriends:)]) {
            [_delegate performSelector: @selector(sinaGetFriends:) withObject: _userInfo];
        }
    }
  
    else if ([request.url hasSuffix:@"statuses/update.json"]){
        // 上传文字成功
        if ([_delegate respondsToSelector: @selector(sinaUpdateSuccess:)]) {
            [_delegate performSelector: @selector(sinaUpdateSuccess:) withObject: _userInfo];
        }
    }
    else if ([request.url hasSuffix:@"short_url/shorten.json"]){
        // 长连接转短链接成功
        if(isShare){
        
            NSString *url_short = [[[result objectForKey:@"urls"] lastObject] objectForKey:@"url_short"];
            
            if (url_short.length <= 0) {
                // 图片和文字微博上传失败
                if ([_delegate respondsToSelector: @selector(sinaUploadFail:)]) {
                    [_delegate performSelector: @selector(sinaUploadFail:) withObject: _userInfo];
                }
                return;
            }
            
            NSString *status = [NSString stringWithFormat:@"%@ 视频地址>>>%@",[shareDict objectForKey:@"status"],url_short];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[shareDict objectForKey:@"pic"],@"pic" ,status ,@"status", nil];
            [self updatePicAndMoveUrl:dict];
        }else{
            if ([_delegate respondsToSelector: @selector(shortUrlSuccess:)]) {
                [_delegate performSelector: @selector(shortUrlSuccess:) withObject: result];
            }
        }
    }
    
    //    [self resetButtons];
}

//- (void)dic:(NSDictionary *)info {
//    info = _userInfo;
//}

//需要什么用什么接口，把loadRequestWithMethodName 改变成自己需要的接口，params参数改成需要的参数，就可以了。
//有的接口是不需要params的，比如 statuses/friends_timeline.json获取关注人的微博，这里params可以是nil.


- (void)request:(id)from didReceiveRawData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    NSArray *array = [[str JSONValue] objectForKey:@"users"];
}

- (void)request:(id)from didReceiveRawStr:(NSDictionary *)result
{
    NSLog(@"resposeStr %@", result);
    // 判定是否是分享
}

// 上传分享微博
- (void)updatePicAndMoveUrl:(NSMutableDictionary *)dict{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/upload.json" params:dict  httpMethod:@"POST" delegate:self];
    // 乐播服务器
    [[LBFileClient sharedInstance] shareFileName:mMovieID cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:_delegate selector:@selector(responseSuccess:) selectorError:@selector(responseFail:)];
}

// 转换成flash 连接
- (NSString *)joinlongUrl:(NSString *)movieID{
    return [NSString stringWithFormat:@"%@/?cmd=GEOWEIBOD.playFlash+%@",[Global getServerBaseUrl], movieID];
}

// 发表图片到新浪weibo
- (void)uploadPicture:(NSData *)picData status:(NSString *)status target:(id)target movieID:(NSString *)movieID
{
    [self longUrlTOShortUrl:[self joinlongUrl:movieID]];
    mMovieID = movieID;
    isShare = YES;
    [[SinaHelper getHelper] setDelegate:target];
    shareDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:picData,@"pic" ,status,@"status",nil];
}

// 发表微博
- (void)uploadPicture:(NSData *)picData status:(NSString *)status{
    SinaWeibo *sinaweibo = [self sinaweibo] ;
    if (isShare) {
         [sinaweibo requestWithURL:@"statuses/upload.json" params:shareDict  httpMethod:@"POST" delegate:self];
    }else{
     [sinaweibo requestWithURL:@"statuses/upload.json" params:[NSMutableDictionary dictionaryWithObjectsAndKeys:picData,@"pic" ,status,@"status",nil]  httpMethod:@"POST" delegate:self];
    }
}

// 发表文字到新浪weibo, 文字不超过140个汉字
- (void)updateStatus:(NSString *)status{
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/update.json" params:[NSMutableDictionary dictionaryWithObjectsAndKeys:status,@"status",nil] httpMethod:@"POST" delegate:self];
}

// 长连接转短链接
- (void)longUrlTOShortUrl:(NSString *)longUrl{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"short_url/shorten.json" params:[NSMutableDictionary dictionaryWithObjectsAndKeys:longUrl ,@"url_long", nil] httpMethod:@"GET" delegate:self];
}

//我关注的人列表
- (void)frinedShipsCount:(NSInteger)count cursor:(NSInteger)cursor{
    SinaWeibo *sinaweibo = [self sinaweibo];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    NSString *userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    //count = 40;
    //cursor = 100;
    [sinaweibo requestWithURL:@"friendships/friends.json" params:[NSMutableDictionary dictionaryWithObjectsAndKeys:userID,@"uid",[NSNumber numberWithInt:40],@"count",[NSNumber numberWithInt:100],@"cursor", nil] httpMethod:@"GET" delegate:self];
}
//http://open.weibo.com/wiki/2/friendships/friends

@end
