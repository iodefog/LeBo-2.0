//
//  EditSignViewController.h
//  LBDemo
//
//  Created by Li Hongli on 13-3-25.
//  Copyright (c) 2013年 Li Hongli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBSinaViewController : UIViewController<UITextViewDelegate, MBProgressHUDDelegate>
{
    UITextView  *_signTextView;             // 签名视图
    UILabel     *_wordRemainingCountLabel;  // 剩余字个数
    NSString    *_shortUrl;
    MBProgressHUD *progress;                // 进度条
    BOOL        isUnFinishedShortUrl;       // 当点击邀请，而短链接为完成
}

@property (nonatomic, assign)   SEL        action;           // 回调函数
@property (nonatomic, weak)     id         parent;           // 父视图
@property (nonatomic, assign)   BOOL       isShareToSina;    // 分享到新浪
@property (nonatomic, strong)   NSString   *movieUrl;        // 视频地址
@property (nonatomic, strong)   NSString   *movieID;         // 视频地址
@property (nonatomic, strong)   NSString   *movieTitle;      // 视频名
@property (nonatomic, strong)   UIImage    *thumbImage;      // 图片ID
@property (nonatomic, copy)     NSString   *authorName;      // 视频作者
@property (nonatomic, assign)   BOOL       isShareToRenRen;  // 分享到人人网

@end
