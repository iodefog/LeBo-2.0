//
//  LBMessageView.m
//  lebo
//
//  Created by yong wang on 13-3-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBMessageView.h"
#import "RTLabel.h"
#import "TimeAndLocation.h"
#import <QuartzCore/QuartzCore.h>
#import "LBEditSignViewController.h"
#import "LBVideoViewController.h"
#import "LBPersonDetailViewController.h"

@implementation LBMessageView
@synthesize avatarImageView = _avatarImageView;
@synthesize label = _label;
@synthesize imageView = _imageView;
@synthesize timeLabel = _timeLabel;
@synthesize photoView = _photoView;
@synthesize msg = _msg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
    }
    return self;
}

- (void)createSubview
{
    [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewClicked:)]];
    self.userInteractionEnabled = YES;
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MsgTipe.png"]];
    [_imageView setFrame:CGRectMake(self.width - 8, 0, 8, 8)];
    [self addSubview:_imageView];
    
    UIImageView *maskAvaImageView = [[UIImageView alloc]  initWithImage:[[UIImage imageNamed:@"mask"] stretchableImageWithLeftCapWidth:11. topCapHeight:11.]];
    maskAvaImageView.frame = CGRectMake(0,0, 35, 35);
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 35, 35)];
    _avatarImageView.backgroundColor = [UIColor grayColor];
    [_avatarImageView addSubview:maskAvaImageView];
    [self addSubview:_avatarImageView];
    
    _label = [[RTLabel alloc] initWithFrame:CGRectMake(9+35+8, 9, 200, 100)];
    _label.userInteractionEnabled = YES;
    _label.lineBreakMode = RTTextLineBreakModeWordWrapping;
    _label.backgroundColor = [UIColor clearColor];
    [_label setFont:[UIFont systemFontOfSize:14.0f]];
    [_label setLineSpacing:8];
    [self addSubview:_label];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _timeLabel.font = [UIFont systemFontOfSize:10.0f];
    _timeLabel.textColor = [UIColor colorWithRed:131/255.0 green:131/255.0 blue:131/255.0 alpha:1];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = UITextAlignmentLeft;
    [self addSubview:_timeLabel];
    
    UIImageView *maskPhotoImageView = [[UIImageView alloc]  initWithImage:[[UIImage imageNamed:@"mask"] stretchableImageWithLeftCapWidth:11. topCapHeight:11.]];
    maskPhotoImageView.frame = CGRectMake(0,0, 35, 35);
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _photoView.frame = CGRectMake(self.width - 9 - 35, 9, 35, 35);
    [_photoView addSubview:maskPhotoImageView];
    [self addSubview:_photoView];
    
    UIImage *image = [UIImage imageNamed:@"sperateLine.png"];
    _sperateLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    _sperateLine.image = [image stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    [self addSubview:_sperateLine];
}

+ (int)getNoticeType:(NoticeDTO *)dto
{
    if ([dto.NoticeType isEqualToString:@"comment"]) {
        return MESSAGE_TYPE_COMMENT;
    } else if ([dto.NoticeType isEqualToString:@"follow"]) {
        return MESSAGE_TYPE_FOLLOW;
    } else if ([dto.NoticeType isEqualToString:@"love"]) {
        return MESSAGE_TYPE_LOVE;
    } 
    return MESSAGE_TYPE_RELAY;
}

- (void)tapViewClicked:(UITapGestureRecognizer *)tapGesture
{
    MESSAGE_TYPE messageType = [LBMessageView getNoticeType:_msg];
    switch (messageType) {
        case MESSAGE_TYPE_COMMENT:
            [self tapCommentClicked];
            break;
        case MESSAGE_TYPE_FOLLOW:
            [self tapFollowClicked];
            break;
        case MESSAGE_TYPE_LOVE:
            [self tapLoveClicked];
            break;
        case MESSAGE_TYPE_RELAY:
            [self tapLoveClicked];
            break;
        default:
            break;
    }
}

- (void)tapCommentClicked {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复TA", @"查看视频", _msg.AuthorDisplayName, nil];
    sheet.tag = 100;
    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [sheet showInView:self];
}

- (void)tapFollowClicked {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:_msg.AuthorDisplayName, nil];
    sheet.tag = 101;
    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [sheet showInView:self];
}

