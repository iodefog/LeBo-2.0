//
//  AccountDTO.h
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTOBase.h"

@interface AccountDTO : DTOBase {
	NSString *AccountID;
	NSInteger AccountSN;
	NSString *Password;
	NSString *Realname;
    NSString *Email;
    NSString *Birthday;             // 生日
	NSInteger Gender;               // 性别
    NSString *Age;                  // 年龄
    NSString *StarSign;             // 星座
    NSString *Location;             // 距离
    NSString *Job;                  // 职业
    NSString *Company;              // 公司
    NSString *School;               // 学校
    NSString *Interest;             // 兴趣爱好
    NSString *Place;                // 常出没的地方
    NSString *Personal;             // 个人说明
    NSString *Sign;                 // 签名
	NSString *Token;               
	NSDate   *LastLoginTime;        // 上次登录时间
    NSDate   *RegisterTime;         // 注册时间
	NSString *PhotoID;              // 头像
    NSString *PhotoUrl;
    NSArray  *Attachments;          // 相册
    NSInteger AuthorTopicCount;     // 帖子总数
    NSInteger AttendCount;          // 关注数目
    NSInteger FansCount;            // 粉丝数目
    NSInteger HeartCount;           // 红心数目
    NSInteger TopicCount;           // 帖子数量
    NSInteger LoveTopicCount;       // 喜欢帖子数量
    NSInteger Attended;             // 是否被关注
    NSInteger Blacked;              // 是否被拉黑
    BOOL isLogin;
    NSString *SessionID;
    NSString *user;
    NSString *DisplayName;
    NSString *Name;
    NSString *loginType;            // 登陆类型 sina == 新浪 其他 == normal
    NSString *CommentMode;          // 评论推送
    NSString *LoveMode;             // 被赞推送
    NSString *FansMode;             // 新粉丝推送
    NSString *TotalLoveCount;       // 视频被喜欢总次数
    NSString *TotalPlayCount;       // 视频总播放次数
 }

@property (nonatomic, readonly) NSString *user;
@property (nonatomic, readonly) NSString *AccountID;
@property (nonatomic, readonly) NSString *DisplayName;
@property (nonatomic, assign) NSInteger AccountSN;
@property (nonatomic, readonly) NSString *Password;
@property (nonatomic, readonly) NSString *Realname;
@property (nonatomic, readonly) NSString *Email;
@property (nonatomic, assign) NSInteger Gender;
@property (nonatomic, readonly) NSString *Birthday;
@property (nonatomic, readonly) NSString *Age;
@property (nonatomic, readonly) NSString *StarSign;
@property (nonatomic, readonly) NSString *Location;
@property (nonatomic, readonly) NSString *Job;
@property (nonatomic, readonly) NSString *Company;
@property (nonatomic, readonly) NSString *School;
@property (nonatomic, readonly) NSString *Interest;
@property (nonatomic, readonly) NSString *Place;
@property (nonatomic, readonly) NSString *Personal;
@property (nonatomic, copy) NSString *Sign;
@property (nonatomic, readonly) NSString *Token;
@property (nonatomic, readonly) NSDate *LastLoginTime;
@property (nonatomic, readonly) NSDate *RegisterTime;
@property (nonatomic, copy) NSString *PhotoID;
@property (nonatomic, copy) NSString *PhotoUrl;
@property (nonatomic, readonly) NSArray *Attachments;
@property (nonatomic, assign) NSInteger AttendCount;
@property (nonatomic, assign) NSInteger FansCount;
@property (nonatomic, assign) NSInteger AuthorTopicCount;
@property (nonatomic, assign) NSInteger HeartCount;
@property (nonatomic, assign) NSInteger TopicCount;
@property (nonatomic, assign) NSInteger LoveTopicCount;
@property (nonatomic, assign) NSInteger Attended;
@property (nonatomic, assign) NSInteger Blacked;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, readonly) NSString *SessionID;
@property (nonatomic, readonly) NSString *Name;
@property (nonatomic, readonly) NSString *loginType;
@property (nonatomic, copy) NSString *CommentMode;
@property (nonatomic, copy) NSString *LoveMode;
@property (nonatomic, copy) NSString *FansMode;
@property (nonatomic, readonly) NSString *TotalLoveCount;
@property (nonatomic, readonly) NSString *TotalPlayCount;

@end
