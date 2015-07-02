//
//  CommentDTO.h
//  LeBo
//
//  Created by King on 13-3-13.
//
//

#import "DTOBase.h"

@interface CommentDTO : DTOBase {
    NSString *CommentID;
    NSString *Content;
    NSString *CommentAuthorID;
    NSString *CommentAuthorDisplayName;
    NSString *CommentAuthorPhotoID;
    NSString *CommentAuthorPhotoUrl;
    NSDate   *CommentSubmitTime;
    NSString *CommentTo;
}

@property (nonatomic, readonly) NSString *CommentID;
@property (nonatomic, readonly) NSString *Content;
@property (nonatomic, readonly) NSString *CommentAuthorID;
@property (nonatomic, readonly) NSString *CommentAuthorDisplayName;
@property (nonatomic, readonly) NSString *CommentAuthorPhotoID;
@property (nonatomic, readonly) NSString *CommentAuthorPhotoUrl;
@property (nonatomic, readonly) NSDate *CommentSubmitTime;
@property (nonatomic, readonly) NSString *CommentTo;

@end
