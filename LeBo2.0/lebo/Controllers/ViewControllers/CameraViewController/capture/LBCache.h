//
//  LBCache.h
//  lebo
//
//  Created by 乐播 on 13-3-26.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <Foundation/Foundation.h>
//基于path的cache 
@interface LBCache : NSCache

+ (id)sharedInstance;

- (UIImage *)cacheImageForPath:(NSString *)path;


- (NSData *)cacheForPath:(NSString *)path;

@end
