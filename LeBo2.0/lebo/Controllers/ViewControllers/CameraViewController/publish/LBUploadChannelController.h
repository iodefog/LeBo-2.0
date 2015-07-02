//
//  LBUploadChannelController.h
//  lebo
//
//  Created by 乐播 on 13-3-26.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBBaseController.h"
@protocol LBUploadChannelControllerDelegate<NSObject>

- (void)didFinishEdit:(NSString *)text;;

@end

@interface LBUploadChannelController : LBTableApiViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,weak) id<LBUploadChannelControllerDelegate> delegate;
@end
