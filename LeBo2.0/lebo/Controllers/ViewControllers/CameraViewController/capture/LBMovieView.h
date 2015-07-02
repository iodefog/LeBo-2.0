//
//  LBMovieView.h
//  LeBo
//
//  Created by 乐播 on 13-3-11.
//
//

#import <UIKit/UIKit.h>
#import "LBMovieDownloader.h"
#import "LBActivityIndicatorView.h"
#import "MBProgressHUD.h"
@interface LBMovieView : UIView<LBMovieDownloaderDelegate,LBMovieProgressDelegate>
{
    BOOL _shouldPlay;
    UIView * _contentView;
}
@property(nonatomic,copy) NSString * imageId;

@property(nonatomic,copy) NSString * movieId;

@property(nonatomic,strong) UIImage *mImage; // 李红利添加，获取当前图片，用来分享到新浪微博的，勿删
@property(nonatomic,readonly) UIView * contentView;

@property(nonatomic,assign) BOOL supportTouch;//支持触摸暂停 默认为支持
- (void)setPlayerURL:(NSURL *)url;//不用调用该函数

- (void)play;

- (void)pause; //view 保留当前播放祯

- (void)stop; //view变为透明

+ (void)pauseAll;//view变为透明

- (BOOL)isPlaying;

- (void)setMovieId:(NSString *)movieId;
@end
