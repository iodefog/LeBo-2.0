//
//  LBModelApiViewController.h
//  lebo
//
//  Created by yong wang on 13-3-21.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

typedef enum
{
    API_GET_HOME_LIST  = 0,         //主页
    API_GET_HOT_VIDEO_LIST,         //热门
    API_GET_CHANNEL_LIST,           //频道
    API_GET_CHANNEL_TOPIC_LIST,     //频道详情
    API_GET_MY_VIDEO_LIST,          //我的视频
    API_GET_MY_LOVE_VIDEO_LIST,     //我的喜欢
    API_GET_COMMENT_LIST,           //帖子评论
    API_GET_MESSAGE_LIST,           //消息
    API_GET_FOllOW_LIST,            //获取关注
    API_GET_FANS_LIST,              //获取粉丝
    API_GET_FRIEND_LIST,            //获取好友
    API_GET_TOPIC_LIST,             //帖子详情
    API_GET_BROADCAST_LIST,         //帖子转载
    API_GET_SEARCH_USER,            //搜索人
    API_GET_SEARCH_CHANNEL,         //搜索频道
    API_GET_RECOMMEND_LIST,         //推荐关注
    API_GET_TOPFANS_LIST,           //粉丝最多
    API_GET_TOPLOVE_LIST,           //最受欢迎
    API_GET_TOPPLAY_LIST,           //票房最高
    API_GET_ACCOUNT_LIST,           //票房最高
}API_GET_TYPE;

@interface LBModelApiViewController : LBBaseController  {
    BOOL loading;
}

@property (nonatomic, retain) id model;

// subclass to override
- (BOOL)shouldLoad;
- (BOOL)isLoading;
- (void)reloadData;

- (void)loadData:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more;
- (void)didFinishLoad:(id)object;
- (void)didFailWithError:(int)type;
- (void)requestError:(NSError*)error;

- (void)loadMoreData:(NSNumber *)loadHeader;
- (NSString *)getLeboID:(BOOL)more;
- (NSString *)channelTitles;
- (NSString *)getTopicLeboID;
- (NSString *)getKey;
- (int)getNoticeRange;
- (API_GET_TYPE)modelApi;

@end
