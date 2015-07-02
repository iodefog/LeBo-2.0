//
//  LBShareBtn.m
//  lebo
//
//  Created by 乐播 on 13-4-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBShareBtn.h"
#import <objc/message.h>
@implementation LBShareBtn

- (id)initWithFrame:(CGRect)frame
{
    NSAssert(NO, @"使用 init 方法");
    self = [super initWithFrame:frame];
    if (self) {
                    
    }
    return self;
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 147, 44)];
    if(self)
    {
        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_backgroundView];
        
        _highlightedView = [[UIImageView alloc] initWithFrame:_backgroundView.bounds];
        _highlightedView.alpha = 0;
        [_backgroundView addSubview:_highlightedView];
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 23, 23)];
        [_backgroundView addSubview:_iconView];
        
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right+12 , 11, 80, 22)];
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.font = [UIFont getButtonFont];
        [_backgroundView addSubview:_titleLable];
        self.selected = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    self.selected = _selected;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if(selected == YES)
    {
        _titleLable.textColor = RGB(120,168,207);
        _iconView.image = self.selectedIcon;
    }
    else
    {
        _titleLable.textColor = [UIColor grayColor];
        _iconView.image = self.icon;
    }
}

- (void)setIcon:(UIImage *)icon
{
    _icon = icon;
    if(_selected == NO)
    {
        _iconView.image = _icon;
    }
}

- (void)setSelectedIcon:(UIImage *)selectedIcon
{
    _selectedIcon = selectedIcon;
    if(_selected == YES)
    {
        _iconView.image = _selectedIcon;
    }
}

- (void)setBackgroundImg:(UIImage *)backgroundImg
{
    _backgroundImg = backgroundImg;
    _backgroundView.image = backgroundImg;
}

- (void)setHighlightedBackgroundImg:(UIImage *)highlightedImg
{
    _highlightedBackgroundImg = highlightedImg;
    _highlightedView.image = highlightedImg;
}

- (void)addTarget:(id)target forSelector:(SEL)selector
{
    _target = target;
    _selector = selector;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[UIView animateWithDuration:0.0 animations:^{
        _highlightedView.alpha = 1;
    //}];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.5 animations:^{
        _highlightedView.alpha = 0;
    }];

    if([_target respondsToSelector:_selector])
    {
        objc_msgSend(_target, _selector,self);
        //[_target performSelector:_selector withObject:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.5 animations:^{
         _highlightedView.alpha = 0;
    }];
}
@end
