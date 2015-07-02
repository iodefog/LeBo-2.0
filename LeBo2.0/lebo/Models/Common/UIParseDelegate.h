//
//  UIParseDelegate.h
//  mcare-core
//
//  Created by sam on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIParseDelegate

- (void)parseJson:(NSString *)dict method:(NSString *)method;
- (void)responseError:(NSString *)content method:(NSString *)method;

@end
