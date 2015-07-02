//
//  LBCamera.h
//  cameraDemo
//
//  Created by 乐播 on 13-3-1.
//  Copyright (c) 2013年 乐播. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LBMovieWriter.h"
#import "LBView.h"

@protocol LBCameraDelegate;
@interface LBCamera : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,LBMovieWriterDelegate,LBViewDisplayDelegate>
{
    AVCaptureSession * _session;
    AVCaptureVideoPreviewLayer * _layer;
    AVCaptureDeviceInput * _videoInput;
    LBMovieWriter * _movieWriter;
    BOOL _shouleRecord;
    BOOL _shouldCapture;
}
@property(readonly) double writedDuration;
@property(nonatomic,assign) id<LBCameraDelegate> delegate;
@property(nonatomic,readonly) AVCaptureVideoPreviewLayer * layer;
@property(nonatomic,readonly) LBView * cameraView;
@property(nonatomic,readonly) NSString * videoPath;
@property(nonatomic,readwrite) AVCaptureDevicePosition cameraPosition;

- (id)initWithFilePath:(NSString *)filePath;

- (void)startCapture;

- (void)endCapture;

- (void)startRecord;

- (void)pauseRecord;

- (void)endRecord;

- (void)clearFile;

- (void)cancel;

- (BOOL)isSessionRunning;

@end


@protocol LBCameraDelegate <NSObject>
@optional

- (void)didFinishExport:(LBCamera *)camera withSuccess:(BOOL)success;

@end