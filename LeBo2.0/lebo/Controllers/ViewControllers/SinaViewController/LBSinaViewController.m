//
//  EditSignViewController.m
//  LBDemo
//
//  Created by Li Hongli on 13-3-25.
//  Copyright (c) 2013年 Li Hongli. All rights reserved.
//

#import "LBSinaViewController.h"
#import "AccountHelper.h"
#import "AccountDTO.h"
#import "LBFileClient.h"
#import "RenRenHelper.h"

@interface LBSinaViewController ()<RenRenHelperDelegate>

@end

@implementation LBSinaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - viewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.center = CGPointMake(self.navigationController.navigationBar.center.x, 42.0f);
	self.view.backgroundColor =  [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 11, self.view.frame.size.width- 10, 150) ];
    UIImage *image = [UIImage imageNamed:@"input_backGroud.png"];
    [self.view addSubview:bgImageView];
    bgImageView.image = [image stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    
    _signTextView = [[UITextView alloc]initWithFrame:CGRectMake( bgImageView.frame.origin.x , bgImageView.frame.origin.y +5 , bgImageView.frame.size.width, 140.0f)];
    _signTextView.backgroundColor = [UIColor clearColor];
    _signTextView.delegate = self;
    _signTextView.font = [UIFont systemFontOfSize:14.0f];
    _signTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_signTextView becomeFirstResponder];
   
    [self.view addSubview:bgImageView];
    [self.view addSubview:_signTextView];
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishBtn.frame = CGRectMake(0, 0, 50, 28);
    [finishBtn addTarget:self action:@selector(finishClicked:) forControlEvents:UIControlEventTouchUpInside];    
    UIImage *btnImage = [UIImage imageNamed:@"sina_pulish"];
    [finishBtn setBackgroundImage:[btnImage stretchableImageWithLeftCapWidth:14 topCapHeight:14] forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
     NSDictionary *shareDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"shareData"];
    if (_isShareToSina) {
        
        [[SinaHelper getHelper] setDelegate:self];
        [[SinaHelper getHelper] longUrlTOShortUrl:self.movieUrl];
       
        self.title = @"分享到新浪微博";
        if (_movieTitle.length<1) {
          
            _signTextView.text = [NSString stringWithFormat:@"@%@ %@",_authorName, [shareDict objectForKey:@"shareText"]];
        }else{
            _signTextView.text = [NSString stringWithFormat:@"@%@ :%@",_authorName,  [shareDict objectForKey:@"shareText"]];
        }
    }else if (self.isShareToRenRen){
        self.title = @"分享到人人网";
        if (_movieTitle.length<1) {
            _signTextView.text = [NSString stringWithFormat:@"%@",[shareDict objectForKey:@"shareText"]];
        }else{
            _signTextView.text = [NSString stringWithFormat:@"%@", _movieTitle];
        }
    }
   
    [finishBtn setTitle:@"分享" forState:UIControlStateNormal];
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithTitle:@"取消" image:@"general_back.png" target:self action:@selector(cancel)];

    
    _wordRemainingCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(bgImageView.frame.origin.x + bgImageView.frame.size.width - 76, bgImageView.frame.origin.y + bgImageView.frame.size.height - 34, 70, 40)];
    _wordRemainingCountLabel.backgroundColor = [UIColor clearColor];
    _wordRemainingCountLabel.font = [UIFont systemFontOfSize:14.0f];
    _wordRemainingCountLabel.textColor = RGB(131, 131, 131);
    _wordRemainingCountLabel.textAlignment = UITextAlignmentRight;
    [self.view addSubview:_wordRemainingCountLabel];
    
    int remainCount =  140 - 20 - _signTextView.text.length;
    _wordRemainingCountLabel.text = [NSString stringWithFormat:@"%d",remainCount];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    _signTextView = nil;
    _wordRemainingCountLabel = nil;
}

- (void)cancel{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareToSina{
    [[SinaHelper getHelper] setDelegate:self];
    NSData *picData = UIImageJPEGRepresentation(_thumbImage, 1.0f);
    [[SinaHelper getHelper] setDelegate:self];
    
    [[SinaHelper getHelper] uploadPicture:picData status:[NSString stringWithFormat:@"%@ 视频地址>>>%@",_signTextView.text,_shortUrl]];
    
    [[LBFileClient sharedInstance] shareFileName:self.movieID cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(responseSuccess:) selectorError:@selector(responseFail:)];
}

- (void)finishClicked:(UIButton *)sender{
    
    if (_signTextView.text.length > 140 - _shortUrl.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"文字不能超过%d个",120] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
        [alert show];
        return;
    }
       
    if (self.isShareToSina) {
        [self addProgress];
        if (isUnFinishedShortUrl) {
            [self shareToSina];
        }else{
            isUnFinishedShortUrl = YES;
        }
    }else if (self.isShareToRenRen){
        BOOL isSessionValid = [RenRenHelper isSessionValidTarget:self isLogin:YES];
        if (isSessionValid) {
            [self addProgress];
            [RenRenHelper shareMovieToRenRenMovieID:self.movieID content:_signTextView.text alert:NO target:self];
        }
    }
}

