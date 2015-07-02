//
//  LBTextView.m
//  Tudou
//
//  Created by zhang jiangshan on 13-1-5.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "LBTextView.h"

@implementation LBTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clearsContextBeforeDrawing = YES;
        self.opaque = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
        self.returnKeyType = UIReturnKeyDone;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)textDidChange:(NSNotification *)sender
{
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if(self.text.length == 0)
    {
//        CGSize size = [_placeHolder sizeWithFont:self.font constrainedToSize:rect.size];
        UIColor * color = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1];
        [color set];
        [_placeholder drawAtPoint:CGPointMake(8, 8) withFont:self.font];
    }
}


@end
