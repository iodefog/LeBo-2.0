//
//  LBMovieWriter.h
//  cameraDemo
//
//  Created by 乐播 on 13-3-5.
//  Copyright (c) 2013年 乐播. All rights reserved.
//  参考 RosyWriter Demo

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#define FRAME_PER_S 24.0
@class LBMovieWriter;
@protocol LBMovieWriterDelegate <NSObject>

@optional

- (void)movieWriterDidFinishWrite:(LBMovieWriter *)movieWriter;

@end

@interface LBMovieWriter : NSObject<AVAudioRecorderDelegate>
@property(readonly) double writedDuration;
@property(nonatomic,readonly) BOOL isFinished;
@property(nonatomic,assign) id<LBMovieWriterDelegate> delegate;
- (id)initWithPath:(NSString *)path;

- (void)start;

- (void)pause;

- (void)processAudioBuffer:(CMSampleBufferRef)audioBuffer;

- (void)processVideoBuffer:(CMSampleBufferRef)videoBuffer;

- (void)end;

- (void)deleteFile;

- (void)cancel;

+ (UIImage *)getThumbImageWithPath:(NSString *)path;

@end
