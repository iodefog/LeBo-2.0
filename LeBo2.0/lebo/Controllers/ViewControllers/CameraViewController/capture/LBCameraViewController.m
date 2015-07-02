//
//  LBCameraViewController.m
//  cameraDemo
//
//  Created by 乐播 on 13-3-1.
//  Copyright (c) 2013年 乐播. All rights reserved.
//

#import "LBCameraViewController.h"
#import "LBMovieView.h"
#import "LBUploadEditController.h"
#import "LBProgressBar.h"
#import "MBProgressHUD.h"
#define MAX_Duration 6.1f
#define MIN_Time 0.05f
@interface LBCameraViewController ()
{
    LBCamera * _camera;
    LBMovieView * _movieView;
    UIImageView * _mainView;
    UIImageView * _bottomView;
    
    UIButton * _nextBtn;
    UIButton * _markBtn;
    UIButton * _changeBtn;

    UIActivityIndicatorView * _activityView;
    
    LBProgressBar * _progress;

    MBProgressHUD * _hud;
    
    NSDate * _startDate;
    double _recordTime;
    BOOL _isFinished;
    BOOL _isLoading;
    
    BOOL _hasWritedData;
    BOOL _isChangingLens;
    
}
@property(nonatomic,retain) NSTimer * timer;
@property(atomic,assign) BOOL shouldContinue;
@property(nonatomic,assign) UIBackgroundTaskIdentifier bgTask;
@property(nonatomic,assign) BOOL isChangingLens;
@end

@implementation LBCameraViewController
@synthesize bgTask;
@synthesize isChangingLens = _isChangingLens;
static BOOL _shouldShowGuide;

- (void)checkForShouldShowGuide
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    if([userDefault objectForKey:@"firstInCamera"])
    {
        _shouldShowGuide = NO;
    }
    else
    {
        [userDefault setBool:YES forKey:@"firstInCamera"];
        [userDefault synchronize];
        _shouldShowGuide = YES;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _hasWritedData = NO;
        [self checkForShouldShowGuide];
        [self initialCamera];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForground) name:UIApplicationWillEnterForegroundNotification object:nil];
        
    }
    return self;
}

- (UIView *)getTopBar
{
    UIView * topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    topBar.userInteractionEnabled = YES;
    topBar.backgroundColor = [UIColor clearColor];
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(didClickClose) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:Image(@"camera_cancel.png") forState:UIControlStateNormal];
    [leftButton sizeToFit];
    [leftButton.titleLabel setFont:[UIFont getButtonFont]];
    leftButton.center =  CGPointMake(30, topBar.height/2);
    [topBar addSubview:leftButton];

    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setShowsTouchWhenHighlighted:YES];
    [rightButton addTarget:self action:@selector(didClickChangeLens:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:Image(@"camera_btn_lens.png") forState:UIControlStateNormal];
    rightButton.size = CGSizeMake(40, 30);
    rightButton.center =  CGPointMake(topBar.width - 30, topBar.height/2);
    [topBar addSubview:rightButton];
    
    return topBar;
}

- (void)initialCamera
{
    [LBMovieView pauseAll];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_hh_mm_ss"];
    NSDate * now = [NSDate date];
    NSString *  dateString = [dateFormatter stringFromDate:now];
    NSString * path = [[LBCameraTool videoPathWithName:dateString] stringByAppendingString:@".mp4"];
    
    _camera = [[LBCamera alloc] initWithFilePath:path];
    _camera.delegate = self;
}

- (void)clearViews
{
    _movieView = nil;
    _mainView = nil;
    _bottomView = nil;
    _nextBtn = nil;
    _markBtn = nil;
    _changeBtn = nil;
    _progress = nil;
    _hud = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.timer = nil;
    if(self.bgTask)
    {
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }

}


