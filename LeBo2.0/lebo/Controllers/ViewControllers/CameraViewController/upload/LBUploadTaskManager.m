//
//  LBUploadTaskManager.m
//  lebo
//
//  Created by 乐播 on 13-3-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBUploadTaskManager.h"
#import "LBUploadTask.h"
#import "LBFileClient.h"
#import "LBCameraTool.h"
#import "LBUploadManagerController.h"
#import "LBUploadSender.h"
#import "SinaHelper.h"
#import "AccountHelper.h"
#import "RenRenHelper.h"
NSString * const LBUploadTaskManagerDidChangeInfo = @"LBUploadTaskManagerDidChangeInfo";
NSString * const LBUploadTaskChangedInfo = @"LBUploadTaskChangedInfo";

NSString * const LBUploadViewDidChange = @"LBUploadViewDidChange";
NSString * const LBUploadTaskNumberKey = @"LBUploadTaskNumberKey";

NSString * const LBUploadTaskDidFinished = @"LBUploadTaskDidFinished";
@implementation LBUploadView
@dynamic taskNumber;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.userInteractionEnabled = YES;
        UIImage * view_bgImg = Image(@"upload_view_bg.png");
        view_bgImg = [view_bgImg stretchableImageWithLeftCapWidth:4 topCapHeight:0];
        _shadowBg = view_bgImg;
        
        _mark = [[UIImageView alloc] initWithImage:Image(@"uni_icon_angle.png")];
        [self addSubview:_mark];
        
        _imageView = [[UIImageView alloc] init];
        _lable = [[UILabel alloc] init];
        _lable.backgroundColor = [UIColor clearColor];
        _lable.font = [UIFont getButtonFont];
        _lable.textColor = [UIColor darkGrayColor];
        _progressView = [[LBProgressBar alloc] initWithFrame:CGRectZero];
        
        UIImage * bgImg = Image(@"upload_bar_bg.png");
        bgImg = [bgImg stretchableImageWithLeftCapWidth:2 topCapHeight:2];
        [_progressView setBackgroundImage:bgImg];
        
        UIImage * fgImg = Image(@"upload_bar_fg.png");
        fgImg = [fgImg stretchableImageWithLeftCapWidth:2 topCapHeight:2];
        [_progressView setProgressImage:fgImg];
        
        [self addSubview:_imageView];
        [self addSubview:_lable];
        [self addSubview:_progressView];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickView)];
        _gesture.delegate = self;
        self.style = 0;        
    }
    return self;
}

- (float)defaultHeight
{
    return 48;
}

- (void)didClickView
{
    LBUploadManagerController * controller  = [[LBUploadManagerController alloc] init];
    [[UIViewController getTopNavigation] pushViewController:controller animated:YES];
    //self.shouldReceiveTouch = NO;
}

- (void)layoutSubviews
{
    CGSize imgSize = CGSizeMake(34, 34);
    
    if(_style == LBUploadViewStyleUploadCell)
        _imageView.frame = CGRectMake(12, (self.height-imgSize.height)/2, imgSize.width, imgSize.height);
    else
        _imageView.frame = CGRectMake(12, (self.height-imgSize.height)/2-2, imgSize.width, imgSize.height);
    
    if([_lable.text isEqualToString:@"等待上传"])
        _lable.frame = CGRectMake(_imageView.right + 9, (self.height-20)/2, 200, 20);
    else
        _lable.frame = CGRectMake(_imageView.right + 9, _imageView.top+1, 200, 20);

    _progressView.frame =  CGRectMake(_imageView.right+9, _imageView.bottom-10, self.width-_imageView.right-60, 6);
    
    _mark.center = CGPointMake(self.width - 20, self.height/2);
}


- (void)setStyle:(LBUploadViewStyle)style
{
    _style = style;
    NSLog(@"LBUploadViewStyleUploadCell:%d",LBUploadViewStyleUploadCell);
    NSLog(@"LBUploadViewStyleMainView:%d",LBUploadViewStyleMainView);

    [self update];
}

