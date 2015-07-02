//
//  LBCommentView.m
//  lebo
//
//  Created by Zhuang Qiang on 3/28/13.
//  Copyright (c) 2013 lebo. All rights reserved.
//



#import "LBCommentView.h"
#import "CommentDTO.h"
#import "LBPersonDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

#define COMMENT_BLANK_LENGTH 9.0
#define COMMENT_AVATAR_LENGTH 35.0
#define COMMENT_TOPFONT_SIZE 14.0
#define COMMENT_DOWNFONT_SIZE 14.0

@implementation LBCommentView
@synthesize timeLabel = _timeLabel;
@synthesize nameLabel = _nameLabel;
@synthesize avatarImage = _avatarImage;
@synthesize commentLabel = _commentLabel;
@synthesize commentID = _commentID;
@synthesize commentUser = _commentUser;
@synthesize leboDTO = _leboDTO;
@synthesize commentTo = _commentTo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createSubview];
        self.backgroundColor = RGB(244, 244, 244);
//        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

+ (CGFloat)rowHeightForObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        CommentDTO *msg = [[CommentDTO alloc] init];
        if([msg parse2:item])
        {
            RTLabel *rtLabel = [[RTLabel alloc] initWithFrame:
                                CGRectMake(0,0,
                                           320 - COMMENT_AVATAR_LENGTH - 3 * COMMENT_BLANK_LENGTH,
                                           100)];
//            [rtLabel setParagraphReplacement:@""];
            if (msg.CommentTo && ![msg.CommentTo isEqualToString: @""])
            {
                [rtLabel setText: [NSString stringWithFormat:@"回复%@:%@", msg.CommentTo ,msg.Content]];
            }
            else
            {
                [rtLabel setText: msg.Content];
            }
            
            [rtLabel setFont:[UIFont systemFontOfSize:14]];
            [rtLabel setLineSpacing: 5];
            CGSize optimumSize = [rtLabel optimumSize];
            CGFloat height = COMMENT_AVATAR_LENGTH + optimumSize.height + 2 * COMMENT_BLANK_LENGTH - COMMENT_DOWNFONT_SIZE;
            return (height < 55) ? 55 : height;
        }
    }
    
    return COMMENT_AVATAR_LENGTH + 2 * COMMENT_BLANK_LENGTH;
}

- (void)setObject:(id)item
{
    NSLog(@"item %@",item);
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        CommentDTO *dto = [[CommentDTO alloc] init];
        if ([dto parse2:item]) {
            // 头像
            [_avatarImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerUrl2], dto.CommentAuthorPhotoUrl]]];
            
            // 昵称
            [_nameLabel setText:dto.CommentAuthorDisplayName];
            [_nameLabel sizeToFit];
            _commentTo = dto.CommentAuthorDisplayName;
            
            // 评论时间
            [_timeLabel setText:[TimeAndLocation time: dto.CommentSubmitTime]];
            
            // 评论内容
            NSString *content = nil;
            if (dto.CommentTo && ![dto.CommentTo isEqualToString: @""]) {
                content = [NSString stringWithFormat:@"回复%@：%@",dto.CommentTo,dto.Content];
            }else{
                content = dto.Content;
            }
            
            [_commentLabel setText: content];
             CGSize optimumSize = [self.commentLabel optimumSize];
             [_commentLabel setHeight:optimumSize.height];
            // 帖子id
            self.commentID = dto.CommentID;
            
            // 显示姓名
            self.commentUser = dto.CommentAuthorDisplayName;
     
        }
    self.commentDTO = dto;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.sperateLine.frame = CGRectMake(0,self.frame.origin.y + self.frame.size.height - 2 , 320, 2);
}

- (void)createSubview
{
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
    
    // 头像
    self.avatarImage = [[UIImageView alloc] initWithFrame:
                        CGRectMake(COMMENT_BLANK_LENGTH,
                                   COMMENT_BLANK_LENGTH,
                                   COMMENT_AVATAR_LENGTH,
                                   COMMENT_AVATAR_LENGTH)];
    [_avatarImage setUserInteractionEnabled:YES];
    [_avatarImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped:)]];
    _avatarImage.layer.cornerRadius = 2.0f;
    _avatarImage.layer.masksToBounds = YES;
    _avatarImage.backgroundColor = [UIColor grayColor];
    [self addSubview:_avatarImage];
    
    // 姓名
    self.nameLabel = [[UILabel alloc] initWithFrame:
                      CGRectMake(_avatarImage.right + COMMENT_BLANK_LENGTH,
                                 8 ,
                                 200, 14)];
    _nameLabel.textColor=[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0f];
//    _nameLabel.textColor = [UIColor blueColor];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font=[UIFont systemFontOfSize:COMMENT_TOPFONT_SIZE];
    [_nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped:)]];
    [self addSubview:_nameLabel];
    
    // 时间
    self.timeLabel = [[UILabel alloc] initWithFrame:
                      CGRectMake(_nameLabel.right,
                                 _nameLabel.top,
                                 320-(_nameLabel.right)-COMMENT_BLANK_LENGTH,
                                 12.0f)];
    [self.timeLabel setTextAlignment:NSTextAlignmentRight];
    [self.timeLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [self.timeLabel setBackgroundColor:[UIColor clearColor]];
    [self.timeLabel setText:@""];
    _timeLabel.textColor=[UIColor colorWithRed:131.0/255.0 green:131.0/255.0 blue:131.0/255.0 alpha:1.0f];
    _timeLabel.font=[UIFont systemFontOfSize:12.0f];
    _timeLabel.backgroundColor = [UIColor clearColor];
    [_timeLabel setAdjustsFontSizeToFitWidth:YES];
    [self addSubview:_timeLabel];
    
    // 评论内容
    self.commentLabel = [[RTLabel alloc] initWithFrame:
                         CGRectMake(_nameLabel.left,
                                    COMMENT_BLANK_LENGTH + COMMENT_AVATAR_LENGTH - COMMENT_DOWNFONT_SIZE - 2,
                                    320 - COMMENT_AVATAR_LENGTH - 3 * COMMENT_BLANK_LENGTH,
                                    100)];
    self.commentLabel.userInteractionEnabled = NO;
    
    [_commentLabel setText: @""];
    _commentLabel.textColor = RGB(30, 30, 30);
    _commentLabel.font=[UIFont systemFontOfSize:COMMENT_DOWNFONT_SIZE];
    _commentLabel.backgroundColor = [UIColor clearColor];
//    [_commentLabel setFont:[UIFont systemFontOfSize:14]];
    [_commentLabel setLineSpacing: 5];
//    [_commentLabel setLineBreakMode: RTTextLineBreakModeWordWrapping];
    [self addSubview:_commentLabel];
    
    self.sperateLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sperateLine.png"]];
    self.sperateLine.frame = CGRectMake(0, self.commentLabel.frame.origin.y + self.commentLabel.frame.size.height , 320, 2);
    [self addSubview:self.sperateLine];
}


- (void)avatarTapped:(UITapGestureRecognizer *)tapGesture {
    
    LBPersonDetailViewController *personalViewController = [[LBPersonDetailViewController alloc] initWithAccountID:self.commentDTO.CommentAuthorID];
    [selected_navigation_controller() pushViewController:personalViewController animated:YES];
    NSLog(@"avatarTapped");
}

@end
