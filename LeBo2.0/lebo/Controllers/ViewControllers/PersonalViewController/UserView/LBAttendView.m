//
//  LBAttendView.m
//  lebo
//
//  Created by lebo on 13-3-29.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBAttendView.h"

@implementation LBAttendView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _personDto = [[AttendAndFansDTO alloc] init];
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
    //NSLog(@"----item:%@", item);
    if (item) {
        
        [_personDto parse2:item];
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerUrl2], _personDto.AccountPhotoUrl]] placeholderImage:nil];
        [self.nameLabel setText:_personDto.DisplayName];
        [self.signLabel setText:_personDto.Sign];
    }
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

@end
