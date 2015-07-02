//
//  Global.h
//  mcare-model
//
//  Created by sam on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LB_USER_PHOTO_MINI @"GEOWEIBOD.user_mini_mime3"
#define LB_USER_PHOTO @"GEOWEIBOD.user_mime3"
#define LB_TOPIC_PHOTO_MINI @"GEOWEIBOD.topic_mini_mime2"
#define LB_TOPIC_PHOTO @"GEOWEIBOD.topic_mime2"
#define LB_CAPTCHA @"GEOWEIBOD.get_captcha"

@interface Global : NSObject

UINavigationController *selected_navigation_controller();

+ (NSString *)getServerBaseUrl;
+ (NSString *)getServerCommandUrl;
+ (NSString *)getMovieUrl;
+ (NSString *)getServerUrl;
+ (NSString *)getServerUrl2;
+ (NSString *)getPublishUrl;
+ (NSString *)getPublishUrl2;
+ (NSString *)getUploadUrl;
+ (NSString *)getUploadRegistUrl;
+ (NSString *)getUploadSinaRegistUrl;
+ (NSString *)getUploadImageUrl;
+ (NSString *)getTopicUrl;
+ (NSString *)getPicDownloadUrl;
+ (NSString *)getUpdateUrl;
+ (NSString *)getClientId;
+ (void)setAccessToken:(NSString *)token;
+ (NSString *)getAccessToken;
+ (NSString *)getJsonRPCVerion;
+ (NSString *)getVersion;

+ (NSString *)getUserName;
+ (void)setUserName:(NSString *)name;
+ (NSString *)getSessionID;
+ (void)setSessionID:(NSString *)sid;
+ (NSMutableArray *)getCookies;
+ (void)setCookies:(NSMutableArray *)cs;

+ (NSMutableDictionary *)getHeader;
+ (NSInteger)getPageCount;
+ (CGFloat)getScreenWidth;
+ (CGFloat)getScreenHeight;

+ (NSString *)getUploadAndReturnIdUrl:(NSString *)method;
+ (NSString *)getUploadAndPublishUrl;
// 获取当前网络是3G或者是wifi 或者是无网络
+ (NSInteger)checkNetWorkWifiOf3G;
+ (BOOL)canAutoDownLoad;

+ (NSString *)getAppVersion;
+ (NSMutableDictionary *)getPostJsonHeader;

+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size;
+ (void)clearPlayStatus;

@end

@interface UIColor (RGB)
+ (UIColor *)colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b;
@end
