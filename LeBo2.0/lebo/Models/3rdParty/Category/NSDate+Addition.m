//
//  NSDate+Addition.m
//  lebo
//
//  Created by 乐播 on 13-3-25.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate(Addition)

+ (NSString *)getFormatTime:(NSDate *)date format:(NSString *)format
{
    NSString *time = @"";
    if (date != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        time = [dateFormatter stringFromDate:date];
        if (time == nil) {
            time = @"";
        }
    } else {
        //time = [NSNull null];
        time = @"";
    }
    return time;
}

+ (NSString *)getFormatTime:(NSDate *)date
{
    return [self getFormatTime:date format:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate *)convertTime:(NSString *)time format:(NSString *)format
{
    NSDate *time2 = nil;
    if ((NSObject *)time != [NSNull null]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        time2 = [dateFormatter dateFromString:time];
    } else {
        
    }
    return time2;
}

+ (NSDate *)convertTime:(NSString *)time
{
    return [self convertTime:time format:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate *)convertTimeFromNumber:(NSNumber *)time
{
    NSDate *time2 = nil;
    if ((NSObject *)time != [NSNull null] && time != nil) {
        time2 = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    }
    return time2;
}

+ (NSDate *)convertTimeFromNumber2:(NSNumber *)time
{
    NSDate *time2 = nil;
    NSDate *rTime = nil;
    if ((NSObject *)time != [NSNull null] && time != nil) {
        time2 = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
        NSString *s = [self getFormatTime: time2];
        rTime = [self convertTime: s];
    }
    return rTime;
}

+ (NSString *)convertToDay:(NSDate *)date
{
    return [self getFormatTime:date format:@"yyyy-MM-dd"];
}

+ (NSNumber *)convertNumberFromTime:(NSDate *)time
{
    NSNumber *time2 = nil;
    if ((NSObject *)time != [NSNull null] && [time isKindOfClass:[NSDate class]]) {
        long long l = [time timeIntervalSince1970];
        time2 = [NSNumber numberWithDouble:l];
    } else {
        time2 = [NSNumber numberWithDouble:0];
    }
    return time2;
    
}

+ (NSString *)getDisplayTime:(NSDate *)date
{
    NSString *str = nil;
    NSTimeInterval interval = 0-[date timeIntervalSinceNow];
    if (interval > 24*60*60) {
        str = [NSString stringWithFormat:@"%d天前", (int)(interval/(24*60*60))];
    } else if (interval > 60*60) {
        str = [NSString stringWithFormat:@"%d小时前", (int)(interval/(60*60))];
    } else if (interval > 60*5) {
        str = [NSString stringWithFormat:@"%d分钟前", (int)(interval/60)];
    } else {
        str = @"刚刚";
    }
    return str;
}

+ (NSDateComponents *)getComponenet:(NSDate *)date
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | kCFCalendarUnitMinute;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    return comps;
}

@end
