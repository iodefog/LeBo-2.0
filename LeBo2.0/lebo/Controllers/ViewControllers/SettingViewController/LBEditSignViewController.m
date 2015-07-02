//
//  EditSignViewController.m
//  LBDemo
//
//  Created by Li Hongli on 13-3-25.
//  Copyright (c) 2013年 Li Hongli. All rights reserved.
//

#import "LBEditSignViewController.h"
#import "AccountHelper.h"
#import "AccountDTO.h"
#import "LBFileClient.h"

@interface LBEditSignViewController ()

@end

@implementation LBEditSignViewController

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
    
    _signTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, 11, self.view.frame.size.width- 10, 150)];
    _signTextView.backgroundColor = [UIColor clearColor];
    _signTextView.delegate = self;
    _signTextView.font = [UIFont systemFontOfSize:14.0f];
    _signTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _signTextView.text = _signText;
    [_signTextView becomeFirstResponder];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:_signTextView.frame ];
    //UIImage *image = [UIImage imageWithCGImage:[UIImage imageNamed:@"input_backGroud.png"].CGImage scale:2.0 orientation:UIImageOrientationUp];
    UIImage *image = [UIImage imageNamed:@"input_backGroud.png"];
    bgImageView.image = [image stretchableImageWithLeftCapWidth:15 topCapHeight:15];
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
    
    
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithTitle:@"返回" image:@"general_back.png" target:self action:@selector(back)];

    
    _wordRemainingCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 83, _signTextView.frame.origin.y + _signTextView.frame.size.height - 34, 70, 40)];
    _wordRemainingCountLabel.backgroundColor = [UIColor clearColor];
    _wordRemainingCountLabel.textAlignment = UITextAlignmentRight;
    _wordRemainingCountLabel.font = [UIFont systemFontOfSize:14.0f];
    _wordRemainingCountLabel.textColor = RGB(131, 131, 131);
    [self.view addSubview:_wordRemainingCountLabel];
    
        NSDictionary *shareDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"shareData"];
    if(_isInviteSinaFriend) {
        self.title = @"邀请新浪好友";
        _signTextView.text = [NSString stringWithFormat:@"@%@ %@ ",self.sinaFriendName, [shareDict objectForKey:@"inviteText"] ];
        [finishBtn setTitle:@"邀请" forState:UIControlStateNormal];
        int remainCount = 140 - @"http://t.cn/zT2P8ce".length - _signTextView.text.length;
        _wordRemainingCountLabel.text = [NSString stringWithFormat:@"%d",remainCount];

        //        [[SinaHelper getHelper] setDelegate:self];
        //        [[SinaHelper getHelper] longUrlTOShortUrl:@"https://itunes.apple.com/cn/app/le-bo/id598266288?mt=8"];
    }else if (_isComment){
        self.title = [NSString stringWithFormat:@"回复%@", self.noticeDTO.AuthorDisplayName];
        [finishBtn setTitle:@"回复" forState:UIControlStateNormal];
        int remainCount = 140 - _signTextView.text.length;
        _wordRemainingCountLabel.text = [NSString stringWithFormat:@"%d",remainCount];
    }
    else{
        self.title = @"个性签名";
        
        int remainCount = 70 - _signTextView.text.length;
        _wordRemainingCountLabel.text = [NSString stringWithFormat:@"%d",remainCount];
    }
    
}

