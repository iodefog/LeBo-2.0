//
//  RequestSender.h
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface LBRequestSender : AFHTTPClient
{
    NSString *requestUrl;
    NSDictionary *dictParam;
    id deletage;
    SEL completeSelector;
    SEL errorSelector;
    BOOL usePost;
}

@property (nonatomic, retain) NSString *requestUrl;
@property (nonatomic, retain) NSDictionary *dictParam;
@property (nonatomic, weak) id delegate;
@property (nonatomic) SEL completeSelector;
@property (nonatomic) SEL errorSelector;
@property (nonatomic, assign) BOOL usePost;
@property (nonatomic)NSURLRequestCachePolicy cachePolicy;

+ (id)requestSenderWithURL:(NSString *)theUrl
                   usePost:(BOOL)isPost
                     param:(NSDictionary *)dictParam
                  cachePolicy:(NSURLRequestCachePolicy)cholicy
                  delegate:(id)theDelegate 
          completeSelector:(SEL)theCompleteSelector 
             errorSelector:(SEL)theErrorSelector
          selectorArgument:(id)theSelectorArgument;

- (void)send;

@end
