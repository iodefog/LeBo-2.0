//
//  LBCameraTool.h
//  LeBo
//
//  Created by 乐播 on 13-3-18.
//
//

#import <Foundation/Foundation.h>
#import "LBCache.h"
#define Movie_Width 480.

@interface LBCameraTool : NSObject
//主要函数
+ (UIImage *)getThumbImageWithPath:(NSString *)videoPath;

//工具函数
+ (NSString *)getThumbPathWithPath:(NSString *)videoPath;

+ (UIImage *)createThumbImageWithPath:(NSString *)videoPath;

+ (NSString *)videoPathWithName:(NSString *)name;

+ (NSString *)videoTempPathWithName:(NSString *)name; 

+ (NSString *)getFormalPathFromTempPath:(NSString *)tempPath;

+ (NSString *)getTempPathFromFormalPath:(NSString *)formalPath;

+ (NSString *)getCachePathForRemotePath:(NSString *)path;

+ (BOOL)fileExist:(NSString *)file;

+ (void)moveToFormalPath:(NSString *)tempPath;

+ (void)clearTemps;


@end