- (void)createMainView
{
    _mainView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.view.width, 330)];
    _mainView.userInteractionEnabled = YES;
    _mainView.backgroundColor = [UIColor cameraBg];
    //[_mainView sizeToFit];
    
    _progress = [[LBProgressBar alloc] initWithFrame:CGRectMake(0, 0, _mainView.frame.size.width, 8)];
    UIImage * progress_bg = Image(@"camera_progress_bg.png");
    progress_bg = [progress_bg stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    [_progress setBackgroundImage:progress_bg];
    UIImage * progress_fg = Image(@"camera_progress_fg.png");
    progress_fg = [progress_fg stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    [_progress setProgressImage:progress_fg];
    [_mainView addSubview:_progress];
    
    CALayer * topLine = [CALayer layer];
    topLine.frame = CGRectMake(0, _progress.bottom, _mainView.width, 1);
    topLine.backgroundColor = [UIColor blackColor].CGColor;
    [_mainView.layer addSublayer:topLine];
    
    _movieView = [[LBMovieView alloc] initWithFrame:CGRectMake(0, _progress.bottom+1, _mainView.width, _mainView.width)];
    [_mainView addSubview:_movieView];
    
    [_mainView addSubview:_camera.cameraView];
    _camera.cameraView.frame = _movieView.frame;
    
    CALayer * bottomLine = [CALayer layer];
    bottomLine.frame = CGRectMake(0, _movieView.bottom, _mainView.width, 1);
    bottomLine.backgroundColor = [UIColor blackColor].CGColor;
    [_mainView.layer addSublayer:bottomLine];
    
    if(_shouldShowGuide)
    {
        UIView * instructionView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, _mainView.width, 80)];
        instructionView.backgroundColor = [UIColor clearColor];
        [_mainView addSubview:instructionView];
        
        _hud = [[MBProgressHUD alloc] initWithView:instructionView];
        //_hud.center = CGPointMake(instructionView.width/2, 40);
        [instructionView addSubview:_hud];
        _hud.mode = MBProgressHUDModeText;
        _hud.delegate = self;
    }
    
    [self.view addSubview:_mainView];
}

- (void)createBottomView
{
    //UIImage * img = Image(@"camera_bottom.png");
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _mainView.bottom, self.view.width, self.view.height-_mainView.bottom)];
    imageView.backgroundColor = [UIColor cameraBg];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    _bottomView = imageView;
    
    _markBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * markImage = [UIImage imageNamed:@"camera_btn_mark.png"];
    [_markBtn setImage:markImage forState:UIControlStateNormal];
    [_markBtn sizeToFit];
    [_markBtn addTarget:self action:@selector(didClickMark:) forControlEvents:UIControlEventTouchUpInside];
    int space = _bottomView.frame.size.height-22-_markBtn.height ;
    _markBtn.frame = CGRectMake(_bottomView.width-_markBtn.width-22, space, _markBtn.width, _markBtn.height);
    [_bottomView addSubview:_markBtn];
    _markBtn.hidden = YES;
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.center = _markBtn.center;
    [_bottomView addSubview:_activityView];
    _activityView.hidden = YES;
    

    CGSize size = CGSizeMake(136, 36);
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.titleLabel.font = [UIFont getButtonFont];
    [_nextBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    _nextBtn.titleLabel.shadowOffset = CGSizeMake(0, 1);
    UIImage * nextImg = Image(@"camera_btn_publish.png");
    nextImg = [nextImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [_nextBtn setBackgroundImage:nextImg forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(didClickNext:) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.frame = CGRectMake(0, _bottomView.height-22-size.height, size.width, size.height);
    _nextBtn.centerX = _bottomView.width/2;
    [_bottomView addSubview:_nextBtn];
    _nextBtn.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];

    self.view.backgroundColor = [UIColor cameraBg];
    self.view.userInteractionEnabled = YES;
    UIView * topBar = [self getTopBar];
    [self.view addSubview:topBar];
    [self createMainView];
    [self createBottomView];
    //[self.navigationController setNavigationBarHidden:YES];
    
    [self performSelector:@selector(start) withObject:nil afterDelay:0.01];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
 
    [self clearViews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if(_isFinished)
        [_movieView pause];
    else
    {
        [self stopRecord];
        [_camera endCapture];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

    if(_isFinished)
        [self playCapture];
    else
    {
        [_camera startCapture];
    }
}


- (void)playCapture
{
    if(_isFinished)
    {
        [_mainView bringSubviewToFront:_movieView];
        NSString * path = [_camera videoPath];
        if([LBCameraTool fileExist:path])
        {
            [_movieView setPlayerURL:[NSURL fileURLWithPath:path]];
            [_movieView play];
        }
        else
        {
            NSLog(@"no player path in playCapture");
        }
    }
}

- (void)stop
{
    [_camera endRecord];
    [_camera endCapture];    
}

- (void)start
{
    [_camera startCapture];
    if(_shouldShowGuide)
    {
        [_hud show:YES];
        _hud.labelText = @"按住屏幕，开始拍摄";
    }
}

- (void)startRecord
{
    if (_isFinished == YES || _isLoading == YES || ![_camera isSessionRunning])
        return;
    [_camera startRecord];
    _hasWritedData = YES;
    _startDate = [[NSDate date] copy];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0f target:self selector:@selector(step) userInfo:nil repeats:YES];
    _isLoading = YES;
}

- (void)stopRecord
{
    if (_isFinished == YES || _isLoading == NO)
        return;
    _isLoading = NO;

    if (self.timer.isValid)
    {
        [self.timer invalidate];
        [_camera pauseRecord];
        float endFloat = [[NSDate date] timeIntervalSinceDate:_startDate];
        _recordTime += endFloat;
    }
}

#pragma mark Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(touchEnd) object:nil];
    if(_isChangingLens)
    {
        NSLog(@"_isChangingLens");
        _shouldContinue = YES;
    }
    else
    {
        [self startRecord];
        if(_shouldShowGuide)
        {
            [_hud hide:YES];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    double endFloat = [[NSDate date] timeIntervalSinceDate:_startDate];
    if(endFloat<MIN_Time)
    {
        [self performSelector:@selector(touchEnd) withObject:nil afterDelay:MIN_Time-endFloat];
    }
    else
    {
        [self touchEnd];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    double endFloat = [[NSDate date] timeIntervalSinceDate:_startDate];
    if(endFloat<MIN_Time)
    {
        [self performSelector:@selector(touchEnd) withObject:nil afterDelay:MIN_Time-endFloat];
    }
    else
    {
        [self touchEnd];
    }
    //_shouldContinue = NO;
    //[self stopRecord];
}

- (void)touchEnd
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:_cmd object:nil];
    _shouldContinue = NO;
    [self stopRecord];
    if(_shouldShowGuide && _isFinished == NO)
    {
        [_hud show:YES];
        _hud.labelText = @"按住屏幕，继续拍摄";
    }
}

- (void)step
{
    double time = [_camera writedDuration];
    //double endFloat = [[NSDate date] timeIntervalSinceDate:_startDate];
    //double totalTime = _recordTime + endFloat;
    double totalTime =time;
    NSLog(@"touchTime:%f ,audiotime:%f",totalTime,time);
    _progress.progress =  totalTime/MAX_Duration;
    if (totalTime >= 2.0f && totalTime <= MAX_Duration)
    {
        _markBtn.hidden = NO;
    }
    else if(MAX_Duration - totalTime <= 0.0f)
    {
        [self didFinishCapture];
    }
    
    static BOOL hasShowText = NO;
    if(_shouldShowGuide && hasShowText==NO && totalTime>=2.0 )
    {
        _hud.labelText = @"松开，暂停拍摄";
        [_hud show:YES];
        hasShowText = YES;
    }
}

- (void)didFinishCapture
{
    _markBtn.hidden = YES;
    [_activityView startAnimating];
    [self.navigationItem setTitle:@"回放"];
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    if (self.timer.isValid)
        [self.timer invalidate];
    _isFinished = YES;
    _shouldShowGuide = NO;
    [self stop];
}

- (void)saveToMovieDirectory
{
    [LBCameraTool moveToFormalPath:[_camera videoPath]];
    [LBCameraTool moveToFormalPath:[LBCameraTool getThumbPathWithPath:_camera.videoPath]];
}

#pragma mark IBAction
- (void)setIsChangingLens:(BOOL)sender
{
    _isChangingLens = sender;
}

- (void)didClickChangeLens:(UIButton *)sender
{
    if(_isFinished)
        return;
    if(_isChangingLens == YES)
        return;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setIsChangingLens:) object:NO];
    _isChangingLens = YES;
    [self performSelector:@selector(setIsChangingLens:) withObject:NO afterDelay:1];
    self.shouldContinue = self.timer.isValid;
    if(self.shouldContinue)
        [self stopRecord];
    if(_camera.cameraPosition == AVCaptureDevicePositionUnspecified || _camera.cameraPosition == AVCaptureDevicePositionBack)
        _camera.cameraPosition = AVCaptureDevicePositionFront;
    else
        _camera.cameraPosition = AVCaptureDevicePositionBack;
    if(self.shouldContinue)
        [self startRecord];
}

