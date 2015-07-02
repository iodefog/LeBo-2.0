//
//  LBPersonLoadingView.m
//  lebo
//
//  Created by lebo on 13-4-10.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBPersonLoadingView.h"

@implementation LBPersonLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addLoadingView];
    }
    return self;
}

- (void)addLoadingView
{
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity startAnimating];
    [activity setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2-68)];
    [activity setTag:30];
    [self addSubview:activity];
    
    loadingError = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [loadingError setImage:[UIImage imageNamed:@"person_nodata_dark"]];
    [loadingError setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2-65)];
    [loadingError setBackgroundColor:[UIColor clearColor]];
    [loadingError setTag:31];
    [loadingError setHidden:YES];
    [self addSubview: loadingError];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 16)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"网络异常，请稍后再试"];
    [label setTextColor:[UIColor blackColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2-15)];
    [label setFont:[UIFont getButtonFont]];
    [label setTag:32];
    [label setHidden:YES];
    [self addSubview:label];
}

//no data 隐藏activity，展示error文字和label文字
- (void)noData
{
    [activity setHidden:YES];
    [loadingError setHidden:NO];
    [label setHidden:NO];
}

- (void)setMaskViewBackgroundColor:(UIColor*)color
{
    [self setBackgroundColor:color];
}

- (void)changeActivityCenter:(CGPoint)center
{
    [activity setCenter:center];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
