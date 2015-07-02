//
//  LBUploadSender.h
//  lebo
//
//  Created by 乐播 on 13-3-29.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
@interface LBUploadSender : AFHTTPClient
{
//    NSString *requestUrl;
//    NSDictionary *dictParam;
//    NSDictionary * uploadPrama;
//    id deletage;
//    SEL completeSelector;
//    SEL errorSelector;
//    BOOL usePost;
}

@property (nonatomic, copy) NSString *requestUrl;
@property (nonatomic, copy) NSDictionary *dictParam;
@property (nonatomic,copy)  NSDictionary * uploadPrama;
@property (nonatomic, weak) id delegate;
@property (nonatomic) SEL completeSelector;
@property (nonatomic) SEL errorSelector;
@property (nonatomic) SEL progressSelector;
@property (nonatomic, assign) BOOL usePost;
@property (nonatomic)NSURLRequestCachePolicy cachePolicy;
@property (nonatomic,retain) UIImage * image;
@property (nonatomic,copy) NSString * videoPath;
+ (id)requestSenderWithURL:(NSString *)theUrl
                   usePost:(BOOL)isPost
               cachePolicy:(NSURLRequestCachePolicy)cholicy
                  delegate:(id)theDelegate
          completeSelector:(SEL)theCompleteSelector
             errorSelector:(SEL)theErrorSelector
          selectorArgument:(id)theSelectorArgument;


- (void)send;
+ (void)cancelCurrentUploadRequest;

@end
