//
//  LBProgressBar.m
//  lebo
//
//  Created by 乐播 on 13-4-7.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBProgressBar.h"

@implementation LBProgressBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, self.height)];
        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_backgroundView setClipsToBounds:YES];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_backgroundView];
        [_backgroundView addSubview:_barView];
        [self setProgress:0];
    }
    return self;
}

- (void)layoutSubviews
{
    _barView.frame = CGRectMake(0, 0, _backgroundView.width*_progress, self.height);
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    _barView.width = progress * _backgroundView.width;
}

- (float)progress
{
    return _progress;
}

- (void)setBackgroundImage:(UIImage *)image
{
    _backgroundView.image = image;
}

- (void)setProgressImage:(UIImage *)image
{
    _barView.image = image;
    _barView.height = image.size.height;
    _barView.centerY = _backgroundView.height/2.0;
}

- (void)setBarColor:(UIColor *)color
{
    _barView.backgroundColor = color;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundView.backgroundColor = backgroundColor;
}
@end
