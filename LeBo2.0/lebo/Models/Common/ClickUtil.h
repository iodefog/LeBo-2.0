//
//  ClickUtil.h
//  mcare-core
//
//  Created by sam on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClickUtil : NSObject

+ (void)startWithAppkey:(NSString *)appid reportPolicy:(NSInteger)reportPolicy channelId:(NSString *)channelId;
+ (void)clickEvent:(NSString *)event;

@end