- (void)update
{
    LBUploadTaskManager * manager = [LBUploadTaskManager sharedInstance];
    if(_style == LBUploadViewStyleUploadCell)
    {
        //_shouldReceiveTouch = NO;
        _mark.hidden = YES;
        self.backgroundColor = RGB(244,244,244);
        self.image = nil;
        [self removeGestureRecognizer:_gesture];
        //self.userInteractionEnabled = NO;


        if([manager.uploadTask hasIndex:0])
        {
            _lable.text = @"正在上传";
            _lable.frame = CGRectMake(_imageView.right + 9, _imageView.top+1, 200, 20);
            _progressView.hidden = NO;
            LBUploadTask * task = manager.uploadTask[0];
            _imageView.image = [LBCameraTool getThumbImageWithPath:task.path];
        }
        else if([manager.draftTask hasIndex:0])
        {
            _lable.text = @"等待上传";
            _lable.frame = CGRectMake(_imageView.right + 9, (self.height-20)/2, 200, 20);
            _progressView.hidden = YES;
            LBUploadTask * task = manager.draftTask[0];
            _imageView.image = [LBCameraTool getThumbImageWithPath:task.path];
        }
        else if([manager.failedTask hasIndex:0])
        {
            _lable.text = @"等待上传";
            _lable.frame = CGRectMake(_imageView.right + 9, (self.height-20)/2, 200, 20);
            _progressView.hidden = YES;
            LBUploadTask * task = manager.failedTask[0];
            _imageView.image = [LBCameraTool getThumbImageWithPath:task.path];
        }
        else
        {
            _lable.text = @"等待上传";
            _lable.frame = CGRectMake(_imageView.right + 9, (self.height-20)/2, 200, 20);
            _progressView.hidden = YES;
            _imageView.image = nil;
        }
    }
    else
    {
        //self.userInteractionEnabled = YES;
        [self addGestureRecognizer:_gesture];
        //_shouldReceiveTouch = YES;
        _mark.hidden = NO;
        self.backgroundColor = [UIColor clearColor];
        self.image = _shadowBg;

        if([manager.uploadTask hasIndex:0])
        {
            _lable.text = [NSString stringWithFormat:@"正在上传(%d个视频)",manager.uploadTask.count];
            _lable.frame = CGRectMake(_imageView.right + 9, _imageView.top+1, 200, 20);
            _progressView.hidden = NO;
            LBUploadTask * task = manager.uploadTask[0];
            _imageView.image = [LBCameraTool getThumbImageWithPath:task.path];
        }
        else if([manager.draftTask hasIndex:0])
        {
            _lable.text = @"等待上传";
            _lable.frame = CGRectMake(_imageView.right + 9, (self.height-20)/2, 200, 20);
            _progressView.hidden = YES;
            LBUploadTask * task = manager.draftTask[0];
            _imageView.image = [LBCameraTool getThumbImageWithPath:task.path];
        }
        else if([manager.failedTask hasIndex:0])
        {
            _lable.text = @"等待上传";
            _lable.frame = CGRectMake(_imageView.right + 9, (self.height-20)/2, 200, 20);
            _progressView.hidden = YES;
            LBUploadTask * task = manager.failedTask[0];
            _imageView.image = [LBCameraTool getThumbImageWithPath:task.path];
        }
        else
        {
            _lable.text = @"等待上传";
            _lable.frame = CGRectMake(_imageView.right + 9, (self.height-20)/2, 200, 20);
            _progressView.hidden = YES;
            _imageView.image = nil;
        }
    }
}

- (int)taskNumber
{
    return [[LBUploadTaskManager sharedInstance] taskNumber];
}
#pragma UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}
@end

@interface LBUploadTaskManager()
{
    
}
@end
@implementation LBUploadTaskManager
@synthesize uploadTask = _uploadTask;
@synthesize draftTask = _draftTask;
@synthesize failedTask = _failedTask;

+ (LBUploadTaskManager *)sharedInstance
{
    static LBUploadTaskManager *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance refreshAllTask];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        _isUploading = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountDidChange:) name:LoginDidChangeNotification object:nil];
        //[self refreshAllTask];
        [self addObserver:self forKeyPath:@"_uploadTask" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"_draftTask" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"_failedTask" options:0 context:NULL];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidChanged:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"_uploadTask"];
    [self removeObserver:self forKeyPath:@"_draftTask"];
    [self removeObserver:self forKeyPath:@"_failedTask"];
}

