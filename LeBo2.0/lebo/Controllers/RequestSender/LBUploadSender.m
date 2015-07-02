//
//  LBUploadSender.m
//  lebo
//
//  Created by 乐播 on 13-3-29.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBUploadSender.h"

#import "SBJSON.h"
#import "AFHTTPRequestOperation.h"
#import "Global.h"
#import "AccountHelper.h"
#import "AccountDTO.h"

static const float TIME_OUT_INTERVAL = 30.0f;

@implementation LBUploadSender

//@synthesize requestUrl;
//@synthesize usePost;
//@synthesize dictParam;
//@synthesize delegate;
//@synthesize completeSelector;
//@synthesize errorSelector;
//@synthesize cachePolicy;
+ (id)currentClient
{
    static AFHTTPClient *sharedInstance = nil;
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        sharedInstance = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        [sharedInstance.operationQueue setMaxConcurrentOperationCount:1];
    });
    return sharedInstance;
}

+ (id)requestSenderWithURL:(NSString *)theUrl
                   usePost:(BOOL)isPost
               cachePolicy:(NSURLRequestCachePolicy)cholicy
                  delegate:(id)theDelegate
          completeSelector:(SEL)theCompleteSelector
             errorSelector:(SEL)theErrorSelector
          selectorArgument:(id)theSelectorArgument
{
    LBUploadSender *requestSender = [[self alloc] init];
    requestSender.usePost = isPost;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"account"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"session"])
    {
        requestSender.requestUrl = [theUrl stringByAppendingFormat:@"&Global_UserName=%@&Global_AccessToken=%@&Global_SessionID=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"account"] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding], [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], [[NSUserDefaults standardUserDefaults] objectForKey:@"session"]];
        requestSender.requestUrl = [requestSender.requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else
        requestSender.requestUrl =  [theUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    requestSender.delegate = theDelegate;
    requestSender.completeSelector = theCompleteSelector;
    requestSender.errorSelector = theErrorSelector;
    requestSender.cachePolicy = cholicy;
    NSLog(@"%@", theUrl);
    return requestSender;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.usePost = NO;
        self.cachePolicy = 0;
    }
    
    return self;
}

- (void)send
{
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:self.requestUrl  parameters:nil constructingBodyWithBlock: ^(id formData)
    {
        NSData * data = UIImageJPEGRepresentation(self.image, 0.8);
        NSLog(@"image length:%d",[data length]);
        if(self.videoPath)
        {
            NSLog(@"self.videoPath:%@",self.videoPath);
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:self.videoPath] name:@"movie" error:nil];
            //[formData appendPartWithFileURL:[NSURL fileURLWithPath:self.videoPath] name:@"movie" fileName:@"movie.mp4" mimeType:@"video/mp4" error:nil];
        }
        [formData appendPartWithFileData:data name:@"photo" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        
    }];
    [request setTimeoutInterval:999999];
//    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:self.dictParam options:0 error:nil]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(self.delegate && self.completeSelector)
        {
            NSLog(@"responseObject: %@", responseObject);
            [self.delegate performSelector:self.completeSelector withObject:responseObject];
        }
        
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error : %@",error);
        if(self.delegate && self.errorSelector){
            [self.delegate performSelector:self.errorSelector withObject:error];
        }
	}];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if([self.delegate respondsToSelector:self.progressSelector])
        {
            float percent = (float)totalBytesWritten/totalBytesExpectedToWrite;
            [self.delegate performSelector:self.progressSelector withObject:[NSNumber numberWithFloat:percent]];
        }
    }];
	//[operation  start];
    
    [[LBUploadSender currentClient] enqueueHTTPRequestOperation:operation];
}

+ (void)cancelCurrentUploadRequest
{
    for (NSOperation *operation in [[[LBUploadSender currentClient] operationQueue] operations])
    {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]])
            continue;
        [operation cancel];
    }
}
@end
