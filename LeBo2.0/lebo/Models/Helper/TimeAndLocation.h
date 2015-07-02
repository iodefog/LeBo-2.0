//
//  TimeAndLocation.h
//  LeBo
//
//  Created by Mac on 12-12-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeAndLocation : NSObject

+ (NSString *)time:(NSDate *)time;
+ (NSString *)location:(NSString *)location;

@end
