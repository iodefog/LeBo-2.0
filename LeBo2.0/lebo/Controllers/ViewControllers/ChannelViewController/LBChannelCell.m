//
//  LBTempChannelCell.m
//  lebo
//
//  Created by yong wang on 13-3-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBChannelCell.h"
#import "LBChannelView.h"

@implementation LBTempChannelCell
@synthesize channelViewArray = _channelViewArray;

static const CGFloat dx = 106.f;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.channelViewArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i++) {
            LBChannelView *channelView = [[LBChannelView alloc] initWithFrame:CGRectMake(i*(dx+1), 0, dx, dx)];
            [channelView setHidden:YES];
             [_channelViewArray addObject:channelView];
            [self.contentView addSubview:channelView];
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setObject:(id)item
{
    if(item == nil)
        return;
    
    for(int i = 0; i < [item count]; i++)
    {
        if([item count] - i > 0){
            LBChannelView *channelView = [_channelViewArray objectAtIndex:i];
            if(channelView)
            {
                [channelView setHidden:NO];
                [channelView setObject:[item objectAtIndex:i]];
            }
        }
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [LBChannelView rowHeightForObject];
}

@end
