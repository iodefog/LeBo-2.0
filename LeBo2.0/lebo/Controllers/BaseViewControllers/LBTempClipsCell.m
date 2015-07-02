//
//  LBTempClipsCell.m
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBTempClipsCell.h"
#import "LBTempClipView.h"

@implementation LBTempClipsCell
@synthesize clipView = _clipView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipView = [[LBTempClipView alloc] initWithFrame:CGRectMake(0, 12, 320, 0)];
        [self.contentView addSubview:_clipView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)playVideo:(int)rowCell
{
    if(_clipView)
    {
        [_clipView playVideo:rowCell];
    }
}

- (void)setObject:(id)item
{
    if(_clipView)
    {
        [_clipView setObject:item];
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [LBTempClipView rowHeightForObject:item];
}

@end