- (void)refreshAllTask
{
    NSString * userId = [[AccountHelper getAccount] AccountID];
    if(userId.length == 0)
    {
        _tasks = [NSArray array];
    }
    else
    {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userId == %@",userId];
        _tasks = [[CoreDataAccess sharedInstance] getRecordsFromTable:@"LBUploadTask" withPredicate:predicate onColumn:@"date" Ascending:YES withFaulting:YES];
    }
    NSMutableArray * tempFails = [NSMutableArray arrayWithCapacity:_tasks.count];
    NSMutableArray * tempDrafts = [NSMutableArray arrayWithCapacity:_tasks.count];
    NSMutableArray * tempUploads = [NSMutableArray arrayWithCapacity:_tasks.count];

    for(LBUploadTask * obj in _tasks)
    {
        if(![[NSFileManager defaultManager] fileExistsAtPath:obj.path])
        {
            [obj remove];
            continue;
        }
        UploadTaskStatus status = [obj.uploadStatus intValue];
        if(status == UploadTaskStatusDraft)
        {
            [tempDrafts addObject:obj];
        }
        else if(status == UploadTaskStatusFailed)
        {
            [tempFails addObject:obj];
        }
        else if(status == UploadTaskStatusUploading)
        {
            [tempUploads insertObject:obj atIndex:0];
        }
        else if(status == UploadTaskStatusPrepare)
        {
            [tempUploads addObject:obj];
        }
        else if(status == UploadTaskStatusDelete)
        {
            [obj remove];
        }
    }
    [tempUploads sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        LBUploadTask * task1 = (LBUploadTask *)obj1;
        LBUploadTask * task2 = (LBUploadTask *)obj2;
        if([task1.uploadIndex intValue] > [task2.uploadIndex intValue])
            return NSOrderedAscending;
        else if([task1.uploadIndex intValue] < [task2.uploadIndex intValue])
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
    _failedTask =  tempFails;
    _draftTask = tempDrafts;
    _uploadTask = tempUploads;
    [self reIndexUploadTasks];
    [self checkForStart];
}

- (void)reIndexUploadTasks
{
    [_uploadTask enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(LBUploadTask *)obj setUploadIndex:[NSNumber numberWithInt:idx]];
    }];
}

+ (void)uploadMovieWithPath:(NSString *)path
{
    UIImage * thumb = [LBCameraTool getThumbImageWithPath:path];
    NSDictionary * dict = @{@"movie":path, @"photo":thumb, @"content":@"testUploading"};
    [[LBFileClient sharedInstance] publishLebo:dict cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData delegate:[LBUploadTaskManager sharedInstance] selector:@selector(didFinishUpload:) selectorError:@selector(didFailedUpload:) progressSelector:@selector(didUploadData:)];
}

- (void)managedObjectContextDidSave:(NSNotification *)sender
{
    NSLog(@"managedObjectContextDidSave");
    [self refreshAllTask];
}

- (void)managedObjectContextDidChanged:(NSNotification *)sender
{
    
}

- (LBUploadTask *)addTaskWithPath:(NSString *)path
                          content:(NSString *)content
                        sinaShare:(BOOL)sinaShare
                      renrenShare:(BOOL)renrenShare
{
    NSString * uId =  [[AccountHelper getAccount] AccountID];
    __block LBUploadTask * realTask = nil;
    [[CoreDataAccess sharedInstance] addRecordWithCallback:^(NSManagedObject *object) {
        LBUploadTask * newTask = (LBUploadTask *)object;
        newTask.path = path;
        newTask.content = content;
        newTask.date = [NSDate date];
        newTask.sina = @(sinaShare);
        newTask.renren = @(renrenShare);
        newTask.userId = uId;
        realTask = newTask;
    } inEntity:@"LBUploadTask"];
    [self.draftTask insertObject:realTask atIndex:0];
    return realTask;
}