- (void)addProgress{
    progress = [[MBProgressHUD alloc] initWithView:_signTextView];
    [_signTextView addSubview:progress];
    progress.delegate = self;
    progress.labelText = @"加载中...";
    [progress show:YES];

}

#pragma mark - LBFileClientDelegate
- (void)responseSuccess:(id)result{
    NSLog(@"LBSinaViewController fileClient success %@",result);
}

- (void)responseFail:(NSError *)error{
    NSLog(@"LBSinaViewController fileClient fail %@",error);
}

#pragma mark - textViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    if (_signTextView.text.length > 140 - 20)
        _wordRemainingCountLabel.textColor = [UIColor redColor];
    else
        _wordRemainingCountLabel.textColor = RGB(131, 131, 131);
    int remainCount = 140 - 20 - _signTextView.text.length;
    _wordRemainingCountLabel.text = [NSString stringWithFormat:@"%d",remainCount];
    
}

#pragma mark - sianDelegate

- (void)shortUrlSuccess:(id)result{
    NSString *url_short = [[[result objectForKey:@"urls"] lastObject] objectForKey:@"url_short"];
    _shortUrl = url_short;

    NSLog(@"result  %@",result);
    if (isUnFinishedShortUrl) {
        [self shareToSina];
    }else{
        isUnFinishedShortUrl = YES;
    }
}


- (void)longUrlTOShortUrlSuccess:(id)result{
    NSLog(@"result  %@",result);
    NSString *url_short = [[[result objectForKey:@"urls"] lastObject] objectForKey:@"url_short"];
    _shortUrl = url_short;
}


- (void)shortUrlFail:(NSError *)error{
    NSLog(@"%@",error);
}

- (void)sinaUploadSuccess:(id)result{
    NSLog(@"%@",result);
    
    progress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    progress.mode = MBProgressHUDModeCustomView;
	progress.labelText = @"成功";
    [_signTextView addSubview:progress];
    [self performSelector:@selector(removeProgressSuccess) withObject:nil afterDelay:1.0f];
}

- (void)removeProgressSuccess{
    [progress show:NO];
    [progress removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removeProgressFail{
    [progress show:NO];
    [progress removeFromSuperview];
}

- (void)sinaUploadFail:(NSError *)error{
    NSLog(@"%@",error);
     [self performSelector:@selector(removeProgressFail) withObject:nil afterDelay:1.0f];
    progress.labelText = @"失败";
}

#pragma mark -
#pragma mark RenRenDelegate
/* 发布成功
 @param renren 传回代理服务器接口请求的 Renren 类型对象。@param response 传回接口请求的响应
 */
- (void)renrenHelper:(Renren *)renren requestDidReturnResponse:(ROResponse *)response{
    NSLog(@"response.rootObject %@",response.rootObject);
    progress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    progress.mode = MBProgressHUDModeCustomView;
	progress.labelText = @"成功";
    [_signTextView addSubview:progress];
    [self performSelector:@selector(removeProgressSuccess) withObject:nil afterDelay:1.0f];
}

/* 发布失败
 @param renren 传回代理服务器接口请求的 Renren 类型对象。@param response 传回接口请求的错误对象。
 */
- (void)renrenHelper:(Renren *)renren requestFailWithError:(ROError *)error{
    NSLog(@"error  %@",error);
     progress.labelText = @"失败";
    [self performSelector:@selector(removeProgressFail) withObject:nil afterDelay:1.0f];
}

// 登陆成功回调
- (void)renRenLoginSuccess:(id)result{
    [self addProgress];
    [RenRenHelper shareMovieToRenRenMovieID:self.movieID content:_signTextView.text alert:NO target:self];
}

// 登陆失败回调
- (void)renRenLoginFail:(NSError *)error{
     [[TKAlertCenter defaultCenter] postAlertWithMessage:@"登陆失败"];
}

@end
