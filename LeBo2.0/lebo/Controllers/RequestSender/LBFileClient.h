//
//  FileClient.h
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBRequestSender.h"
#import "AccountDTO.h"

@interface LBFileClient : NSObject

+ (LBFileClient *)sharedInstance;

#pragma mark - Login

//乐播·热门
- (void)getHotList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 登录
//- (void)login:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 登出
- (void)logout:(NSString*)user cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

- (void)registerDeviceInfo:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

- (void)logoutDevice:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 检查邮箱
//- (void)checkRegist:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 检查验证码
//- (void)checkCaptcha:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// sina登录
- (void)loginBySinaToken:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

- (void)waitLoginBySinaToken:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 移除新浪账号
- (void)debugRemoveSina:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 使用token登录
- (void)loginByToken:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 获取用户信息
- (void)getAccountInfo:(NSString*)accountID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 更新用户
- (void)updateAccount:(id)delegate with:(AccountDTO *)dto;

// 获取新浪好友
- (void)checkSinaUser:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 获取分享文案
- (void)getShareTextAndImage:(NSString*)type cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
#pragma mark ---------

// 关注列表
- (void)getMyAttendList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 粉丝列表
- (void)getMyFansList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 红心列表
- (void)getMyHeartList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 黑名单列表
- (void)getMyBlackList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 关注
- (void)follow:(NSString*)attendUser cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 取消关注
- (void)unFollow:(NSString*)unAttendUser cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//// 拉黑
//- (void)black:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
//
//// 取消拉黑
//- (void)unBlack:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
//
//// 将多人取消拉黑
//- (void)unBlackList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 举报并拉黑
- (void)reportAccount:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//// 密码设置
//- (void)passSetting:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
//
//// 隐私设置
//- (void)secretSetting:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
//
//// 找回密码
//- (void)findPassword:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

#pragma mark - fristPage
// 首页
- (void)getMyFriendList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 所有喜欢帖子的人
- (void)getLovePeople:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 某个帖子
- (void)getLebo:(NSString*)leboID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 赞帖子
- (void)loveTopic:(NSString*)topicID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 转载帖子
- (void)broadcastTopic:(NSString*)leboID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 排行榜上面
- (void)getTopHeadList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

#pragma mark - find

//频道
- (void)getChannelList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//频道详情
- (void)getChannelTopicList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//搜索频道
- (void)searchChannel:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//搜索user
- (void)searchUser:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//推荐
- (void)getRecommendList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//粉丝最多
- (void)getTopFansList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//最受欢迎
- (void)getTopLoveList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//票房最高
- (void)getTopPlayList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

#pragma mark - message(Comment)

// 增加帖子的评论
- (void)addCommentOfLebo:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 增加评论的评论
- (void)addCommentOfComment:(NSArray *)array cachePolicy:(NSURLRequestCachePolicy)cholicy delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//得到某条帖子的评论
- (void)getCommentList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//得到所有评论
- (void)getAllNotices:(int)startPos endPos:(int)endPos cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//新增评论数
- (void)getNewCommentsCount:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

#pragma mark - person
// 个人的发布
- (void)getMyLeboList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 个人喜欢
- (void)getMyLoveList:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 删除某一帖子
- (void)deleteTopic:(NSString*)topicID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 新增粉丝红心数
- (void)getNewPersonalAndFriendsCount:(NSString*)user cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
- (void)setNewFansCountZero:(NSString*)user cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
- (void)setNewHeartsCountZero:(NSString*)user cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
//- (void)setNewFriendsCountZero:(NSString*)user cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
- (void)getSinaFriends:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 搜索乐播好友
- (void)userQuest:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
// 搜索新浪非乐播好友
- (void)searchSinaFriend:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

// 推送开关
- (void)setNotice:(NSArray*)array cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

//上传
- (void)publishLebo:(NSDictionary*)info cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError progressSelector:(SEL)progressSelector;
- (void)uploadAvatar:(UIImage*)image cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
- (void)setSign:(NSString*)sign cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
- (void)setAvatar:(NSString*)photoID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;

- (void)shareFileName:(NSString*)movieID cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
- (void)setAllReaded:(NSString*)user cachePolicy:(NSURLRequestCachePolicy)cholicy  delegate:(id)theDelegate selector:(SEL)theSelector selectorError:(SEL)theSelectorError;
@end
