//
//  NSString+Addition.h
//  lebo
//
//  Created by 乐播 on 13-3-25.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Addtion)

+ (NSString *)getMD5ForStr:(NSString *)str;

- (NSString *)md5Value;

+ (NSInteger)countWeiboTextNum:(NSString *) str;

- (NSString *)getWeiBoTextWithLength:(int)length;
@end
