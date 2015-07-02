//
//  RequestSender.m
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBRequestSender.h"
#import "SBJSON.h"
#import "AFHTTPRequestOperation.h"
#import "Global.h"
#import "AccountHelper.h"
#import "AccountDTO.h"

static const float TIME_OUT_INTERVAL = 30.0f;

@implementation LBRequestSender

@synthesize requestUrl;
@synthesize usePost;
@synthesize dictParam;
@synthesize delegate;
@synthesize completeSelector;
@synthesize errorSelector;
@synthesize cachePolicy;

+ (id)requestSenderWithURL:(NSString *)theUrl
                   usePost:(BOOL)isPost
                     param:(NSDictionary *)dictParam
               cachePolicy:(NSURLRequestCachePolicy)cholicy
                  delegate:(id)theDelegate
          completeSelector:(SEL)theCompleteSelector
             errorSelector:(SEL)theErrorSelector
          selectorArgument:(id)theSelectorArgument
{
    LBRequestSender *requestSender = [[LBRequestSender alloc] init];
    requestSender.requestUrl = theUrl;
    requestSender.usePost = isPost;
    //
    NSMutableDictionary *params = [dictParam objectForKey:@"params"];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"account"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"session"]) {
        [params setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"account"] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:@"Global_UserName"];
        [params setObject: [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"Global_AccessToken"];
        [params setObject: [[NSUserDefaults standardUserDefaults] objectForKey:@"session"] forKey:@"Global_SessionID"];
    }
    
    requestSender.dictParam = dictParam;
    requestSender.delegate = theDelegate;
    requestSender.completeSelector = theCompleteSelector;
    requestSender.errorSelector = theErrorSelector;
    requestSender.cachePolicy = cholicy;
    NSLog(@"%@ %@", theUrl, dictParam);
    return requestSender;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.usePost = NO;
        self.dictParam = nil;
        self.delegate = nil;
        self.completeSelector = nil;
        self.errorSelector = nil;
        self.cachePolicy = 0;
    }
    
    return self;
}

- (void)send
{
    NSLog(@"---send--->%@\n---API--->%@", [NSURL URLWithString:self.requestUrl], [self.dictParam objectForKey:@"method"]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]
                                                           cachePolicy:self.cachePolicy//NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:TIME_OUT_INTERVAL];
    
   
    
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:dictParam options:0 error:nil]];
  
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       if(self.delegate && self.completeSelector)
       {
           if([self.delegate respondsToSelector:self.completeSelector])
           {
               [self.delegate performSelector:self.completeSelector withObject:responseObject];
           }
       }
    
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSURLCache *urlCache = [NSURLCache sharedURLCache];
        [urlCache setMemoryCapacity:1*1024*1024];
        NSCachedURLResponse *response =
        [urlCache cachedResponseForRequest:request];
        //判断是否有缓存
        if (response != nil && self.delegate && self.completeSelector)
        {
            if([self.delegate respondsToSelector:self.completeSelector])
            {
                [self.delegate performSelector:self.completeSelector withObject:response.data];
                [urlCache removeCachedResponseForRequest:request];
            }
        }
        else
        {
            if(self.delegate && self.errorSelector)
            {
                if([self.delegate respondsToSelector:self.errorSelector])
                {
                    [self.delegate performSelector:self.errorSelector withObject:error];
                }
            }
        }
	}];
	
	[operation start];
}

- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method path:(NSString *)path
{
}
@end
