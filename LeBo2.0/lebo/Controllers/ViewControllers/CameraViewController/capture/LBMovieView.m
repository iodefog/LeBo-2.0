//
//  LBMovieView.m
//  LeBo
//
//  Created by 乐播 on 13-3-11.
//
//

#import "LBMovieView.h"
#import "LBPlayer.h"
#import "LBCameraTool.h"
#define MAX_RetryCount 1
@interface LBMovieView()
{
    UIImageView * _imageView;
    //LBActivityIndicatorView * _activity;
    MBProgressHUD * _hud;
    int _retryCount;
}
@property(nonatomic,copy) NSURL * movieURL;
@end

static BOOL shouldAllPause = NO;

@implementation LBMovieView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if([self respondsToSelector:@selector(setTranslatesAutoresizingMaskIntoConstraints:)])
            [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        _shouldPlay = NO;
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.userInteractionEnabled = YES;
        _supportTouch = YES;
        
        _hud = [[MBProgressHUD alloc] initWithView:self];
        _hud.color = [UIColor clearColor];
        [self addSubview:_hud];
        
        //_hud.mode = MBProgressHUDModeIndeterminate;
        //_hud.delegate = self;
        //_hud.labelText = @"Loading";
        
//        _activity = [[LBActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [self addSubview:_activity];
    }
    return self;
}

- (void)hudShowWithIndeterminateStyle
{
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = nil;
    if([_hud isHidden] == NO)
    {
        [_hud show:YES];
    }
}



- (void)hudShowWithDeterminateStyle
{
    if(_hud.mode != MBProgressHUDModeDeterminate)
    {
        _hud.mode = MBProgressHUDModeDeterminate;
        _hud.labelText = @"下载中...";
        _hud.progress = 0;
    }
    if([_hud isHidden] == NO)
    {
        [_hud show:YES];
    }
}

- (UIImage *)mImage{
    return _imageView.image;
}

- (void)dealloc
{
    [self stop];
}

- (NSString *)getFinalPath:(NSString *)path
{
    return [[Global getServerUrl2] stringByAppendingString:path];
}

- (void)setImageId:(NSString *)imageId
{
    if(imageId)
    {
        _imageView.image = nil;
        NSString * realUrl = [self getFinalPath:imageId];
        //NSLog(@"image URL:%@",realUrl);
        [_imageView setImageWithURL:[NSURL URLWithString:realUrl]];
        //_imageView.backgroundColor = [UIColor redColor];
    }
    else
    {
        _imageView.image = nil;
    }
}

- (void)setMovieId:(NSString *)movieId
{
    if(_movieId != movieId)
    {
        _retryCount = MAX_RetryCount;
        _movieId = [movieId copy];
        [self stop];
        self.movieURL = nil;
        if(_movieId == nil)
        {
            [_hud hide:NO];
            //[_activity stopAnimating];
        }
        else
        {
            LBMovieDownloader * downloader = [LBMovieDownloader sharedInstance];
            if([Global canAutoDownLoad])
            {
                NSLog(@"[Global canAutoDownLoad]");
                [self hudShowWithIndeterminateStyle];
                //[downloader addMoviePath:movieId delegate:self];
            }
            if([[downloader dowloadingPath] isEqualToString:movieId] && [downloader isDownloading])
            {
                [self hudShowWithDeterminateStyle];
                _hud.progress = downloader.downloadPercent;
                [downloader setProgressDelegate:self];
            }
            else if(downloader.progressDelegate == self)
            {
                downloader.progressDelegate = nil;
                [_hud hide:NO];
            }
            //[_activity startAnimating];
            
        }

    }
}

- (void)setPlayerURL:(NSURL *)url
{
    
    self.movieURL = url;
}

