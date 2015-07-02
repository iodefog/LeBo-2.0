//
//  LBFriendView.m
//  lebo
//
//  Created by lebo on 13-3-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBFriendView.h"

@implementation LBFriendView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _dto = [[AddSinaFriendsDTO alloc] init];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self customView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)customView
{
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellDidClicked:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setDelegate:self];
    [self.contentView addGestureRecognizer:tapGesture];
    
    _lineImageView = [[UIImageView alloc] initWithFrame:kPersonLineRect];
    [_lineImageView setBackgroundColor:RGB(255, 255, 255)];
    [self.contentView addSubview:_lineImageView];
    
    _bottomView = [[UIImageView alloc] initWithFrame:kPersonBottomLineRect];
    [_bottomView setBackgroundColor:RGB(184, 184, 184)];
    [self.contentView addSubview:_bottomView];
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:kPersonListImageRect];
    [_avatarImageView setBackgroundColor:[UIColor clearColor]];
    [_avatarImageView.layer setCornerRadius:2.0f];
    [_avatarImageView.layer setMasksToBounds:YES];
    [_avatarImageView setClipsToBounds:YES];
    [self.contentView addSubview:_avatarImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:kPersonListNameRect];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    [_nameLabel setTextColor:[UIColor blackColor]];
    [_nameLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_nameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_nameLabel];
    
    _signLabel = [[UILabel alloc] initWithFrame:kPersonListSignRect];
    [_signLabel setBackgroundColor:[UIColor clearColor]];
    [_signLabel setTextColor:[UIColor blackColor]];
    [_signLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_signLabel setTextAlignment:NSTextAlignmentLeft];
    [_signLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.contentView addSubview:_signLabel];
    
    _attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_attentionButton addTarget:self action:@selector(attentionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_attentionButton setFrame:kPersonListButtonRect];
    [_attentionButton setBackgroundColor:[UIColor clearColor]];
    [_attentionButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.contentView addSubview:_attentionButton];
}

- (void)setObject:(id)item
{
    if (item) {
        
        _dto = item;
        [_nameLabel setText:_dto.name];
        [_signLabel setText:_dto.description];
        
        if (_dto.accountID) {
            if (_dto.isFriends) {
                [_attentionButton setImage:[UIImage imageNamed:@"cell_did_add"] forState:UIControlStateNormal];
                [_attentionButton setBackgroundImage:[[UIImage imageNamed:@"person_back_blue"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateNormal];
            }else {
                [_attentionButton setImage:[UIImage imageNamed:@"cell_add"] forState:UIControlStateNormal];
                [_attentionButton setBackgroundImage:[[UIImage imageNamed:@"invite"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateNormal];
            }
            [_avatarImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerUrl2], _dto.mImageData]]];
        }else {
            [_avatarImageView setImageWithURL:[NSURL URLWithString:_dto.sinaHeaderPhotoPath] placeholderImage:nil];
            [_attentionButton setBackgroundImage:[[UIImage imageNamed:@"person_back_blue"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateNormal];
            [_attentionButton setImage:nil forState:UIControlStateNormal];
            [_attentionButton setTitle:@"邀请" forState:UIControlStateNormal];
        }
    }else {
        
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 55.;
}


- (void)attentionButtonClicked:(id)sender
{
    LBFileClient* client = [LBFileClient sharedInstance];
    if (_dto.accountID) {
        if (_dto.isFriends) {
            [_attentionButton setImage:[UIImage imageNamed:@"cell_add"] forState:UIControlStateNormal];
            [_attentionButton setBackgroundImage:[[UIImage imageNamed:@"invite"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateNormal];
            [client unFollow:_dto.accountID cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(unfollowDidFinished:) selectorError:@selector(unfollowFailed:)];
        }else {
            [_attentionButton setImage:[UIImage imageNamed:@"cell_did_add"] forState:UIControlStateNormal];
            [_attentionButton setBackgroundImage:[[UIImage imageNamed:@"person_back_blue"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateNormal];
            [client follow:_dto.accountID  cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(followDidFinished:) selectorError:@selector(followDidFailed:)];
        }
        _dto.isFriends = !_dto.isFriends;
    }else {
        LBEditSignViewController* lvc = [[LBEditSignViewController alloc] init];
        lvc.sinaFriendName = _dto.name;
        lvc.isInviteSinaFriend = YES;
        UINavigationController* nav = [UINavigationController getTopNavigation];
        [nav pushViewController:lvc animated:YES];
    }
}

- (void)cellDidClicked:(id)sender
{
    if (_dto.accountID) {
    LBPersonDetailViewController *dvc = [[LBPersonDetailViewController alloc] initWithAccountID:_dto.accountID];
        UINavigationController* controller = [UINavigationController getTopNavigation];
        [controller pushViewController:dvc animated:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView* view = [touch view];
    if ([view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - request delegate

- (void)unfollowDidFinished:(id)sender
{
    
}

- (void)unfollowFailed:(id)sender
{
    
}

- (void)followDidFinished:(id)sender
{
    NSString* str = [NSJSONSerialization JSONObjectWithData:sender options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"follow:%@", str);
}

- (void)followDidFailed:(id)sender
{
    
}

@end
