//
//  LBSearchView.m
//  lebo
//
//  Created by King on 13-4-19.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBSearchUserView.h"
#import "Global.h"
#import "SearchDTO.h"
#import "LBPersonDetailViewController.h"

@implementation LBSearchUserView

@synthesize avatarImage = _avatarImage;
@synthesize nameLabel = _nameLabel;
@synthesize signLabel = _signLabel;
@synthesize attendBtn = _attendBtn;
@synthesize modelItem =_modelItem;
@synthesize lineImageView = _lineImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    self.avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 35, 35)];
    [_avatarImage.layer setCornerRadius:2.0];
    _avatarImage.clipsToBounds = YES;
    [_avatarImage setBackgroundColor:RGB(234, 234, 234)];
    [self addSubview:_avatarImage];
    
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 54, 320, 1)];
    [_lineImageView setImage:[[UIImage imageNamed:@"sperateLine"] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
    [self addSubview:_lineImageView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 10, 200, 16)];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    [_nameLabel setTextColor:[UIColor blackColor]];
    [_nameLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_nameLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:_nameLabel];
    
    self.signLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 28, 200, 16)];
    [_signLabel setBackgroundColor:[UIColor clearColor]];
    [_signLabel setTextColor:[UIColor blackColor]];
    [_signLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_signLabel setTextAlignment:NSTextAlignmentLeft];
    [_signLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self addSubview:_signLabel];
    
    self.attendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_attendBtn setFrame:CGRectMake(260, 12, 50, 31)];
    [_attendBtn addTarget:self action:@selector(attend:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_attendBtn];
    
    [self setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
}

- (void)attend:(UIButton *)btn
{
    if (dto.Attended == 0) {
        dto.Attended = 1;
        [client follow:dto.AccountID cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(followDidFinished:) selectorError:@selector(followDidFailed:)];
        [_attendBtn setImage:[UIImage imageNamed:@"cell_did_add"] forState:UIControlStateNormal];
        [_attendBtn setBackgroundImage:[[UIImage imageNamed:@"btn_followed_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateNormal];
    } else {
        dto.Attended = 0;
        [client unFollow:dto.AccountID cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(unFollowDidFinished:) selectorError:@selector(unFollowDidFailed:)];
        [_attendBtn setImage:[UIImage imageNamed:@"cell_add"] forState:UIControlStateNormal];
        [_attendBtn setBackgroundImage:[[UIImage imageNamed:@"invite"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 8, 14, 8)] forState:UIControlStateNormal];
    }
    [_modelItem setObject:[NSString stringWithFormat:@"%d",dto.Attended] forKey:@"attended"];
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 55.;
}

- (void)setObject:(id)item
{
    if (item && [item isKindOfClass:[NSDictionary class]]) {
        dto = [[SearchDTO alloc] init];
        [dto parse2:item];
        self.modelItem = item;
        
        [_avatarImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerBaseUrl], dto.PhotoUrl]]];
        [_nameLabel setText:dto.DisplayName];
        [_signLabel setText:dto.Sign];
        
        if (dto.Attended) {
            [_attendBtn setImage:[UIImage imageNamed:@"cell_did_add"] forState:UIControlStateNormal];
            [_attendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_attendBtn setBackgroundImage:[[UIImage imageNamed:@"btn_followed_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 8, 14, 8)] forState:UIControlStateNormal];
        } else {
            [_attendBtn setImage:[UIImage imageNamed:@"cell_add"] forState:UIControlStateNormal];
            [_attendBtn setBackgroundImage:[[UIImage imageNamed:@"invite"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateNormal];
            [_attendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        if ([dto.AccountID isEqualToString:[[AccountHelper getAccount] AccountID]]) {
            _attendBtn.hidden = YES;
        } else
            _attendBtn.hidden = NO;
    }
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
    } else
        return YES;
    return YES;
}

- (void)tapGesture:(UITapGestureRecognizer*)gesture
{
    LBPersonDetailViewController *personalViewController = [[LBPersonDetailViewController alloc] initWithAccountID:dto.AccountID];
    [selected_navigation_controller() pushViewController:personalViewController animated:YES];
}

@end
