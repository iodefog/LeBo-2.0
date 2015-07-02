//
//  UIFont+Addtion.h
//  Tudou
//
//  Created by zhang jiangshan on 12-12-4.
//  Copyright (c) 2012年 Lebo.com inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIFont (Addition)

+(id) numberFontWithSize:(float)size;//某些数字用此字体

+ (UIFont *)getButtonFont;

+ (UIFont *)getNormalFont;

@end
