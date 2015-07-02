//
//  TimeAndLocation.m
//  LeBo
//
//  Created by Mac on 12-12-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TimeAndLocation.h"

@implementation TimeAndLocation


+ (NSString *)time:(NSDate *)time {
    // time是格林尼治时间，now也是格林尼治时间
    NSTimeInterval dt = -[time timeIntervalSinceNow];
    long long int d = (long long int) dt;
    
    NSString *timeStr = nil;
    if (d >= 60*60*24*7) {
        timeStr = [NSString stringWithFormat:@"%lld周前", d / (60*60*24*7)] ;
    } else if (d >= 60*60*24) {
        timeStr = [NSString stringWithFormat:@"%lld天前", d / (60*60*24)] ;   
    } else if (d >=60*60) {
        timeStr = [NSString stringWithFormat:@"%lld小时前", d / (60*60)];
    } else if (d >= 60){
        timeStr = [NSString stringWithFormat:@"%lld分钟前", d / 60];
    } else {
        timeStr = @"1分钟前";
    }
    return timeStr;
}

+ (NSString *)location:(NSString *)location {
    double i = [location doubleValue] / 1000.0;
    if (i < 0.0f) {
        i = 0;
    }
    NSLog(@"i %f",i);
    NSString *myLocation = [NSString string];
    if (i >= 100) {
        myLocation = [[NSString stringWithFormat:@"%0.0f", i] stringByAppendingString: @"km"];
    }else if (i < 100) {
        myLocation = [[NSString stringWithFormat:@"%0.2f", i] stringByAppendingString:@"km"];
    }
    NSLog(@"%@", myLocation);
    return myLocation;
}

@end
