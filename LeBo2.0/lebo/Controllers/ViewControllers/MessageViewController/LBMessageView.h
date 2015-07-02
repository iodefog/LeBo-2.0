//
//  LBMessageView.h
//  lebo
//
//  Created by yong wang on 13-3-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

typedef enum
{
    MESSAGE_TYPE_RELAY   = 0,
    MESSAGE_TYPE_COMMENT,
    MESSAGE_TYPE_FOLLOW,      
    MESSAGE_TYPE_LOVE,
    
}MESSAGE_TYPE;

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "LBBaseView.h"
#import "NoticeDTO.h"

@interface LBMessageView : LBBaseView<UIActionSheetDelegate,SDWebImageManagerDelegate>

@property (nonatomic, retain) UIImageView *avatarImageView;
@property (nonatomic, retain) RTLabel *label;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, retain) UIImageView *sperateLine;
@property (nonatomic, retain) NoticeDTO *msg;

- (void)tapViewClicked;
- (void)createSubview;
+ (CGFloat)rowHeightForObject:(id)item;
- (void)setObject:(id)item;

@end