- (void)startTask:(LBUploadTask *)task
{
    if([task.uploadStatus intValue] == UploadTaskStatusDraft)
        [self.draftTask removeObject:task];
    else if([task.uploadStatus intValue] == UploadTaskStatusFailed)
        [self.failedTask removeObject:task];
    if(!_cuTask)
    {
        _isUploading = YES;
        task.uploadStatus = [NSNumber numberWithInt:UploadTaskStatusUploading];
        _cuTask = task;
        
        UIImage * thumb = [LBCameraTool getThumbImageWithPath:task.path];
        NSDictionary * dict = @{@"movie":task.path,@"photo":thumb,@"content":task.content};
        _cuTask = task;
        [[LBFileClient sharedInstance] publishLebo:dict cachePolicy:NSURLRequestReloadIgnoringLocalCacheData delegate:self selector:@selector(didFinishUpload:) selectorError:@selector(didFailedUpload:) progressSelector:@selector(didUploadData:)];
        //LBUploadView * temp = (LBUploadView *)self.uploadingView;
        //temp.imageView.image = thumb;
    }
    else
    {
        task.uploadStatus = [NSNumber numberWithInt:UploadTaskStatusPrepare];
    }
    if(![self.uploadTask containsObject:task])
    {
        task.uploadIndex = [NSNumber numberWithInt:[self uploadTask].count];
        [self.uploadTask addObject:task];
        //[self reIndexUploadTasks];
    }
    else
    {
        id info = self.uploadTask;
        [[NSNotificationCenter defaultCenter] postNotificationName:LBUploadTaskManagerDidChangeInfo object:self userInfo:@{LBUploadTaskChangedInfo:info}];
    }
}

- (void)removeTasks:(LBUploadTask *)task
{
    if([task.uploadStatus intValue] == UploadTaskStatusDraft)
    {
        [[self draftTask] removeObject:task];
         [task remove];
    }
    else if([task.uploadStatus intValue] == UploadTaskStatusFailed)
    {
        [self.failedTask removeObject:task];
         [task remove];
    }
    else if([task.uploadStatus intValue] == UploadTaskStatusPrepare)
    {
        [self.uploadTask removeObject:task];
        //[self reIndexUploadTasks];
         [task remove];
    }
    else
    {
        [self.uploadTask removeObject:task];
        task.uploadStatus = @(UploadTaskStatusDelete);
        [LBUploadSender cancelCurrentUploadRequest];
        //[self reIndexUploadTasks];
    }
}

- (void)moveToFailed:(LBUploadTask *)task
{
    task.date = [NSDate date];
    if([task.uploadStatus intValue] == UploadTaskStatusDraft)
        [self.draftTask removeObject:task];
    else if([task.uploadStatus intValue] == UploadTaskStatusFailed)
        return;
    else
    {
        [self.uploadTask removeObject:task];
        //[self reIndexUploadTasks];
    }
    task.uploadStatus = @(UploadTaskStatusFailed);
    [self.failedTask insertObject:task atIndex:0];
}

- (void)checkForStart
{
    if(_cuTask)
        return;
    if([_uploadTask hasIndex:0])
    {
        LBUploadTask * task = _uploadTask[0];
        [self startTask:task];
    }
}

- (LBUploadView *)uploadingView
{
    if(_uploadingView == nil)
    {
        _uploadingView = [[LBUploadView alloc] init];
    }
    return _uploadingView;
}

- (int)taskNumber
{
    return _uploadTask.count + _draftTask.count + _failedTask.count;
}

#pragma mark NSNotification

- (void)accountDidChange:(NSNotification *)sender
{
    [self refreshAllTask];
    [self.uploadingView update];
    [[NSNotificationCenter defaultCenter] postNotificationName:LBUploadTaskManagerDidChangeInfo object:self userInfo:@{LBUploadTaskChangedInfo:self.uploadTask}];
    [[NSNotificationCenter defaultCenter] postNotificationName:LBUploadTaskManagerDidChangeInfo object:self userInfo:@{LBUploadTaskChangedInfo:self.draftTask}];
    [[NSNotificationCenter defaultCenter] postNotificationName:LBUploadTaskManagerDidChangeInfo object:self userInfo:@{LBUploadTaskChangedInfo:self.failedTask}];
    [[NSNotificationCenter defaultCenter] postNotificationName:LBUploadViewDidChange object:self userInfo:@{LBUploadTaskNumberKey:@([self taskNumber])}];
}

#pragma mark KVO

