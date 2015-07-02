//
//  LBUploadTaskManager.h
//  lebo
//
//  Created by 乐播 on 13-3-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBUploadTask.h"
#import "LBProgressBar.h"

extern NSString * const LBUploadTaskManagerDidChangeInfo;
extern NSString * const LBUploadTaskChangedInfo; //used for userinfo key


extern NSString * const LBUploadViewDidChange; //主页需要要更新状态时的参数
extern NSString * const LBUploadTaskNumberKey; //used for userinfo key

extern NSString * const LBUploadTaskDidFinished; //上传成功发送该通知

typedef NS_ENUM(NSInteger, LBUploadViewStyle) {
    LBUploadViewStyleUploadCell,
    LBUploadViewStyleMainView
};

@interface LBUploadView : UIImageView<UIGestureRecognizerDelegate>
{
    //BOOL _shouldReceiveTouch;
    UILabel * _lable;
    UIImageView * _mark;
    UIImage * _shadowBg;
    UITapGestureRecognizer * _gesture;
    
}

@property(nonatomic,readonly) UIImageView * imageView;
@property(nonatomic,readonly) LBProgressBar * progressView;
@property(nonatomic,assign) LBUploadViewStyle style; //主页只需更改该选项即可
@property(nonatomic,readonly) int taskNumber;
@property(nonatomic,readonly) float defaultHeight;
- (void)update;

@end

@interface LBUploadTaskManager : NSObject
{
    __weak LBUploadTask * _cuTask;
    NSMutableArray * _uploadTask;
    NSMutableArray * _failedTask;
    NSMutableArray * _draftTask;
    UIView * _uploadingView;
}
@property(nonatomic,readonly) NSArray * tasks;
@property(nonatomic,copy,readonly) NSMutableArray * uploadTask;
@property(nonatomic,copy,readonly) NSMutableArray * failedTask;
@property(nonatomic,copy,readonly) NSMutableArray * draftTask;
@property(nonatomic,readonly) LBUploadTask * cuTask;
@property(nonatomic,readonly) LBUploadView * uploadingView;
@property(nonatomic,readonly) BOOL isUploading;

+ (LBUploadTaskManager *)sharedInstance;
- (id)init;   //初始化会执行 - (void)refreshAllTask
- (void)refreshAllTask;
- (LBUploadTask *)addTaskWithPath:(NSString *)path
                          content:(NSString *)content
                        sinaShare:(BOOL)sinaShare
                      renrenShare:(BOOL)renrenShare;//加到草稿箱中
- (void)startTask:(LBUploadTask *)task;
- (void)removeTasks:(LBUploadTask *)task;
- (int)taskNumber;

//正式工程没用，用于上传其他视频
+ (void)uploadMovieWithPath:(NSString *)path;

@end
