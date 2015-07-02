//
//  LBChannelSelectedCell.m
//  lebo
//
//  Created by 乐播 on 13-3-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBChannelSelectedCell.h"

@implementation LBChannelSelectedCell

- (void)setObject:(id)item
{
    NSString * text = [item valueForKey:@"channel"];
    self.textLabel.text = [NSString stringWithFormat:@"#%@",text];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(context, 0, self.height);
    CGContextAddLineToPoint(context, self.width, self.height);
    CGContextStrokePath(context);
}
@end