- (void)viewDidUnload{
    [super viewDidUnload];
    _signTextView = nil;
    _wordRemainingCountLabel = nil;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishClicked:(UIButton *)sender{
    if (self.isInviteSinaFriend) {
        if (_signTextView.text.length > 140 - @"http://t.cn/zT2P8ce".length) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: @"文字不能超过%d个",140 - @"http://t.cn/zT2P8ce".length ]message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
            [alert show];
            return;
        }else{
            progress = [[MBProgressHUD alloc] initWithView:_signTextView];
            [_signTextView addSubview:progress];
            progress.labelText = @"加载中...";
            progress.delegate = self;
            [progress show:YES];
            
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"shareData"];
        
            [[SinaHelper getHelper] setDelegate:self];
            [[SinaHelper getHelper] uploadPicture:[dict objectForKey:@"imageData"] status:[NSString stringWithFormat:@"%@ 快来看看吧>>>%@",_signTextView.text, @"http://t.cn/zT9BMq0"]];
        }
    }else if (self.isComment){
        if (_signTextView.text.length <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享内容不能为空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
            [alert show];
            return;
        }else if (_signTextView.text.length >140){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"文字不能超过140个"message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
            [alert show];
            return;
        }else{
            progress = [[MBProgressHUD alloc] initWithView:_signTextView];
            [_signTextView addSubview:progress];
            progress.labelText = @"加载中...";
            progress.delegate = self;
            [progress show:YES];
            
            LBFileClient *client = [LBFileClient sharedInstance];
            [client addCommentOfComment:[NSArray arrayWithObjects: self.noticeDTO.SourceTopicID, self.noticeDTO.CommentID, _signTextView.text, nil] cachePolicy:NSURLRequestReloadIgnoringCacheData  delegate:self selector:@selector(addCommentOfCommentRequestDidFinishLoad:) selectorError:@selector(addCommentOfCommentRequestError:)];
        }
    }
    
    else{
        if (_signTextView.text.length > 70) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"文字不能超过70个"message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
            [alert show];
             return;
        }else{
            progress = [[MBProgressHUD alloc] initWithView:_signTextView];
            [_signTextView addSubview:progress];
            progress.labelText = @"加载中...";
            progress.delegate = self;
            [progress show:YES];
            
            LBFileClient *client = [LBFileClient sharedInstance];
            [client setSign:_signTextView.text cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
        }
    }
    
}
- (void)requestDidFinishLoad:(NSData *)data {
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (_parent != nil && [_parent respondsToSelector:_action]) {
        [_parent performSelector:_action withObject:_signTextView.text];
    }
    NSLog(@"%@", [json_string JSONValue]);
    [progress show:NO];
    [progress removeFromSuperview];
    
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

- (void)requestError:(NSData *)data {
    progress.labelText = @"失败";
    [_signTextView addSubview:progress];
    [self performSelector:@selector(removeProgressFail) withObject:nil afterDelay:1.0f];
}

#pragma mark - textViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    if (_isInviteSinaFriend) {
        if (_signTextView.text.length > 140 - @"http://t.cn/zT2P8ce".length)
            _wordRemainingCountLabel.textColor = [UIColor redColor];
        else
            _wordRemainingCountLabel.textColor = RGB(131, 131, 131);
        int remainCount = 140 - @"http://t.cn/zT2P8ce".length - _signTextView.text.length;
        _wordRemainingCountLabel.text = [NSString stringWithFormat:@"%d",remainCount];
    }else{
        if (_signTextView.text.length > 70)
            _wordRemainingCountLabel.textColor = [UIColor redColor];
        else
            _wordRemainingCountLabel.textColor = RGB(131, 131, 131);
        int remainCount = 70 - _signTextView.text.length;
        _wordRemainingCountLabel.text = [NSString stringWithFormat:@"%d",remainCount];
    }
}

#pragma mark - sianDelegate

- (void)shortUrlSuccess:(id)result{
    
  
}

// 这个是真的有用数据
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

- (void)sinaUploadFail:(NSError *)error{
    NSLog(@"%@",error);
    progress.labelText = @"失败";
    [_signTextView addSubview:progress];
    [self performSelector:@selector(removeProgressFail) withObject:nil afterDelay:1.0f];
}

- (void)addCommentOfCommentRequestDidFinishLoad:(NSData*)data {
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", [json_string JSONValue]);

    if(json_string.length > 0)
    {
        id responseObject = [[json_string JSONValue] objectForKey:@"error"];
        if(responseObject)
        {
            if([responseObject isKindOfClass:[NSString class]] && [responseObject isEqualToString:@"OK"])
            {
                NSLog(@"success");
                [progress show:NO];
                [progress removeFromSuperview];
                
                progress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                progress.mode = MBProgressHUDModeCustomView;
                progress.labelText = @"成功";
                [_signTextView addSubview:progress];
                sleep(2);
                [self.navigationController popViewControllerAnimated:YES];
            }
            if([responseObject isKindOfClass:[NSString class]] && [responseObject isEqualToString:@"FAIL"])
            {
                NSLog(@"fail");
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"回复失败"];
            }
        }
    }
    else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"回复失败"];
    }
}

- (void)addCommentOfCommentRequestError:(NSData*)data{
    NSLog(@"ERROR");
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"回复失败"];
}

@end
