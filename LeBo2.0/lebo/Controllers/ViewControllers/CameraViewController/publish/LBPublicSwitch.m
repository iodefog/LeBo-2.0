//
//  LBPublicSwitch.m
//  lebo
//
//  Created by 乐播 on 13-4-1.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBPublicSwitch.h"

@implementation LBPublicSwitch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImage * bgImage = Image(@"camera_segment_share.png");
        self.image = bgImage;
        self.userInteractionEnabled = YES;
        UIImage * btnImg = Image(@"camera_btn_share.png");
        _btn = [[UIImageView alloc] initWithImage:btnImg];
        [_btn setCenter:CGPointMake(_btn.width/2, self.height/2)];
        [self addSubview:_btn];
    }
    return self;
}

- (id)init
{
    UIImage * bgImage = Image(@"camera_segment_share.png");
    return [self initWithFrame:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
}

- (BOOL)isOn
{
    if(_btn.center.x<self.width/2)
        return NO;
    else
        return YES;
        
}

- (void)setOn:(BOOL)on
{
    if(self.on != on)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        if(_btn.center.x<self.width/2)
            _btn.centerX = self.width-_btn.width/2;
        else
            _btn.centerX = _btn.width/2;
        [UIView commitAnimations];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(point.x>self.width/2.0)
        self.on = YES;
    else
        self.on = NO;
}

@end
