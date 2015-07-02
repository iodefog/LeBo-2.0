//
//  LBCameraTool.m
//  LeBo
//
//  Created by 乐播 on 13-3-18.
//
//

#import "LBCameraTool.h"
#import <AVFoundation/AVFoundation.h>
#import "FileUtil.h"
#import "ImageCenter.h"
@implementation LBCameraTool

+ (NSString *)getThumbPathWithPath:(NSString *)videoPath
{
    NSString * path = [self getFormalPathFromTempPath:videoPath];
    if(!path)
        return nil;
    NSURL * url = [NSURL fileURLWithPath:path];
    NSString * pathExtension = [url pathExtension];
    NSRange  range = [path rangeOfString:pathExtension options:NSBackwardsSearch];
    NSString * imagePath = [path stringByReplacingCharactersInRange:range withString:@"jpg"];
    return imagePath;
}

+ (UIImage *)getThumbImageWithPath:(NSString *)videoPath
{
    NSString * imgPath = [self getThumbPathWithPath:videoPath];
    UIImage * result = [[LBCache sharedInstance] cacheImageForPath:imgPath];
    if(!result)
    {
        result = [self createThumbImageWithPath:videoPath];
        NSData * data = UIImageJPEGRepresentation(result, 0.8);
        [data writeToFile:imgPath atomically:YES];
    }
    return result;
}

+ (UIImage *)createThumbImageWithPath:(NSString *)videoPath
{
    if(!videoPath)
        return nil;
    NSError *error = nil;
    CMTime imgTime = kCMTimeZero;
    AVAsset * asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    //generator.maximumSize = size;
    CGImageRef cgIm = [generator copyCGImageAtTime:imgTime
                                        actualTime:NULL
                                             error:&error];
    UIImage *image = [UIImage imageWithCGImage:cgIm scale:1 orientation:UIImageOrientationUp];
    CGImageRelease(cgIm);
    if (nil != error)
    {
        NSLog(@"Error making screenshot: %@", [error localizedDescription]);
        return nil;
    }
    return image;
}

+ (void)moveToFormalPath:(NSString *)tempPath
{
    NSString * newPath = [self getFormalPathFromTempPath:tempPath];
    if(![newPath isEqualToString:tempPath])
    {
        NSError * error = nil;
        [[NSFileManager defaultManager] moveItemAtPath:tempPath toPath:newPath error:&error];
        if(error)
        {
            NSLog(@"moveToFormalPath error :%@",error);
        }
    }
}

+ (NSString *)getFormalPathFromTempPath:(NSString *)tempPath
{
    NSString * name = [tempPath lastPathComponent];
    return [self videoPathWithName:name];
}

+ (NSString *)getTempPathFromFormalPath:(NSString *)formalPath
{
    NSString * name = [formalPath lastPathComponent];
    return [self videoTempPathWithName:name];
}

+ (NSString *)videoPathWithName:(NSString *)name
{
    NSString * documentsPath = [FileUtil getMoviePath];
    return [documentsPath stringByAppendingPathComponent:name];
}

+ (NSString *)videoTempPathWithName:(NSString *)name
{
    NSString * documentsPath = [FileUtil getMovieTempPath];
    return [documentsPath stringByAppendingPathComponent:name];
}

+ (NSString *)getCachePathForRemotePath:(NSString *)path
{
    NSString * documentsPath = [FileUtil getMovieCachePath];
    NSString * newPath = [documentsPath stringByAppendingPathComponent:[NSString getMD5ForStr:path]];
    return [newPath stringByAppendingString:@".mp4"];
}


+ (void)clearTemps
{
    NSBundle *bundle = [NSBundle bundleWithPath:[LBCameraTool videoTempPathWithName:nil]];
    NSArray * allMedia = [bundle pathsForResourcesOfType:@"nil" inDirectory:nil];
    for(NSString * obj in allMedia)
    {
        [[NSFileManager defaultManager] removeItemAtPath:obj error:nil];
    }
}

+ (BOOL)fileExist:(NSString *)file
{
    return [[NSFileManager defaultManager] fileExistsAtPath:file];
}


+ (void)load
{
    //    //[self clearTemps];
}
@end
