//
//  NoticeDto.h
//  LeBo
//
//  Created by King on 13-3-15.
//
//

#import "DTOBase.h"

@interface NoticeDTO : DTOBase
{
    NSString *NoticeType;
    NSDate   *SubmitTime;
    NSString *SourceTopicID;
    NSString *SourcePhotoID;
    NSString *SourcePhotoUrl;
    NSString *SourceMovieID;
    NSString *SourceMovieUrl;
    NSString *Content;
    NSString *CommentID;
    NSString *Author;
    NSString *AuthorDisplayName;
    NSString *AuthorPhotoID;
    NSString *AuthorPhotoUrl;
    NSString *AlreadyRead;
}

@property (nonatomic, readonly) NSString *NoticeType;
@property (nonatomic, readonly) NSDate   *SubmitTime;
@property (nonatomic, readonly) NSString *SourceTopicID;
@property (nonatomic, readonly) NSString *SourcePhotoID;
@property (nonatomic, readonly) NSString *SourcePhotoUrl;
@property (nonatomic, readonly) NSString *SourceMovieID;
@property (nonatomic, readonly) NSString *SourceMovieUrl;
@property (nonatomic, readonly) NSString *Content;
@property (nonatomic, readonly) NSString *CommentID;
@property (nonatomic, readonly) NSString *Author;
@property (nonatomic, readonly) NSString *AuthorDisplayName;
@property (nonatomic, readonly) NSString *AuthorPhotoID;
@property (nonatomic, readonly) NSString *AuthorPhotoUrl;
@property (nonatomic, readonly) NSString *AlreadyRead;
@end
