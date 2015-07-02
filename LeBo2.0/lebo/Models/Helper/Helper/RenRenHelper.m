//
//  RenRenHelper.m
//  Lebo-NonArc
//
//  Created by Li Hongli on 13-4-18.
//  Copyright (c) 2013年 sam. All rights reserved.
//

#import "RenRenHelper.h"
#import "TFHpple.h"
#import "JSON.h"

@implementation RenRenHelper

static RenRenHelper *helper = nil;

+(RenRenHelper *)sharedInstance{
    if (!helper) {
        helper = [[RenRenHelper alloc] init];
    }
return helper;
}


+ (void)shareMovieToRenRenDto:(LeboDTO *)dto target:(id)target{
    [[RenRenHelper sharedInstance] setAlert:YES];
    [[RenRenHelper sharedInstance] setDto:dto];
    [[RenRenHelper sharedInstance] setMovieID:dto.MovieID];
    [[RenRenHelper sharedInstance] setContent:dto.Content];
    [[RenRenHelper sharedInstance] shareToRenRen:target];
}

+ (void)shareMovieToRenRenMovieID:(NSString *)movieID content:(NSString *)content alert:(BOOL)alert target:(id)target{
    RenRenHelper *helper =[RenRenHelper sharedInstance];
    helper.alert = alert;
    helper.content = content;
    helper.movieID = movieID;
    helper.renRenHelperDelegate = target;
    [helper shareToRenRen:target];
}

+ (void)getUserInfoTarget:(id)target{
   
    if ([RenRenHelper isSessionValidTarget:target isLogin:NO]) {
        RenRenHelper *helper = [RenRenHelper sharedInstance];
        helper.renRenHelperDelegate = target;
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"users.getInfo" forKey:@"method"];
        [params setObject:@"name" forKey:@"fields"];
        [[Renren sharedRenren] requestWithParams:params andDelegate:helper];
    }
}

// 检查人人token是否过期或有效 并检查是否需要登陆 
+ (BOOL)isSessionValidTarget:(id)target isLogin:(BOOL)isLogin{
    BOOL isSessionValid = NO;
    [RenRenHelper sharedInstance].renRenHelperDelegate = target;
    Renren *renren = [Renren sharedRenren];
    if ([renren isSessionValid]) {
        isSessionValid = YES;
    }else{
        isSessionValid = NO;
        if (isLogin) {
            [[RenRenHelper sharedInstance] login];
        }
    }
    return isSessionValid;
}


#pragma mark - RenrenDelegate Method
// 人人登陆与分享
- (void)login{
    Renren *renren = [Renren sharedRenren];
   
    if (![renren isSessionValid]) {
        NSLog(@"未登录");
        NSArray *permissions = [NSArray arrayWithObjects:@"photo_upload", @"publish_feed",@"status_update", nil];
        [renren authorizationInNavigationWithPermisson:permissions andDelegate:self];
    }else{
        NSLog(@"已登录");
    }
}


// 上传图片
- (void)uploadImage:(Renren *)renren{
    // 上传照片
    [renren publishPhotoSimplyWithImage:[UIImage imageNamed:@"icon@2x.png"] caption:@"这是测试图片"];
}


// 发布转化为短链接的url到人人
- (void)shareToShare:(NSString *)url{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
    [params setObject:@"share.share" forKey:@"method"];// 方法
    [params setObject:@"10" forKey:@"type"];//分享的类型：日志为1、照片为2、链接为6、相册为8、视频为10、音频为11、分享为20。
    [params setObject:url forKey:@"url"];

    if (self.content.length <=0) {
        [params setObject:@"乐播-6秒视频，真的很不错！" forKey:@"comment"];
    }else{
        [params setObject:[NSString stringWithFormat:@"%@",self.content] forKey:@"comment"];
    }
    NSString *source_link = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\"}",@"text",@"乐播-6秒视频",@"href",@"http://www.lebooo.com/"];
    [params setObject:source_link forKey:@"source_link"];
    
    [[Renren sharedRenren] requestWithParams:params andDelegate:self];
    
    // 乐播服务器
    [[LBFileClient sharedInstance] shareFileName:self.movieID cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(renrenResponseSuccess:) selectorError:@selector(renrenResponseFail:)];
}

- (void)renrenResponseSuccess:(id)result{
    NSLog(@"result  %@", result);
}

- (void)renrenResponseFail:(NSError *)error{
    NSLog(@"error  %@",error);
}


