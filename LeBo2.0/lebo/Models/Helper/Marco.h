//
//  Marco.h
//  Youku
//
//  Created by zjs on 5/16/12.
//  Copyright (c) 2012 Lebo.com inc. All rights reserved.
//

/*常用的宏*/

#define StatusBar_Height 20

//日志
#ifdef DEBUG
#define DLog(format, ...) NSLog(format, ## __VA_ARGS__)
#define DLogRect(r) NSLog(@"(%.1fx%.1f)-(%.1fx%.1f)", r.origin.x, r.origin.y, r.size.width, r.size.height)
#else
#define DLog(format, ...)
#define DLogRect(r)
#endif

#define DLogPlace(x) DLog(@"**********\n*%@\n*%s\n*%i\n*loadData failed\n**********",NSStringFromClass([self class]),__FUNCTION__,__LINE__)

//内存
#define RELEASE_SAFELY(p) { [p release]; p = nil; }

//角度变换
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

