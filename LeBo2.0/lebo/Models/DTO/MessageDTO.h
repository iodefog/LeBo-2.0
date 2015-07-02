//
//  MessageDTO.h
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTOBase.h"

typedef enum {
    MessageHide = 0,
    MessagePending,
    MessageFail,
    MessageSent,
    MessageRead,
    MessageIgnore
} MessageStatus;

@interface MessageDTO : DTOBase {
	NSString *MessageID;
    NSString *LocalID;
	NSString *Content;
    NSString *AuthorID;
    NSString *ChaterName;
	NSDate *SubmitTime;
	NSDate *UpdateTime;
	NSString *PhotoID;
    NSString *ToPhotoID;
    NSString *SessionID;
    NSInteger Status;
    BOOL isSend;
    BOOL isShowTime;
    NSNumber *isFirstChater;
    NSString *DisplayName;
    NSString *ChaterDisplayName;
}

@property (nonatomic, copy) NSString *MessageID;
@property (nonatomic, copy) NSString *LocalID;
@property (nonatomic, copy) NSString *Content;
@property (nonatomic, copy) NSString *AuthorID;
@property (nonatomic, copy) NSString *ChaterName;
@property (nonatomic, copy) NSDate *SubmitTime;
@property (nonatomic, copy) NSDate *UpdateTime;
@property (nonatomic, copy) NSString *PhotoID;
@property (nonatomic, copy) NSString *ToPhotoID;
@property (nonatomic, copy) NSString *SessionID;
@property (nonatomic, copy) NSString *DisplayName;
@property (nonatomic, copy) NSString *ChaterDisplayName;
@property (nonatomic, assign) NSInteger Status;
@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, assign) BOOL isShowTime;
@property (nonatomic, retain) NSNumber *isFirstChater;

@end
