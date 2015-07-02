//
//  NSStringAdditions.m
//  Wall
//
//  Created by 罗永兴 on 12-6-2.
//  Copyright (c) 2012年 草莓. All rights reserved.
//

#import "NSStringAdditions.h"

@implementation NSString (EKBAdditons)

- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)width {
    return [self heightWithFont:font constrainedWidth:width lineBreakMode:UILineBreakModeTailTruncation];
}

- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)width numberOfLines:(NSUInteger)numberOfLines{
    
    CGFloat lineHeight = font.lineHeight * numberOfLines;
    
    CGFloat realHeight = [self heightWithFont:font constrainedWidth:width lineBreakMode:UILineBreakModeTailTruncation];
    
    return MIN(lineHeight, realHeight);
}

- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)width lineBreakMode:(UILineBreakMode)lineBreakMode {
    return [self sizeWithFont:font constrainedToSize:CGSizeMake(width, 10000) lineBreakMode:lineBreakMode].height;
}

@end
