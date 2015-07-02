//
//  LBChannelView.m
//  lebo
//
//  Created by yong wang on 13-3-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBChannelView.h"
#import "Global.h"
#import "LBChannelListViewController.h"
#define CHANNELVIEW_WIDTH 106.f

@implementation LBChannelView
@synthesize channelImageView = _channelImageView;
@synthesize channelNameLabel = _channelNameLabel;


+ (CGFloat)rowHeightForObject{
    return  CHANNELVIEW_WIDTH;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createSubview];
    }
    return self;
}

- (void)createSubview
{
    // TODO: this is nothing but a poor man's solution
    // may want to turn to three20's mighty TTStyledTextLabel later on.
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];

    self.userInteractionEnabled = YES;

    self.channelImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CHANNELVIEW_WIDTH - 170/2)/2, (CHANNELVIEW_WIDTH - 152/2 - 18)/2, 170/2, 152/2)];
    [_channelImageView.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [_channelImageView setBackgroundColor:[UIColor clearColor]];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setFrame:CGRectMake(0, 0, CHANNELVIEW_WIDTH, CHANNELVIEW_WIDTH)];
    //[button addSubview:_channelImageView];
    [_button setUserInteractionEnabled:YES];
    [_button addTarget:self action:@selector(channelBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    //[_button setBackgroundColor:[UIColor redColor]];
    [_button.layer addSublayer:_channelImageView.layer];
    [self addSubview:_button];
    
    self.channelNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 106 - 24, CHANNELVIEW_WIDTH, 20)];
    _channelNameLabel.centerX = _channelImageView.centerX;
    _channelNameLabel.font = [UIFont boldSystemFontOfSize:14];
    _channelNameLabel.textAlignment = UITextAlignmentCenter;
    _channelNameLabel.textColor = [UIColor whiteColor];
    _channelNameLabel.backgroundColor = [UIColor clearColor];
    [_button addSubview:_channelNameLabel];
}

- (UIImage *)getRandomColor:(int)fromValue toValue:(int)toValue
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"channelBackGround_%d",(uint)(fromValue + (arc4random() % (toValue - fromValue + 1)))]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setObject:(id)item {
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        
        NSString *channelImageURL = [item objectForKey:@"channelImageUrl"];
        NSString *channelName = [item objectForKey:@"channel"];
        NSString *colorTag = [item objectForKey:@"colorTag"];
        if (channelImageURL && channelName && colorTag) {
            [_channelImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerBaseUrl], channelImageURL]]];
            [_channelNameLabel setText:[NSString stringWithFormat:@"#%@#",channelName]];
            [_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"channel_back_%@.png", colorTag]] forState:UIControlStateNormal];
            [_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"channel_back_%@_select.png", colorTag]] forState:UIControlStateHighlighted];
        }
        NSLog(@"channelURL %@", [NSString stringWithFormat:@"%@%@",[Global getServerBaseUrl],channelImageURL]);
    }
}

- (void)channelBtnTapped:(id)sender
{
    LBChannelListViewController *channelListViewController = [[LBChannelListViewController alloc] initVithChannelTitle:_channelNameLabel.text];
    //LBChannelListViewController *channelListViewController = [[LBChannelListViewController alloc] initVithChannelTitle:@"测试"];
    [selected_navigation_controller() pushViewController:channelListViewController animated:YES];
}

@end
