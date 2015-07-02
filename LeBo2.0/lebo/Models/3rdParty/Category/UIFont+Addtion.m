//
//  UIFont+Addtion.m
//  Tudou
//
//  Created by zhang jiangshan on 12-12-4.
//  Copyright (c) 2012年 Lebo.com inc. All rights reserved.
//

#import "UIFont+Addtion.h"

@implementation UIFont (Addition)

+(id) numberFontWithSize:(float)size
{
    return [UIFont fontWithName:@"STHeitiSC-Medium" size:size];
}

+ (UIFont *)getButtonFont
{
    return [UIFont systemFontOfSize:14];
}

+ (UIFont *)getNormalFont
{
    return [UIFont systemFontOfSize:12];
}
@end
