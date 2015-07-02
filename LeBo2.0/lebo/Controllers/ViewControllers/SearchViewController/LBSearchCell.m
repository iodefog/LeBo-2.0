//
//  LBSearchCell.m
//  lebo
//
//  Created by King on 13-4-19.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBSearchCell.h"
#import "LBSearchUserView.h"
#import "LBSearchViewController.h"

@implementation LBSearchCell
@synthesize searchUserView = _searchUserView;
@synthesize searchChannelView = _searchChannelView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([reuseIdentifier isEqualToString:@"1"]) {
            self.searchUserView = [[LBSearchUserView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
            [self.contentView addSubview:_searchUserView];
        } else {
            self.searchChannelView = [[LBSearchChannelView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
            [self.contentView addSubview:_searchChannelView];
        }
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setObject:(id)item topViewIndex:(uint)topViewIndex
{
    if (topViewIndex) {
        [_searchUserView setObject:item];
    } else
        [_searchChannelView setObject:item];
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [LBSearchUserView rowHeightForObject:item];
}

@end
