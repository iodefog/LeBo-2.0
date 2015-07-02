//
//  LBFansView.m
//  lebo
//
//  Created by lebo on 13-3-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBFansView.h"

@implementation LBFansView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _friendDto = [[AttendAndFansDTO alloc] init];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self customCell];
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

- (void)customCell
{
    [self.attentionButton setHidden:YES];
}

- (void)setObject:(id)item
{
    if (item) {
        [_friendDto parse2:item];
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerUrl2], _friendDto.AccountPhotoUrl]] placeholderImage:nil];
        //NSLog(@"------dot:%@--%@--%@", [NSURL URLWithString:_friendDto.AccountPhotoID], _friendDto.DisplayName, _friendDto.Sign);
        [self.nameLabel setText:_friendDto.DisplayName];
        [self.signLabel setText:_friendDto.Sign];
   }
}

#pragma mark - button click

- (void)cellDidClicked:(id)sender
{
    if ([_friendDto.AccountID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"account"]]) {
        LBPersonalViewController* lvc = [[LBPersonalViewController alloc] initWithBackbuttonAndPersonID:_friendDto.AccountID];
        UINavigationController* controller = [UINavigationController getTopNavigation];
        [controller pushViewController:lvc animated:YES];
    }else {
        LBPersonDetailViewController *dvc = [[LBPersonDetailViewController alloc] initWithAccountID:_friendDto.AccountID];
        UINavigationController* controller = [UINavigationController getTopNavigation];
        [controller pushViewController:dvc animated:YES];
    }
}



@end