- (void)layoutSubviews
{
    LBPlayer * player = [LBPlayer sharedPlayer];
    if(player.url == self.movieURL)
    {
        player.layer.frame = _imageView.bounds;
    }
    _imageView.frame = self.bounds;
    //_activity.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}


- (void)play
{
    NSLog(@"movieview play");
    shouldAllPause = NO;
    _shouldPlay = YES;
    LBPlayer * player = [LBPlayer sharedPlayer];
    if(player.layer.superlayer != _imageView.layer)
    {
        [_imageView.layer addSublayer:player.layer];
        
        player.layer.frame = _imageView.bounds;
    }
    if([player.url isEqual:self.movieURL] && player.rate!=0)
        return;
    ;
    
    
    //NSString * baseString = [Global getServerUrl2];
    //NSString * realPath = [baseString stringByAppendingString:self.movieId];
//    [player setURL:[NSURL URLWithString:@"https://s3.amazonaws.com/houston_city_dev/video/h264-original/1/haku.mp4"]];
//    [player play];
//    NSLog(@"LBPlayer duration:%f",CMTimeGetSeconds(player.currentItem.duration));
//    return;
    
    BOOL flag  = [[NSFileManager defaultManager] fileExistsAtPath:[self.movieURL path]];
    //NSLog(@"is file exist:%d path:%@",flag,self.movieId);
    if(self.movieURL && flag)
    {
        [player setURL:self.movieURL];
        [player play];
        //double duration = CMTimeGetSeconds(player.currentItem.duration);
//        if(duration == 0)
//        {
//            [[NSFileManager defaultManager] removeItemAtPath:[self.movieURL path] error:nil];
//            if(--_retryCount >= 0)
//            {
//                [self play];
//            }
//        }
    }
    else if(_movieId)
    {
        [player stop];
        
        LBMovieDownloader * downloader = [LBMovieDownloader sharedInstance];
        [downloader addMoviePath:_movieId delegate:self];
        if([[downloader dowloadingPath] isEqualToString:_movieId] && [downloader isDownloading])
        {
            [self hudShowWithDeterminateStyle];
            _hud.progress = downloader.downloadPercent;
            _hud.labelText = [NSString stringWithFormat:@"%d%%",(int)(_hud.progress*100)];
            [downloader setProgressDelegate:self];
        }
        else if(downloader.progressDelegate == self)
        {
            downloader.progressDelegate = nil;
        }

        //[_activity startAnimating];
    }
    else
    {
        [player stop];
        NSLog(@"play stop");
    }
}

- (BOOL)isPlaying
{
    LBPlayer * player = [LBPlayer sharedPlayer];

    if([player.url isEqual:self.movieURL] && player.rate!=0)
        return YES;
    else
        return NO;
}

- (void)pause
{
    _shouldPlay = NO;
    LBPlayer * player = [LBPlayer sharedPlayer];
    if([player.url isEqual:self.movieURL])
    {
        [player pause];
    }
}

- (void)stop
{
    _shouldPlay = NO;
    LBPlayer * player = [LBPlayer sharedPlayer];
    if([player.url isEqual:self.movieURL] && player.layer.superlayer == _imageView.layer )
    {
        [player stop];
    }
}

+ (void)pauseAll
{
    NSLog(@"pauseAll");
    shouldAllPause = YES;
    LBPlayer * player = [LBPlayer sharedPlayer];
    [player stop];
    //[player setURL:nil];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if(_supportTouch)
    {
        if([self isPlaying])
            [self pause];
        else
            [self play];
    }
}

- (UIView *)contentView
{
    if(!_contentView)
    {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_contentView];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _contentView;
}
#pragma mark LbMovieDownloaderDelegate
- (void)movieDownloaderDidStart:(NSString *)path
{
    NSLog(@"movieDownloaderDidStart");
    //if([path isEqualToString: self.movieId])
    //{
        [self hudShowWithDeterminateStyle];
    //}
}

- (void)movieDownloaderDidFinished:(NSString *)path
{
    if([path isEqualToString: self.movieId])
    {
        [_hud hide:YES];
        //BOOL flag = [[NSFileManager defaultManager] fileExistsAtPath:[LBCameraTool getCachePathForRemotePath:path]];
        //NSLog(@"file exsist:%d,%@",flag,[LBCameraTool getCachePathForRemotePath:path]);
        self.movieURL = [NSURL fileURLWithPath:[LBCameraTool getCachePathForRemotePath:path]];
        if(_shouldPlay && !shouldAllPause)
            [self play];
    }
}

- (void)movieDownloaderDidFailed:(NSString *)path
{
    if([path isEqualToString: self.movieId])
    {
        [_hud hide:YES];

    }
}

- (void)movieDownloaderProgress:(NSNumber *)percent
{
    _hud.progress = [percent floatValue];
    _hud.labelText = [NSString stringWithFormat:@"%d%%",(int)(_hud.progress*100)];
    NSLog(@"movieDownloaderProgress:%f",_hud.progress);
}

@end