- (NSMutableArray *)uploadTask
{
    id obj = [self mutableArrayValueForKey:@"_uploadTask"];
    return obj ;
}

- (NSMutableArray *)draftTask
{
    id obj = [self mutableArrayValueForKey:@"_draftTask"];
    return obj;
}

- (NSMutableArray *)failedTask
{
    id obj = [self mutableArrayValueForKey:@"_failedTask"];
    return obj;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    id info = nil;
    if([keyPath isEqualToString:@"_uploadTask"])
    {
        info = self.uploadTask;
        [self reIndexUploadTasks];
    }
    else if([keyPath isEqualToString:@"_draftTask"])
        info = self.draftTask;
    else if([keyPath isEqualToString:@"_failedTask"])
        info = self.failedTask;
    [self.uploadingView update];
    [[NSNotificationCenter defaultCenter] postNotificationName:LBUploadTaskManagerDidChangeInfo object:self userInfo:@{LBUploadTaskChangedInfo:info}];
    [[NSNotificationCenter defaultCenter] postNotificationName:LBUploadViewDidChange object:self userInfo:@{LBUploadTaskNumberKey:@([self taskNumber])}];
}

#pragma mark UploadCallback

- (void)didFinishUpload:(NSData *)data
{   
    NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"successUpload:%@",result);
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if([dict[@"error"] isEqualToString:@"OK"])
    {
        _isUploading = NO;
        LBUploadView * temp = (LBUploadView *)self.uploadingView;
        temp.progressView.progress = 0;
        temp.imageView.image = nil;
        NSString * movieID = dict[@"result"][@"movieID"];
        NSString * movieURL = dict[@"result"][@"movieUrl"];
        //NSString * realUrl = [[Global getServerUrl2] stringByAppendingString:movieURL];
        if([[_cuTask sina] boolValue] == YES || [[_cuTask renren] boolValue] == YES)
        {
            NSString * accountId = [AccountHelper getAccount].AccountID;
            if([accountId isEqualToString:_cuTask.userId])
            {
                NSString * moviePath = [_cuTask path];
                UIImage * image = [LBCameraTool getThumbImageWithPath:moviePath];
                //NSString * contentString = _cuTask.content;
                
                NSString * defaultText = [[NSUserDefaults standardUserDefaults] objectForKey:@"shareData"][@"publishText"];
 
                if([[_cuTask sina] boolValue] == YES)
                {
                    [[SinaHelper getHelper] uploadPicture:UIImageJPEGRepresentation(image, 0.8) status:defaultText target:nil movieID:movieID];
                }
                if([[_cuTask renren] boolValue] == YES)
                {
                    [RenRenHelper shareMovieToRenRenMovieID:movieID content:defaultText alert:NO target:nil];
                }
            }
        }
        //将该视频移到缓存区
        [[NSFileManager defaultManager] moveItemAtPath:_cuTask.path toPath:[LBCameraTool getCachePathForRemotePath:movieURL] error:nil];
        
        [self removeTasks:_cuTask];
        _cuTask = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:LBUploadTaskDidFinished object:nil];
        [self checkForStart];
    }
    else
    {
        [self didFailedUpload:data];
        return;
    }
}

- (NSString *)joinlongUrl:(NSString *)movieID{
    return [NSString stringWithFormat:@"%@/?cmd=GEOWEIBOD.playFlash+%@",[Global getServerBaseUrl], movieID];
}

- (void)didFailedUpload:(id)data
{
    _isUploading = NO;
    LBUploadView * temp = (LBUploadView *)self.uploadingView;
    temp.progressView.progress = 0;
    temp.imageView.image = nil;
    if([data isKindOfClass:[NSError class]])
    {
        NSLog(@"failedUpload:%@",data);
    }
    else
    {
        NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"failedUpload:%@",result);
    }
    if([_cuTask.uploadStatus intValue] == UploadTaskStatusDelete)
    {
        [_cuTask remove];
    }
    else
        [self moveToFailed:_cuTask];
     _cuTask = nil;
    [self checkForStart];
}

- (void)didUploadData:(NSNumber *)percent
{
    float progress = [percent floatValue];
    LBUploadView * temp = (LBUploadView *)self.uploadingView;
    temp.progressView.progress = progress;
}

@end