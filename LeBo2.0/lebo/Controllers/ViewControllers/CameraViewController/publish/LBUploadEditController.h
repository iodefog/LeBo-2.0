//
//  LBUploadEditController.h
//  lebo
//
//  Created by 乐播 on 13-3-26.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBBaseController.h"
#import "LBTextView.h"
#import "LBUploadChannelController.h"
#import "LBUploadTask.h"
#import "RenRenHelper.h"
#import "SinaHelper.h"
typedef NS_ENUM(NSInteger, UploadEditControllerStyle) {
    UploadEditControllerStylePublish,
    UploadEditControllerStyleEdit
};

extern NSString * const isNewUserKey;

@interface LBUploadEditController : LBBaseController<UITextViewDelegate,LBUploadChannelControllerDelegate,SinaHelperDelegate>
{
    UploadEditControllerStyle _style;
}

- (id)initWithMoviePath:(NSString *)path;

- (id)initWithTask:(LBUploadTask *)task;
@end
