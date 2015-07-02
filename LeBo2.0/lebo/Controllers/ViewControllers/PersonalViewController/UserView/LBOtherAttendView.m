//
//  LBOtherAttendView.m
//  lebo
//
//  Created by lebo on 13-3-31.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBOtherAttendView.h"

@implementation LBOtherAttendView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
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

- (void)setObject:(id)item
{
    if (item) {
        _personDto = [[AttendAndFansDTO alloc] init];
        [_personDto parse2:item];
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerUrl2], _personDto.AccountPhotoUrl]] placeholderImage:nil];
        [self.nameLabel setText:_personDto.DisplayName];
        [self.signLabel setText:_personDto.Sign];
        if (_personDto.Attended == 0) {
            [self.attentionButton setImage:[UIImage imageNamed:@"cell_add"] forState:UIControlStateNormal];
            [self.attentionButton setBackgroundImage:[[UIImage imageNamed:@"invite"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 8, 14, 8)] forState:UIControlStateNormal];
            [self.attentionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else {
            [self.attentionButton setImage:[UIImage imageNamed:@"cell_did_add"] forState:UIControlStateNormal];
            [self.attentionButton setBackgroundImage:[[UIImage imageNamed:@"btn_followed_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateNormal];
            [self.attentionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [self.attentionButton setHidden:NO];
        if ([_personDto.AccountID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"account"] ]) {
            [self.attentionButton setHidden:YES];
        }
    }
}

- (void)updateItem
{
    [self.dataDict setObject:[NSString stringWithFormat:@"%d", _personDto.Attended] forKey:@"attended"];
}

#pragma mark - button click

- (void)attentionButtonClicked:(id)sender
{
    LBFileClient* client = [LBFileClient sharedInstance];
    if (_personDto.Attended == 0) {
        _personDto.Attended = 1;
        [self.attentionButton setImage:[UIImage imageNamed:@"cell_did_add"] forState:UIControlStateNormal];
        [self.attentionButton setBackgroundImage:[[UIImage imageNamed:@"btn_followed_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateNormal];
        [client follow:_personDto.AccountID cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(followDidFinished:) selectorError:@selector(followDidFailed:)];
    }else {
        _personDto.Attended = 0;
        [self.attentionButton setImage:[UIImage imageNamed:@"cell_add"] forState:UIControlStateNormal];
        [self.attentionButton setBackgroundImage:[[UIImage imageNamed:@"invite"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 8, 14, 8)] forState:UIControlStateNormal];
        [client unFollow:_personDto.AccountID cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(unFollowDidFinished:) selectorError:@selector(unFollowDidFailed:)];
    }
    [self updateItem];
}

- (void)cellDidClicked:(id)sender
{
    if ([_personDto.AccountID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"account"]]) {
        LBPersonalViewController* lvc = [[LBPersonalViewController alloc] initWithBackbuttonAndPersonID:_personDto.AccountID];
        UINavigationController* controller = [UINavigationController getTopNavigation];
        [controller pushViewController:lvc animated:YES];
    }else {
        LBPersonDetailViewController *dvc = [[LBPersonDetailViewController alloc] initWithAccountID:_personDto.AccountID];
        UINavigationController* controller = [UINavigationController getTopNavigation];
        [controller pushViewController:dvc animated:YES];
    }
}

#pragma mark - request delegate

- (void)followDidFinished:(id)sender
{
    
}

- (void)followDidFailed:(id)sender
{
    
}

- (void)unFollowDidFinished:(id)sender
{
    
}

- (void)unFollowDidFailed:(id)sender
{
    
}

@end
