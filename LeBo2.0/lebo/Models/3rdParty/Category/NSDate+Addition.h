//
//  NSDate+Addition.h
//  lebo
//
//  Created by 乐播 on 13-3-25.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Addition)

+ (NSString *)getFormatTime:(NSDate *)date format:(NSString *)format;
+ (NSString *)getFormatTime:(NSDate *)date;
+ (NSDate *)convertTime:(NSString *)time;
+ (NSDate *)convertTime:(NSString *)time format:(NSString *)format;
+ (NSDate *)convertTimeFromNumber:(NSNumber *)time;
// 矫正时区问题
+ (NSDate *)convertTimeFromNumber2:(NSNumber *)time;
+ (NSString *)convertToDay:(NSDate *)date;
+ (NSNumber *)convertNumberFromTime:(NSDate *)time;
+ (NSString *)getDisplayTime:(NSDate *)date;
+ (NSDateComponents *)getComponenet:(NSDate *)date;

@end
