//
//  LBTopCell.m
//  lebo
//
//  Created by King on 13-4-18.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBTopCell.h"
#import "LBTopView.h"

@implementation LBTopCell
@synthesize topView = _topView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.topView = [[LBTopView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        [self.contentView addSubview:_topView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setObject:(id)item topViewIndex:(uint)topViewIndex row:(int)row
{
    if(_topView)
    {
        [_topView setObject:item topViewIndex:topViewIndex row:row];
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [LBTopView rowHeightForObject:item];
}

@end
