//
//  LBUploadTask.h
//  lebo
//
//  Created by 乐播 on 13-3-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
typedef NS_ENUM(NSInteger, UploadTaskStatus) {
    UploadTaskStatusDraft,
    UploadTaskStatusFailed,
    UploadTaskStatusUploading,
    UploadTaskStatusPrepare,
    UploadTaskStatusDelete
};

@interface LBUploadTask : NSManagedObject

@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * uploadStatus;
@property (nonatomic, retain) NSNumber * uploadIndex;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSData * shareInfo;

@property (nonatomic, retain) NSNumber * sina;
@property (nonatomic, retain) NSNumber * renren;

- (void)remove;

@end
