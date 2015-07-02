//
//  ImageCenter.h
//  TestTable
//
//  Created by sam on 12-12-1.
//  Copyright (c) 2012年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    PhotoSource_Bundle,
    PhotoSource_Path,
    PhotoSource_Named,
    PhotoSource_All
} Photo_Source;

@interface ImageCenter : NSObject {
    NSMutableDictionary *bundleDict;
    NSMutableDictionary *pathDict;
    NSMutableDictionary *nameDict;
}

+ (UIImage *)getBundleImageFromName:(NSString *)name;
+ (UIImage *)getImage:(NSString *)path;
+ (UIImage *)getBundleImage:(NSString *)name;
+ (UIImage *)getNamedImage:(NSString *)name;
+ (UIImage *)getImage:(NSString *)path source:(NSInteger)source;
+ (UIImage *)getImageFromPath:(NSString *)path source:(NSInteger)source;
+ (NSInteger)getSizeCopies;

+ (void)releaseImage:(NSString *)path;
+ (void)releaseImages:(NSString *)key source:(NSInteger)source;

@end