- (void)tapLoveClicked {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看视频",_msg.AuthorDisplayName, nil];
    sheet.tag = 102;
    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [sheet showInView:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 100) {
        switch (buttonIndex) {
            case 0:
            {
                // 回复ta
                LBEditSignViewController *comment = [[LBEditSignViewController alloc] init];
                comment.isComment = YES;
                comment.noticeDTO = _msg;
                [selected_navigation_controller() pushViewController:comment animated:YES];
                break;
            }case 1:{
                // 查看视频
                LBVideoViewController *videoVC = [[LBVideoViewController alloc] initWithTopicID:_msg.SourceTopicID isTitle:YES];
                [selected_navigation_controller() pushViewController:videoVC animated:YES];
                break;
            }case 2:{
                // 作者
                LBPersonDetailViewController *personalViewController = [[LBPersonDetailViewController alloc] initWithAccountID:_msg.Author];
                [selected_navigation_controller() pushViewController:personalViewController animated:YES];
                break;
            }
            default:
                break;
        }
    } else if (actionSheet.tag == 101){
        if (buttonIndex == 0) {
            // 作者
            LBPersonDetailViewController *personalViewController = [[LBPersonDetailViewController alloc] initWithAccountID:_msg.Author];
            [selected_navigation_controller() pushViewController:personalViewController animated:YES];
        }else {
            
        }
    } else if (actionSheet.tag == 102){
        if (buttonIndex == 0) {
            // 查看视频
            LBVideoViewController *videoVC = [[LBVideoViewController alloc] initWithTopicID:_msg.SourceTopicID isTitle:YES];
            [selected_navigation_controller() pushViewController:videoVC animated:YES];
            
        } else if (buttonIndex == 1){
            // 作者
            LBPersonDetailViewController *personalViewController = [[LBPersonDetailViewController alloc] initWithAccountID:_msg.Author];
            [selected_navigation_controller() pushViewController:personalViewController animated:YES];
        } else {
            
        }
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        NoticeDTO *msg = [[NoticeDTO alloc] init];
        if([msg parse2:item])
        {
            RTLabel *rtLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
            rtLabel.font = [UIFont systemFontOfSize:14.0f];
            [rtLabel setLineSpacing:8];
            rtLabel.lineBreakMode = RTTextLineBreakModeWordWrapping;
            
            MESSAGE_TYPE messageType = [LBMessageView getNoticeType:msg];
            switch (messageType) {
                case MESSAGE_TYPE_COMMENT:
                    [rtLabel setText:[NSString   stringWithFormat:@"<font face=Futura size=14 color='#1E1E1E'>%@:</font><font face=Futura size=14 color='#5E5E5E'> %@</font>", msg.AuthorDisplayName, msg.Content]];
                    break;
                case MESSAGE_TYPE_FOLLOW:
                    [rtLabel setText:[NSString stringWithFormat:@"<font face=Futura size=14 color='#1E1E1E'>%@</font><font face=Futura size=14 color='#5E5E5E'> 关注了你</font> ", msg.AuthorDisplayName]];
                    break;
                case MESSAGE_TYPE_LOVE:
                    [rtLabel setText:[NSString stringWithFormat:@"<font face=Futura size=14 color='#1E1E1E'>%@</font><font face=Futura size=14 color='#5E5E5E'> 喜欢你的视频</font>", msg.AuthorDisplayName]];
                    break;
                case MESSAGE_TYPE_RELAY:
                    [rtLabel setText:[NSString stringWithFormat:@"<font face=Futura size=14 color='#1E1E1E'>%@</font><font face=Futura size=14 color='#5E5E5E'> 转播了你的视频</font>", msg.AuthorDisplayName]];
                    break;
                default:
                    break;
            }
            
            CGSize optimumSize = [rtLabel optimumSize];
            [rtLabel setHeight:optimumSize.height];
            if (9 + optimumSize.height + 5 + 10 <= 55) {
                return 55.0f;
            } else
                return 9 + optimumSize.height + 5 + 10 + 11;
        }
    }

    return 53.;
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        self.msg = [[NoticeDTO alloc] init];
        if([_msg parse2:item])
        {
            MESSAGE_TYPE messageType = [LBMessageView getNoticeType:_msg];
            switch (messageType) {
                case MESSAGE_TYPE_COMMENT:
                    [_label setText:[NSString   stringWithFormat:@"<font face=Futura size=14 color='#1E1E1E'>%@:</font><font face=Futura size=14 color='#5E5E5E'> %@</font>", _msg.AuthorDisplayName, _msg.Content]];
                    break;
                case MESSAGE_TYPE_FOLLOW:
                    [_label setText:[NSString stringWithFormat:@"<font face=Futura size=14 color='#1E1E1E'>%@</font><font face=Futura size=14 color='#5E5E5E'> 关注了你</font> ", _msg.AuthorDisplayName]];
                    break;
                case MESSAGE_TYPE_LOVE:
                    [_label setText:[NSString stringWithFormat:@"<font face=Futura size=14 color='#1E1E1E'>%@</font><font face=Futura size=14 color='#5E5E5E'> 喜欢你的视频</font>", _msg.AuthorDisplayName]];
                    break;
                case MESSAGE_TYPE_RELAY:
                    [_label setText:[NSString stringWithFormat:@"<font face=Futura size=14 color='#1E1E1E'>%@</font><font face=Futura size=14 color='#5E5E5E'> 转播了你的视频</font>", _msg.AuthorDisplayName]];
                    break;
                default:
                    break;
            }

            CGSize optimumSize = [_label optimumSize];
            [_label setHeight:optimumSize.height];
            //_avatarImageView.center = CGPointMake(_avatarImageView.center.x, (30 + optimumSize.height)/2 - 4);
            [_avatarImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerUrl2], _msg.AuthorPhotoUrl]]];
            
            [_timeLabel setText:[TimeAndLocation time:_msg.SubmitTime]];
            _timeLabel.frame = CGRectMake(9+35+8, 9+optimumSize.height+5, 50, 10);
            
            [_imageView setHidden:[_msg.AlreadyRead boolValue]];
            [item setObject:@"1" forKey:@"isRead"];
            //_photoView.center = CGPointMake(_photoView.center.x, (30 + optimumSize.height)/2 - 4);
            [_photoView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerUrl2], _msg.SourcePhotoUrl]]];
            
            float line;
            if (9 + optimumSize.height + 5 + 10 <= 55) {
                line = 55.0;
            }else
                line = 9 + optimumSize.height + 5 + 10 + 11;
            _sperateLine.frame = CGRectMake(0, line-2, 320, 2);
        }
    }
}

@end
