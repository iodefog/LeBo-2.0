//
//  EditSignViewController.h
//  LBDemo
//
//  Created by Li Hongli on 13-3-25.
//  Copyright (c) 2013年 Li Hongli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeDTO.h"
@interface LBEditSignViewController : UIViewController<UITextViewDelegate, MBProgressHUDDelegate>
{
    UITextView  *_signTextView;             //  签名视图
    UILabel     *_wordRemainingCountLabel;  // 剩余字个数
    NSString    *_shortUrl;
    MBProgressHUD *progress;
}
@property (nonatomic, copy)    NSString  *signText;         // 签名文字
@property (nonatomic, assign)  SEL        action;           // 回调函数
@property (nonatomic, weak)    id         parent;          // 父视图
@property (nonatomic, assign)  BOOL       isInviteSinaFriend;   // 邀请新浪好友
@property (nonatomic, assign)  BOOL       isComment;        // message 回复
@property (nonatomic, strong)  NoticeDTO  *noticeDTO;       //来着messageCell 的
@property (nonatomic, strong)  NSString   *sinaFriendName;  //  sina friend's name

@end
