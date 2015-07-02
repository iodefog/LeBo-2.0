//
//  LBView.m
//  cameraDemo
//
//  Created by 乐播 on 13-3-6.
//  Copyright (c) 2013年 乐播. All rights reserved.
//

#import "LBView.h"

@implementation LBView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if([self.delegate respondsToSelector:@selector(drawView:)])
        [self.delegate drawView:self];
}

- (void)layoutSubviews
{
    if([self.delegate respondsToSelector:@selector(didLayoutSubviews:)])
        [self.delegate didLayoutSubviews:self];
}


@end