- (void)didClickClose
{
    [Global clearPlayStatus];
    
    if(_hasWritedData)
    {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消发布" otherButtonTitles:nil];
        [sheet showInView:self.view];
    }
    else
    {
        [_camera cancel];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didClickMark:(UIButton *)sender
{
    [self didFinishCapture];
}

- (void)didClickNext:(UIButton *)sender
{
    LBUploadEditController * controller = [[LBUploadEditController alloc] initWithMoviePath:_camera.videoPath];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark LBCameraDelegate

- (void)didFinishExport:(LBCamera *)camera withSuccess:(BOOL)success
{
    [_activityView stopAnimating];
    _nextBtn.hidden = NO;
    _markBtn.hidden = YES;
   [self playCapture];
}

#pragma mark NSNotification

- (void)willEnterForground
{
    if(self.bgTask)
    {
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }
}

- (void)didEnterBackground
{
    if (self.timer.isValid)
        [self.timer invalidate];
    if(self.bgTask)
    {
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }
    self.bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        if(!_isFinished)
        {
            [self stopRecord];
            [_camera cancel];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }];
}

#pragma mark MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"index ：%d",buttonIndex);
    if(buttonIndex == 0)
    {
        if(self.timer.isValid)
            [self.timer invalidate];
        [_camera cancel];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
