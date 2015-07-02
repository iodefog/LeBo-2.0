//
//  RenRenHelper.h
//  Lebo-NonArc
//
//  Created by Li Hongli on 13-4-18.
//  Copyright (c) 2013年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Renren.h"
#import "LeboDTO.h"

@protocol RenRenHelperDelegate <NSObject>
@optional
- (void)renrenHelper:(Renren *)renren requestDidReturnResponse:(ROResponse *)response;
- (void)renrenHelper:(Renren *)renren requestFailWithError:(ROError*)error;

-(void)renRenLoginSuccess:(id)result;
-(void)renRenLoginFail:(NSError *)error;

@end

@interface RenRenHelper : NSObject<RenrenDelegate, NSURLConnectionDataDelegate, RenRenHelperDelegate>
{
    NSURLConnection *mConnetion;
    NSMutableData   *mData;
}
@property (nonatomic, weak) id renRenHelperDelegate;
@property (nonatomic, strong)  LeboDTO *dto;
@property (nonatomic, strong)  NSString *movieID;
@property (nonatomic, strong)  NSString *content;
@property (nonatomic, assign)   BOOL    alert;
@property (nonatomic, assign)   BOOL    callBack_Immediately;

+(RenRenHelper *)sharedInstance;

/*  @discussion 得到人人用户的信息
 *  @pragma target 代理
 *  @callBack 成功回调 - (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response;
 * @callBack 失败回调 - (void)renren:(Renren *)renren requestFailWithError:(ROError*)error;
 */
+ (void)getUserInfoTarget:(id)target;

/*  @discussion 传入帖子的dto即可完成分享
    @pragma dto 一篇帖子的数据
 */
+ (void)shareMovieToRenRenDto:(LeboDTO *)dto target:(id)target;


/* @discussion 分享视频到人人网
 * @pragma movieID 用户视频ID
 * @pragma content 用户自定义内容 
 * @pragma alert==YES 有弱提示, 反之无
 * @pragma target 代理
 * @callBack 成功回调 - (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response;
 * @callBack 失败回调 - (void)renren:(Renren *)renren requestFailWithError:(ROError*)error;
 */
+ (void)shareMovieToRenRenMovieID:(NSString *)movieID content:(NSString *)content alert:(BOOL)alert target:(id)target;


/* @discussion 检查人人token是否过期或有效 并检查是否需要登陆 
 * @param target 代理
 * @param isLogin  == YES 不合法就弹出登陆 反之，不弹
 * @callBack 成功回调 -(void)renRenLoginSuccess:(id)result;
 * @callBack 失败回调 -(void)renRenLoginFail:(NSError *)error;
 */
+ (BOOL)isSessionValidTarget:(id)target isLogin:(BOOL)isLogin;


// 登陆
-(void)login;

// 注销 无回调
-(void)logOut;


/*  @discussion 注销有回调
 *  @pragma target 代理
 *  @callBack 注销成功 - (void)renrenDidLogout:(Renren *)renren；
 */
- (void)logOut:(id)target;
@end
