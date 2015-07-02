//
//  LBUploadTask.m
//  lebo
//
//  Created by 乐播 on 13-3-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBUploadTask.h"
#import "LBCameraTool.h"


@implementation LBUploadTask

@dynamic path;
@dynamic content;
@dynamic date;
@dynamic uploadStatus;
@dynamic uploadIndex;
@dynamic userId;
@dynamic shareInfo;
@dynamic sina;
@dynamic renren;
- (void)remove
{
    [self clearFile];
    [[CoreDataAccess sharedInstance] deleteRecord:self];
    
}

- (void)clearFile
{
    [[NSFileManager defaultManager] removeItemAtPath:self.path error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[LBCameraTool getThumbPathWithPath:self.path]
                                               error:nil];
}




@end
