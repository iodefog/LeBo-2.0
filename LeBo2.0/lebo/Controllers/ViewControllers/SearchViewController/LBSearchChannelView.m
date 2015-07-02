//
//  LBSearvhChannelView.m
//  lebo
//
//  Created by King on 13-4-19.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBSearchChannelView.h"
#import "LBChannelListViewController.h"

@implementation LBSearchChannelView
@synthesize channelLabel = _channelLabel;
@synthesize lineImageView = _lineImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    self.channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 50)];
    [_channelLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_channelLabel];
    
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    [_lineImageView setImage:[[UIImage imageNamed:@"sperateLine"] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
    [self addSubview:_lineImageView];
    
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 44.;
}

- (void)setObject:(id)item
{
    _channelLabel.text = [NSString stringWithFormat:@"#%@#", item];
}

- (void)tapGesture:(UITapGestureRecognizer*)gesture
{
    LBChannelListViewController *channelListViewController = [[LBChannelListViewController alloc] initVithChannelTitle:_channelLabel.text];
    [selected_navigation_controller() pushViewController:channelListViewController animated:YES];
}

@end
