//
//  LBCache.m
//  lebo
//
//  Created by 乐播 on 13-3-26.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBCache.h"

@implementation LBCache

+ (id)sharedInstance
{
    static LBCache *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (UIImage *)cacheImageForPath:(NSString *)path
{
    id obj = [self objectForKey:path];
    if(!obj)
    {
        if([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            UIImage * img = [[UIImage alloc] initWithContentsOfFile:path];
            if(img)
                [self setObject:img forKey:path];
            obj = img;
        }
    }
    return obj;
}

- (NSData *)cacheForPath:(NSString *)path
{
    id obj = [self objectForKey:path];
    if(!obj)
    {
        if([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            NSData * data = [[NSData alloc] initWithContentsOfFile:path];
            if(data)
                [self setObject:data forKey:path];
            obj = data;
        }
    }
    return obj;
}

@end
