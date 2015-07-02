//
//  LBMovieDownloader.m
//  lebo
//
//  Created by 乐播 on 13-4-2.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBMovieDownloader.h"
#import "AFImageRequestOperation.h"
#import "LBCameraTool.h"
#import "AFDownloadRequestOperation.h"
@implementation LBMovieDownloader
+ (id)sharedInstance
{
    static LBMovieDownloader *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        _downloadQueue = dispatch_queue_create("com.LeBodownLoadQueue", NULL);
        _taskArray = [[NSMutableArray alloc] init];
        _client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[Global getServerBaseUrl]]];
        [_client.operationQueue setMaxConcurrentOperationCount:1];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operationDidStart:) name:AFNetworkingOperationDidStartNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    dispatch_release(_downloadQueue);
}

//- (NSString *)dowloadingPath
//{
//    AFHTTPRequestOperation * operation = [_client.operationQueue.operations lastObject];
//    return operation.userInfo[@"path"];
//}

- (float)downloadPercent
{
    return _progress;
}

- (BOOL)isDownloading
{
    //return !!_progress;
    if(!self.dowloadingPath)
        return NO;
    
    for(AFHTTPRequestOperation * operation in _client.operationQueue.operations)
    {
        NSString * newPath = [[[(AFHTTPRequestOperation *)operation request] URL] absoluteString];
        if([newPath hasSuffix:self.dowloadingPath] && [operation isExecuting] == YES)
        {
            return YES;
        }
    }
    return NO;
}

- (void)operationDidStart:(NSNotification *)sender
{
    NSLog(@"operationDidStart");
    AFHTTPRequestOperation * operation = sender.object;
    if([self.progressDelegate respondsToSelector:@selector(movieDownloaderDidStart:)])
    {
        [self.progressDelegate movieDownloaderDidStart:operation.userInfo[@"path"]];
    }
    _progress = 0;
}

- (void)addMoviePath:(NSString *)path delegate:(__weak id<LBMovieDownloaderDelegate>)delegate
{
    //
    
        NSString * cachePath = [LBCameraTool getCachePathForRemotePath:path];
        if([[NSFileManager defaultManager] fileExistsAtPath:cachePath])
        {
            if([delegate respondsToSelector:@selector(movieDownloaderDidFinished:)])
                [(id)delegate performSelectorOnMainThread:@selector(movieDownloaderDidFinished:) withObject:path waitUntilDone:NO];
            return;
        }
        NSLog(@"befor cancel operation count :%d",_taskArray.count);
        
        
        AFHTTPRequestOperation * temp = nil;
        if([self pathIsEnqueue:path operation:&temp])
        {
            return;
        }
        
        [self cancelAllWaitingOperation];
        NSLog(@"after cancel operation count :%d",_taskArray.count);
        _dowloadingPath = [path copy];
        NSURLRequest *request = [_client requestWithMethod:@"GET" path:path parameters:nil];
        NSString * loacalPath = [LBCameraTool getCachePathForRemotePath:path];
        AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:loacalPath shouldResume:NO];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             @synchronized(self)
             {
                 if(_dowloadingPath == path)
                     _dowloadingPath = nil;
             }
             NSLog(@"did finish download:%@",operation.request.URL);
             NSData * data = (NSData *)responseObject;
             if(data.length == 0)
             {
                 if([delegate respondsToSelector:@selector(movieDownloaderDidFailed:)])
                 {
                     [(id)delegate performSelectorOnMainThread:@selector(movieDownloaderDidFailed:) withObject:path waitUntilDone:NO];
                 }
             }
             else
             {
                 //[data writeToFile:[LBCameraTool getCachePathForRemotePath:path] atomically:YES];
                 if([delegate respondsToSelector:@selector(movieDownloaderDidFinished:)])
                     [(id)delegate performSelectorOnMainThread:@selector(movieDownloaderDidFinished:) withObject:path waitUntilDone:NO];
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             @synchronized(self)
             {
                 if(_dowloadingPath == path)
                     _dowloadingPath = nil;
             }
             if([delegate respondsToSelector:@selector(movieDownloaderDidFailed:)])
             {
                 [(id)delegate performSelectorOnMainThread:@selector(movieDownloaderDidFailed:) withObject:path waitUntilDone:NO];
             }
         }];
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
        {
            //NSLog(@"totalBytesRead:%lld totalBytesExpectedToRead:%lld",totalBytesRead,totalBytesExpectedToRead);
            float percent = (float)totalBytesRead/totalBytesExpectedToRead;
            [self didDownloadPercent:percent];
        }];
        operation.userInfo = @{@"delegate":delegate , @"path":path};
        @synchronized(self)
        {
            [_client enqueueHTTPRequestOperation:operation];
        }
        NSLog(@"enqueuedOperation count :%d",_client.operationQueue.operations.count);
    //});
    
}

- (void)didDownloadPercent:(float)percent
{
    NSLog(@"percent:%f",percent);
    if(_progress == 0)
    {
        if([self.progressDelegate respondsToSelector:@selector(movieDownloaderDidStart:)])
        {
            [self.progressDelegate movieDownloaderDidStart:self.dowloadingPath];
        }
    }
    _progress = percent;
    if([self.progressDelegate respondsToSelector:@selector(movieDownloaderProgress:)])
    {
        [(id)self.progressDelegate performSelectorOnMainThread:@selector(movieDownloaderProgress:) withObject:[NSNumber numberWithFloat:percent] waitUntilDone:NO];
    }
}

- (BOOL)pathIsEnqueue:(NSString *)path operation:(AFHTTPRequestOperation **)result
{
    for(AFHTTPRequestOperation * operation in _client.operationQueue.operations)
    {
        NSString * newPath = [[[(AFHTTPRequestOperation *)operation request] URL] absoluteString];
        if([newPath hasSuffix:path] && [operation isCancelled] == NO)
        {
            *result = operation;
            return YES;
        }
    }
    return NO;
}

- (void)cancelAllWaitingOperation
{
    for(AFHTTPRequestOperation * operation in _client.operationQueue.operations)
    {
        [operation cancel];
    }
    _progress = 0;
}


@end
