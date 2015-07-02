//
//  LBMessageCell.m
//  lebo
//
//  Created by yong wang on 13-3-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBMessageCell.h"
#import "LBMessageView.h"
#import "LBPersonalViewController.h"
#import "LBVideoViewController.h"
#import "LBEditSignViewController.h"

@implementation LBMessageCell
@synthesize messageView = _messageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.messageView = [[LBMessageView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        [self.contentView addSubview:_messageView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setObject:(id)item
{
    if(_messageView)
    {
        [_messageView setObject:item];
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [LBMessageView rowHeightForObject:item];
}

@end
