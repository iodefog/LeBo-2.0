//
//  DTOBase.h
//  mcare-core
//
//  Created by sam on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTOBase : NSObject <NSCopying> {
    NSString *error;
}



- (id)init:(NSString *)dict;
- (BOOL)parse:(NSDictionary *)dict;
- (BOOL)parse2:(NSDictionary *)result;
- (NSDictionary *)JSON;

- (NSInteger)getIntValue:(NSNumber *)num;
- (float)getFloatValue:(NSNumber *)num;
- (BOOL)getBoolValue:(NSNumber *)num;
- (NSString *)getStrValue:(NSString *)str;
- (NSString *)toParam;
- (NSString *)getError;

@end
