//
//  LBMovieDownloader.h
//  lebo
//
//  Created by 乐播 on 13-4-2.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@protocol LBMovieProgressDelegate<NSObject>

- (void)movieDownloaderDidStart:(NSString *)path;

- (void)movieDownloaderProgress:(NSNumber *)percent; //float

@end

@protocol LBMovieDownloaderDelegate<NSObject>
@optional
- (void)movieDownloaderDidFinished:(NSString *)path;

- (void)movieDownloaderDidFailed:(NSString *)path;

@end
@interface LBMovieDownloader : NSObject
{
    AFHTTPClient * _client;
    NSMutableArray * _taskArray;
    dispatch_queue_t _downloadQueue;
    float _progress;
    NSString * _dowloadingPath;
}
@property(nonatomic,weak) id <LBMovieProgressDelegate> progressDelegate;
@property(nonatomic,readonly) NSString * dowloadingPath;

+ (id)sharedInstance;

- (BOOL)isDownloading;

- (void)addMoviePath:(NSString *)path delegate:(__weak id<LBMovieDownloaderDelegate>)delegate;


- (float)downloadPercent;
@end