// 发布新鲜事
- (void)publishNew:(Renren *)renren{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
    [params setObject:@"feed.publishFeed" forKey:@"method"];// 方法
    [params setObject:@"我是标题" forKey:@"name"]; // 新鲜事标题
    [params setObject:@"我是内容" forKey:@"description"];// 新鲜事内容
    [params setObject:@"http://h.hiphotos.baidu.com/album/w%3D230/sign=57649140bba1cd1105b675238913c8b0/d01373f082025aaf0bb70bbbfaedab64034f1a3c.jpg" forKey:@"url"]; //新鲜事标题和图片指向的链接。
    [params setObject:@"我是用户输入的内容" forKey:@"message"];//用户输入的自定义内容。注意：最多200个字符。
    [params setObject:@"http://h.hiphotos.baidu.com/album/w%3D2048/sign=47cb0deb30adcbef0134790698972fdd/3b292df5e0fe99252b585d7f35a85edf8db1714c.jpg" forKey:@"image"];//新鲜事图片地址
    [params setObject:@"新鲜事副标题" forKey:@"caption"];//新鲜事副标题 注意：最多20个字符
    [params setObject:@"乐播-6秒视频" forKey:@"action_name"];//新鲜事动作模块文案。 注意：最多10个字符
    [params setObject:@"http://www.lebooo.com/" forKey:@"action_link"];//新鲜事动作模块链接。
    [renren requestWithParams:params andDelegate:self];
}

// 登陆成功回调
// @param renren 传回代理授权登陆几口请求的renren 类型对象
- (void)renrenDidLogin:(Renren *)renren{
    
    if (self.renRenHelperDelegate && [self.renRenHelperDelegate respondsToSelector:@selector(renRenLoginSuccess:)]) {
        [self.renRenHelperDelegate performSelector:@selector(renRenLoginSuccess:) withObject:renren];
    }
}

// 登陆失败回调
- (void)renren:(Renren *)renren loginFailWithError:(ROError *)error
{
    if (self.renRenHelperDelegate && [self.renRenHelperDelegate respondsToSelector:@selector(renRenLoginFail:)]) {
        [self.renRenHelperDelegate performSelector:@selector(renRenLoginFail:) withObject:error];
    }
}

/* 发布成功
 @param renren 传回代理服务器接口请求的 Renren 类型对象。@param response 传回接口请求的响应
 */
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response{
    NSLog(@"response.rootObject %@",response.rootObject);
    if (self.renRenHelperDelegate && [self.renRenHelperDelegate respondsToSelector:@selector(renrenHelper:requestDidReturnResponse:) ] ) {
        [self.renRenHelperDelegate performSelector:@selector(renrenHelper:requestDidReturnResponse:) withObject:renren withObject:response];
    }
}

/* 发布失败
 @param renren 传回代理服务器接口请求的 Renren 类型对象。@param response 传回接口请求的错误对象。
 */
- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error{
    NSLog(@"error  %@",error);
    if (self.renRenHelperDelegate && [self.renRenHelperDelegate respondsToSelector:@selector(renrenHelper:requestFailWithError:)]) {
        [self.renRenHelperDelegate performSelector:@selector(renrenHelper:requestFailWithError:) withObject:renren withObject:error];
    }
}

// 人人注销
- (void)logOut{
    Renren *renren = [Renren sharedRenren];
    [renren logout:self];
}

// 人人注销有回调
- (void)logOut:(id)target{
    Renren *renren = [Renren sharedRenren];
    [renren logout:target];
}

// 注销成功 @param renren 传回代理登出接口请求的 Renren 类型对象。
- (void)renrenDidLogout:(Renren *)renren{
    NSLog(@"人人退出成功");
}

#pragma mark - NSURLConnectionDelegate

// 视频长url 转 短url
- (void)shareToRenRen:(Renren *)renren{
    //RenRenHelper *helper = [RenRenHelper sharedInstance];
    if (![RenRenHelper isSessionValidTarget:self.renRenHelperDelegate isLogin:NO]) {
        if (self.alert) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"人人网不可用"];
        }
        return;
    }
    
    mData = [[NSMutableData alloc] init];
    NSString * movieUrl = [NSString stringWithFormat:@"%@/?cmd=GEOWEIBOD.playFlash+%@",[Global getServerBaseUrl], self.movieID];
//    NSString *movieUrl = @"http://www.tudou.com/listplay/m61Qw_c-0aU/3AJSN_znAx0.html?resourceId=0_06_02_99";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://baid.ws/?url=%@",movieUrl]];
    mConnetion = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    [mConnetion start];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [mData setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //
    //    NSString *str = [[NSString alloc] initWithData:mData encoding:encoding];
    //     NSLog(@"%@",str);
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:mData];
    NSArray *elements = [hpple searchWithXPathQuery:@"/html/body/div[1]/div[2]/div[2]/table/tr/td/strong/a"];
    TFHppleElement *element = [elements lastObject];
    TFHppleElement *childElement = element.firstChild;
    NSLog(@"%@",childElement.content);
    if (childElement.content) {
        [self shareToShare:childElement.content];
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error  %@",error);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //    NSLog(@"%@", data);
    [mData appendData:data];
}



@end
