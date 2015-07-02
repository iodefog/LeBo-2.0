//
//  LBRecommendView.m
//  lebo
//
//  Created by yong wang on 13-4-24.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBRecommendView.h"
#import "RecommentDTO.h"
#import "LBPersonDetailViewController.h"

@implementation LBRecommendView
@synthesize avatarImage = _avatarImage;
@synthesize textLabel = _textLabel;
@synthesize detailLabel = _detailLabel;
@synthesize followButton = _followButton;
@synthesize dto = _dto;
@synthesize modelItem = _modelItem;
@synthesize lineImageView = _lineImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 55.;
}

- (void)setObject:(id)item 
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        self.modelItem = item;
        self.dto = [[RecommentDTO alloc] init];
        if([_dto parse2:item])
        {
            [_avatarImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerBaseUrl], _dto.PhotoUrl]]];
            [_textLabel setText: _dto.DisplayName];
            [_detailLabel setText: _dto.Sign];
            [_followButton setBackgroundImage:[UIImage imageNamed:_dto.Attended? @"btn_followed_background":@"btn_follow_background"] forState:UIControlStateNormal];
            [_followButton setImage:[UIImage imageNamed:_dto.Attended?@"cell_did_add":@"cell_add"] forState:UIControlStateNormal];
            if ([_dto.AccountID isEqualToString:[[AccountHelper getAccount] AccountID]]) {
                _followButton.hidden = YES;
            } else
                _followButton.hidden = NO;
        }
    }
}

- (void)createUI
{
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
    
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 53, 320, 1)];
    UIImage *image = [UIImage imageNamed:@"sperateLine"];
    [_lineImageView setImage:[image stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
    [self addSubview:_lineImageView];

    self.avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(7, 9, 35, 35)];
    [_avatarImage setBackgroundColor:RGB(234, 234, 234)];
    [_avatarImage.layer setCornerRadius:2.];
    [_avatarImage setClipsToBounds:YES];
    [self addSubview:_avatarImage];
       
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImage.right + 10, 0, 150, 20)];
    _textLabel.top = _avatarImage.top;
    [_textLabel setTextAlignment:UITextAlignmentLeft];
    [_textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_textLabel setBackgroundColor:[UIColor clearColor]];
    [_textLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [_textLabel setTextColor:[UIColor colorWithRed:30./255. green:30./255. blue:30./255. alpha:1.0]];
    _textLabel.font=[UIFont systemFontOfSize:14];
    [_textLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped:)]];
    [self addSubview:_textLabel];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImage.right + 10, _avatarImage.bottom - 10, 150, 10)];
    [_detailLabel setTextAlignment:NSTextAlignmentLeft];
    [_detailLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [_detailLabel setBackgroundColor:[UIColor clearColor]];
    [_detailLabel setText:@""];
    [_detailLabel setTextColor:[UIColor colorWithRed:131./255. green:131./255. blue:131./255. alpha:1.0]];
    _detailLabel.font = [UIFont systemFontOfSize:10];
    [_detailLabel setAdjustsFontSizeToFitWidth:YES];
    [self addSubview:_detailLabel];
    
    self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followButton setFrame:CGRectMake(260, 12, 50, 31)];
    [_followButton setUserInteractionEnabled:YES];
    [_followButton addTarget:self action:@selector(FollowTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_followButton setImage:[UIImage imageNamed:@"cell_add"] forState:UIControlStateNormal];
    [_followButton setBackgroundImage:[UIImage imageNamed:@"btn_follow_background"] forState:UIControlStateNormal];
    [_followButton setBackgroundImage:[UIImage imageNamed:@"btn_followed_background"] forState:UIControlStateHighlighted];
    [self addSubview:_followButton];
    
    [self setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
}

- (void)FollowTapped:(id)sender
{
    if (_dto.Attended == 0) {
        _dto.Attended = 1;
        [[LBFileClient sharedInstance] follow:_dto.AccountID cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(followDidFinished:) selectorError:@selector(followDidFailed:)];
        [_followButton setImage:[UIImage imageNamed:@"cell_did_add"] forState:UIControlStateNormal];
        [_followButton setBackgroundImage:[[UIImage imageNamed:@"btn_followed_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateNormal];
    } else {
        _dto.Attended = 0;
        [[LBFileClient sharedInstance] unFollow:_dto.AccountID cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(unFollowDidFinished:) selectorError:@selector(unFollowDidFailed:)];
        [_followButton setImage:[UIImage imageNamed:@"cell_add"] forState:UIControlStateNormal];
        [_followButton setBackgroundImage:[[UIImage imageNamed:@"btn_follow_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 8, 14, 8)] forState:UIControlStateNormal];
    }
    [_modelItem setObject:[NSString stringWithFormat:@"%d",_dto.Attended] forKey:@"attended"];
}

- (void)followDidFinished:(id)item
{
    
}

- (void)unfollowDidFinished:(id)item
{
    
}

- (void)followDidFailed:(id)item
{
    
}

- (void)unfollowDidFailed:(id)item
{
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    } else {
        return YES;
    }
    return YES;
}

- (void)tapGesture:(UITapGestureRecognizer*)gesture
{
    LBPersonDetailViewController *personalViewController = [[LBPersonDetailViewController alloc] initWithAccountID:_dto.AccountID];
    [selected_navigation_controller() pushViewController:personalViewController animated:YES];
}

@end
