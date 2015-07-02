//
//  LBActivityIndicatorView.m
//  LeBo
//
//  Created by 乐播 on 13-3-18.
//
//

#import "LBActivityIndicatorView.h"

@implementation LBActivityIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)addAnimation
{
    _animationCount ++;
    if(_animationCount>0 && ![self isAnimating])
        [self startAnimating];
}

- (void)reduceAnimation
{
    _animationCount = MAX(_animationCount-1, 0);
    if(_animationCount<1 && [self isAnimating])
        [self stopAnimating];
}

- (void) stopAnimating
{
    _animationCount = 0;
    [super stopAnimating];
}
@end
