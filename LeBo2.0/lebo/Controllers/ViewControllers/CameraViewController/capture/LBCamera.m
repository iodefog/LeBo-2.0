//
//  LBCamera.m
//  cameraDemo
//
//  Created by 乐播 on 13-3-1.
//  Copyright (c) 2013年 乐播. All rights reserved.
//

#import "LBCamera.h"
//#define FRAME_PER_SECONDS 30


@implementation LBCamera
@dynamic cameraPosition;
@dynamic writedDuration;
- (id)initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if(self)
    {
        NSFileManager * fm = [NSFileManager defaultManager];
        if([fm fileExistsAtPath:filePath])
        {
            NSError * removeError = nil;
            [fm removeItemAtPath:filePath error:&removeError];
            if(removeError)
            {
                NSLog(@"remove error :%@",removeError);
            }
        }
        _shouldCapture = NO;
        _shouleRecord = NO;
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        _movieWriter = [[LBMovieWriter alloc] initWithPath:filePath];
        _movieWriter.delegate = self;
        _videoPath = [filePath copy];
        [self initialSession];
    }
    return self;
}


- (BOOL)initialSession
{
    _session = [[AVCaptureSession alloc] init];
    [_session beginConfiguration];
    if([self shouldAlwaysDiscardsLateVideoFrames] == NO)
        _session.sessionPreset = AVCaptureSessionPresetPhoto;
    _layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _layer.contentsScale = [[UIScreen mainScreen] scale];
    //[_session addObserver:self forKeyPath:@"interrupted" options:NSKeyValueObservingOptionNew context:nil];
    
    _cameraView = [[LBView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    _cameraView.backgroundColor = [UIColor blackColor];
    [_cameraView.layer addSublayer:_layer];
    _cameraView.delegate = self;
    
    AVCaptureDevice * videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    [self configInputVideoDevice:videoDevice];

    _videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if(error)
    {
        [self handleError:error];
        return NO;
    }
    
//    AVCaptureDevice * audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
//    AVCaptureDeviceInput * audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
//    if(error)
//    {
//        [self handleError:error];
//        return NO;
//    }
    [_session addInput:_videoInput];
    //[_session addInput:audioInput];
    
    AVCaptureVideoDataOutput * videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    {
        //视频输出设置
        [videoOutput setAlwaysDiscardsLateVideoFrames:[self shouldAlwaysDiscardsLateVideoFrames]];
        AVCaptureConnection *videoConnection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
        if (videoConnection.supportsVideoMinFrameDuration)
            videoConnection.videoMinFrameDuration = CMTimeMake(1,FRAME_PER_S);
        if (videoConnection.supportsVideoMaxFrameDuration)
            videoConnection.videoMaxFrameDuration = CMTimeMake(1,FRAME_PER_S);
        if ([videoConnection isVideoOrientationSupported])
        {
            AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationPortrait;
            [videoConnection setVideoOrientation:orientation];
        }
        if ([videoConnection respondsToSelector:@selector(setEnablesVideoStabilizationWhenAvailable:)])
            [videoConnection setEnablesVideoStabilizationWhenAvailable:YES];
        
        BOOL supportsFullYUVRange = NO;
        NSArray *supportedPixelFormats = videoOutput.availableVideoCVPixelFormatTypes;
        for (NSNumber *currentPixelFormat in supportedPixelFormats)
        {
            if ([currentPixelFormat intValue] == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
            {
                supportsFullYUVRange = YES;
                break;
            }
        }
        if (supportsFullYUVRange)
        {
            [videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        }
        else
        {
            [videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        }
        //[videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];

    }
    dispatch_queue_t videoProcessingQueue = dispatch_queue_create("com.LeBo.videoProcessingQueue", NULL);
    [videoOutput setSampleBufferDelegate:self queue:videoProcessingQueue];
    [_session addOutput:videoOutput];
    //[videoOutput release];

//    AVCaptureAudioDataOutput * audioOutput = [[AVCaptureAudioDataOutput alloc] init];
//    [audioOutput setSampleBufferDelegate:self queue:videoProcessingQueue];
//    [_session addOutput:audioOutput];
    //[audioOutput release];
    dispatch_release(videoProcessingQueue);

    //[self reConfigPreset];
    [_session commitConfiguration];
    return YES;
}

- (void)configInputVideoDevice:(AVCaptureDevice *)videoDevice
{
    //视频输入设置
    [videoDevice lockForConfiguration:nil];
    //自动对焦
    if([videoDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
        videoDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    else if([videoDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus])
        videoDevice.focusMode = AVCaptureFocusModeAutoFocus;
    if([videoDevice isFocusPointOfInterestSupported])
        [videoDevice setFocusPointOfInterest:CGPointMake(.5, .5)];
    //曝光
    if([videoDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
        videoDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    else if([videoDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose])
        videoDevice.exposureMode = AVCaptureExposureModeAutoExpose;
    if([videoDevice isExposurePointOfInterestSupported])
        [videoDevice setExposurePointOfInterest:CGPointMake(.5, .5)];
    //白平衡
    if([videoDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance])
        videoDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
    else if([videoDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance])
        videoDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
    //
    
    if([videoDevice respondsToSelector:@selector(isLowLightBoostSupported)])
    {
        if(videoDevice.lowLightBoostSupported == YES)
            videoDevice.automaticallyEnablesLowLightBoostWhenAvailable = YES;
    }
    [videoDevice unlockForConfiguration];
}

- (void)clearSession
{
    //[_session removeObserver:self forKeyPath:@"interrupted"];
}

- (void)startCapture
{
    _shouldCapture = YES;
    if(![_session isRunning])
    {
        [_session startRunning];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [_session startRunning];;
//        });
    }
}

- (void)endCapture
{
    _shouldCapture = NO;
    [self pauseRecord];
    if(_session.running)
        [_session stopRunning];
}

- (void)startRecord
{
    NSLog(@"camera start");
    
    _shouleRecord = YES;
    [_movieWriter start];
}

- (void)pauseRecord
{
    NSLog(@"camera pause");
    _shouleRecord = NO;
    [_movieWriter pause];
}

- (void)endRecord
{
    _shouleRecord = NO;
    [_movieWriter end];
}

- (void)clearFile
{
    [_movieWriter deleteFile];
}

- (void)cancel
{
    [self endCapture];
    _shouleRecord = NO;
    [_movieWriter cancel];
}

- (BOOL)isSessionRunning
{
    return [_session isRunning];
}

- (void)handleError:(NSError *)error
{
    NSLog(@"capture error:%@",[error localizedDescription]);
}

- (double)writedDuration
{
    return [_movieWriter writedDuration];
}

- (void)dealloc
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    _movieWriter.delegate = nil;
    [self clearSession];
}


- (void)setCameraPosition:(AVCaptureDevicePosition)cameraPosition
{
    if(cameraPosition != self.cameraPosition)
    {
        [self endCapture];
        //_session.sessionPreset = AVCaptureSessionPresetLow;
        [_session beginConfiguration];
        [_session removeInput:_videoInput];
        AVCaptureDevice * device = nil;
        NSArray * devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for(AVCaptureDevice * temp in devices)
        {
            if(temp.position == cameraPosition)
            {
                device = temp;
                break;
            }
        }
        [self configInputVideoDevice:device];
        
        NSError *error = nil;
        _videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        [_session addInput:_videoInput];
        //[self reConfigPreset];
        [_session commitConfiguration];
        [_session startRunning];
        NSLog(@"did start record");
    }
}

- (AVCaptureDevicePosition)cameraPosition
{
    return _videoInput.device.position;
}

- (void)reConfigPreset
{
    [_session beginConfiguration];
    NSArray * presets = @[AVCaptureSessionPreset1920x1080,AVCaptureSessionPreset1280x720,AVCaptureSessionPreset640x480,AVCaptureSessionPresetMedium,AVCaptureSessionPresetLow];
    for(NSString * preset in presets)
    {
        if([_session canSetSessionPreset:preset])
        {
            _session.sessionPreset = preset;
            NSLog(@"当前输入画质:%@",preset);
            break;
        }
    }
    [_session commitConfiguration];
}

- (BOOL)shouldAlwaysDiscardsLateVideoFrames
{   
    int cpuCount = [[UIDevice currentDevice] cpuCount];
    NSLog(@"cpuCount:%d",cpuCount);
    if(cpuCount>1)
        return NO;
    else
        return YES;
}
#pragma mark KVO
//处理被电话中断事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == _session)
    {
        if([keyPath isEqualToString:@"interrupted"])
        {
            NSNumber * newNum = change[NSKeyValueChangeNewKey];
            BOOL interrupted = [newNum boolValue];
            if(interrupted )
            {
                [self pauseRecord];
            }
            else if(!interrupted && _shouldCapture)
            {
                if(![_session isRunning])
                {
                    [_session startRunning];
                }
            }
        }
    }
}

#pragma mark AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if(!_shouleRecord)
    {
        return;
    }
    if([captureOutput isKindOfClass:[AVCaptureAudioDataOutput class]])
    {
        [_movieWriter  processAudioBuffer:sampleBuffer];
    }
    else if([captureOutput isKindOfClass:[AVCaptureVideoDataOutput class]])
    {
        
        [_movieWriter  processVideoBuffer:sampleBuffer];
    }
    else
    {
        NSLog(@"not Video audio");
        
    }
}

#pragma mark LBMovieWriterDelegate

- (void)movieWriterDidFinishWrite:(LBMovieWriter *)movieWriter
{
    if([self.delegate respondsToSelector:@selector(didFinishExport:withSuccess:)])
    {
        [self.delegate didFinishExport:self withSuccess:YES];
    }
}

#pragma mark LBCameraDelegate

- (void)didLayoutSubviews:(UIView *)view
{
    _layer.frame = view.bounds;
}
@end
