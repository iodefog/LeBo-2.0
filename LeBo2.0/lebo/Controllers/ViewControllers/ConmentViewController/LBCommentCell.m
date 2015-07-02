//
//  LBCommentCell.m
//  lebo
//
//  Created by Zhuang Qiang on 3/28/13.
//  Copyright (c) 2013 lebo. All rights reserved.
//

#import "LBCommentCell.h"

@implementation LBCommentCell
@synthesize commentView = _commentView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.commentView = [[LBCommentView alloc] initWithFrame: CGRectZero];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview: _commentView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setObject:(id)item
{
    if(_commentView)
    {
        [_commentView setObject:item];
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [LBCommentView rowHeightForObject:item];
}

@end
