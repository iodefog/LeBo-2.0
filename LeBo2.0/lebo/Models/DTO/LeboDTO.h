//
//  LeboDTO.h
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTOBase.h"

@interface LeboDTO : DTOBase {
	NSString *LeboID;
	NSString *Content;
    NSString *AuthorID;
    NSString *AuthorKey;
    NSString *AuthorPhotoID;
    NSString *AuthorPhotoURL;
	NSDate *SubmitTime;
	NSString *PhotoID;
    NSString *PhotoURL;
    NSString *MovieID;
    NSString *MovieURL;
    NSInteger LoveCount;
    NSInteger Love;
    NSString *AuthorDisplayName;
    CGFloat expandOffset;
    NSInteger CommentCount;
    NSArray *Comment;
    NSArray *LoveUserAttachments;
    NSInteger Relay;
    NSInteger RelayCount;
    NSInteger PlayCount;
    NSString *BroadcastDisplayName;
    NSInteger isRecommend;
    NSString *BroadcastAuthor;
}

@property (nonatomic, readonly) NSString *LeboID;
@property (nonatomic, readonly) NSString *Content;
@property (nonatomic, readonly) NSString *AuthorID;
@property (nonatomic, readonly) NSString *AuthorKey;
@property (nonatomic, readonly) NSString *AuthorPhotoID;
@property (nonatomic, readonly) NSString *AuthorPhotoURL;
@property (nonatomic, readonly) NSDate *SubmitTime;
@property (nonatomic, readonly) NSString *PhotoID;
@property (nonatomic, readonly) NSString *PhotoURL;
@property (nonatomic, readonly) NSString *MovieID;
@property (nonatomic, readonly) NSString *MovieURL;
@property (nonatomic, assign) NSInteger LoveCount;
@property (nonatomic, assign) NSInteger Love;
@property (nonatomic, assign) CGFloat expandOffset;
@property (nonatomic, readonly) NSString *AuthorDisplayName;
@property (nonatomic, readonly) NSInteger CommentCount;
@property (nonatomic, retain) NSArray *Comment;
@property (nonatomic, retain) NSArray *LoveUserAttachments;
@property (nonatomic, assign) NSInteger Relay;
@property (nonatomic, assign) NSInteger RelayCount;
@property (nonatomic, assign) NSInteger PlayCount;
@property (nonatomic, readonly) NSString *BroadcastDisplayName;
@property (nonatomic, assign) NSInteger isRecommend;
@property (nonatomic, retain) NSString *BroadcastAuthor;

@end
