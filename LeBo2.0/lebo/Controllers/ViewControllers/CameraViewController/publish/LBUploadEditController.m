//
//  LBUploadEditController.m
//  lebo
//
//  Created by 乐播 on 13-3-26.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBUploadEditController.h"
#import "LBCameraTool.h"
#import "LBUploadChannelController.h"
#import "LBUploadTaskManager.h"
#import "LBUploadManagerController.h"
#import "LBPublicSwitch.h"
#import "LBMoviePreviewController.h"
#import "LBUploadTaskManager.h"
#import "LBShareBtn.h"

NSString * const isNewUserKey = @"isNewUserKey";

@interface LBUploadEditController ()
{
    __weak UIScrollView * _mainView;
    
    __weak UIView * _topView;
    __weak UIView * _middleView;
    __weak UIView * _bottomView;
    
    __weak UILabel * _countLabel;

    LBShareBtn * _sinaBtn;
    LBShareBtn * _renrenBtn;
    
    LBTextView * _textView;
    NSString * _path;
    LBUploadTask * _task;
}
@end

@implementation LBUploadEditController

+ (void)load
{
    if(![[NSUserDefaults standardUserDefaults] objectForKey:isNewUserKey])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isNewUserKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSNotificationCenter defaultCenter] addObserver:[self class] selector:@selector(didChangeAccount:) name:LoginDidChangeNotification object:nil];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"发布";
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeAccount:) name:LoginDidChangeNotification object:nil];
        
        LBTextView * tempTextView = [[LBTextView alloc] initWithFrame:CGRectZero];
        tempTextView.placeholder = @"添加描述...";
        tempTextView.font = [UIFont getButtonFont];
        tempTextView.delegate = self;
        tempTextView.returnKeyType = UIReturnKeyDone;
        tempTextView.inputAccessoryView = [self createInputAccessoryView];
        tempTextView.backgroundColor = [UIColor clearColor];
        _textView = tempTextView;
        
        [self createShareButtons];
        
        
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithTitle:@"返回" image:@"general_back.png" target:self action:@selector(didClickBack)];
        
//        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [leftButton setTitle:@"返回" forState:UIControlStateNormal];
//        [leftButton addTarget:self action:@selector(didClickBack) forControlEvents:UIControlEventTouchUpInside];
//        [leftButton setBackgroundImage:Image(@"camera_btn_back.png") forState:UIControlStateNormal];
//        [leftButton sizeToFit];
//        [leftButton.titleLabel setFont:[UIFont getButtonFont]];
//        UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//        [self.navigationItem setLeftBarButtonItem:leftItem];
    }
    return self;
}

- (id)initWithMoviePath:(NSString *)path
{
    self = [super init];
    if(self)
    {
        _path = [path copy];
        _style = 0;
    }
    return self;
}

- (id)initWithTask:(LBUploadTask *)task;
{
    self = [super init];
    if(self)
    {
        _task = task;
        _style = 1;
    }
    return self;
}

- (void)dealloc
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createShareButtons
{
    //新浪 
    _sinaBtn = [[LBShareBtn alloc] init];
    _sinaBtn.titleLable.text = @"新浪分享";
    [_sinaBtn setBackgroundImg:Image(@"publish_btn_left.png")];
    _sinaBtn.highlightedBackgroundImg = Image(@"publish_btn_left_highlight.png");
    _sinaBtn.icon = Image(@"publish_icon_sinagray.png");
    _sinaBtn.selectedIcon = Image(@"publish_icon_sinablue.png");
    [_sinaBtn addTarget:self forSelector:@selector(clickSina:)];
    
    
    //人人
    _renrenBtn = [[LBShareBtn alloc] init];
    _renrenBtn.titleLable.text = @"人人分享";
    [_renrenBtn setBackgroundImg:Image(@"publish_btn_right.png")];
    _renrenBtn.highlightedBackgroundImg = Image(@"publish_btn_right_highlight.png");
    _renrenBtn.icon = Image(@"publish_icon_renrengray.png");
    _renrenBtn.selectedIcon = Image(@"publish_icon_renrenblue.png");
    [_renrenBtn addTarget:self forSelector:@selector(clickRenRen:)];
    
}

- (UIView *)createInputAccessoryView
{
    UIImage * img = Image(@"publish_bg_accessoryView.png");
    img = [img stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 44)];
    bgView.image = img;
    bgView.userInteractionEnabled = YES;
    
    UIButton * channelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [channelBtn setBackgroundImage:Image(@"publish_btn_addChannel.png") forState:UIControlStateNormal];
    [channelBtn setTitle:@"#添加到频道" forState:UIControlStateNormal];
    channelBtn.titleLabel.font = [UIFont getButtonFont];
    channelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 0);
    [channelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [channelBtn addTarget:self action:@selector(clickChannel) forControlEvents:UIControlEventTouchUpInside];
    [channelBtn sizeToFit];
    channelBtn.left = 10;
    channelBtn.centerY = bgView.height/2;
    [bgView addSubview:channelBtn];
    
    
    UILabel * countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.textColor = [UIColor blackColor];
    countLabel.font = [UIFont getButtonFont];
    countLabel.right = bgView.width - 10;
    [bgView addSubview:countLabel];
    _countLabel = countLabel;
    
    return bgView;
}


- (void)createTopView
{
    UIImageView * bgView = [[UIImageView alloc] initWithImage:Image(@"publish_bg_text.png")];
    if(_style == UploadEditControllerStylePublish)
    {
        bgView.top = 44+12;
    }
    else
    {
        bgView.top = 12;
    }
    bgView.centerX = _mainView.width/2;
    bgView.userInteractionEnabled = YES;
    [_mainView addSubview:bgView];
    _topView = bgView;
    
    UIImageView * thumbBg = [[UIImageView alloc] initWithImage:Image(@"publish_bg_thumb.png")];
    thumbBg.centerY = bgView.height/2;
    thumbBg.left = 8;
    thumbBg.userInteractionEnabled = YES;
    [bgView addSubview:thumbBg];
    
    UIImageView * thumb = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 70, 70)];
    thumb.userInteractionEnabled = YES;
    [thumbBg addSubview:thumb];
    thumb.backgroundColor = [UIColor grayColor];
    thumb.centerX = thumbBg.width/2;
    thumb.image = [LBCameraTool getThumbImageWithPath:[self getPath]];
    
    UIButton * playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:Image(@"publish_btn_play.png") forState:UIControlStateNormal];
    playBtn.frame = thumb.bounds;
    [thumb addSubview:playBtn];
    [playBtn addTarget:self action:@selector(didClickPreview) forControlEvents:UIControlEventTouchUpInside];    
    
    [bgView addSubview:_textView];
    _textView.frame = CGRectMake(thumbBg.right+8, thumbBg.top, bgView.width - thumb.right - 20, thumbBg.height);
}

- (void)createMiddelView
{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(_topView.left, _topView.bottom, _topView.width, 100)];
    [_mainView addSubview:bgView];
    _middleView = bgView;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, 200, 14)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = RGB(94, 94, 94);
    label.text = @"分享到";
    [_middleView addSubview:label];
    
    [_middleView addSubview:_sinaBtn];
    _sinaBtn.origin = CGPointMake(0, 39);
    
    [_middleView addSubview:_renrenBtn];
    _renrenBtn.origin = CGPointMake(_sinaBtn.right, 39);
    
    _middleView.height = _renrenBtn.bottom;
}

- (void)createBottomView
{
     UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(_topView.left, _middleView.bottom+39, _topView.width, 100)];
    [_mainView addSubview:bgView];
    _bottomView = bgView;
    
    UIImage * imageBlue = [UIImage imageNamed:@"publish_btn_blue.png"];
    UIButton * right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    right.titleLabel.font = [UIFont getButtonFont];
    [right setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    right.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [right setTitle:@"立即发布" forState:UIControlStateNormal];
    [right setBackgroundImage:imageBlue forState:UIControlStateNormal];
    [right sizeToFit];
    right.right = _bottomView.width;
    [right addTarget:self action:@selector(didClickPublish) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:right];
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_bottomView addSubview:leftBtn];
    leftBtn.titleLabel.font = [UIFont getButtonFont];
    [leftBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.shadowOffset = CGSizeMake(0, 1);
    leftBtn.left = 0;
    if(_style == UploadEditControllerStylePublish)
    {
        UIImage * imageGray = [UIImage imageNamed:@"publish_btn_gray.png"];
        [leftBtn setTitle:@"保存草稿" forState:UIControlStateNormal];
        [leftBtn setBackgroundImage:imageGray forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(didClickSave) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn sizeToFit];
    }
    else
    {
        UIImage * imageRed = [UIImage imageNamed:@"publish_btn_delete.png"];
        [leftBtn setTitle:@"删除" forState:UIControlStateNormal];
        [leftBtn setBackgroundImage:imageRed forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(didClickDelete) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn sizeToFit];
    }
}

- (void)loadView
{
    [super loadView];
    if(_style == UploadEditControllerStylePublish)
    {
        self.view.frame = CGRectMake(0, 0, screenSize().width, screenSize().height);
    }
    else
    {
        self.view.frame = CGRectMake(0, 0, screenSize().width, screenSize().height-44);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView * tempView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    tempView.userInteractionEnabled = YES;
    [self.view addSubview:tempView];
    tempView.alwaysBounceVertical = YES;
    tempView.backgroundColor = [UIColor homeBg];
    _mainView = tempView;

    
    
    
    [self createTopView];
    [self createMiddelView];
    [self createBottomView];
    
    
    if(_style == UploadEditControllerStylePublish && [self isNewOne])
    {
        _textView.text = @"#新人报道#";
        
    }
    else if(_style == UploadEditControllerStyleEdit)
    {
        _textView.text = _task.content;
        _sinaBtn.selected = [_task.sina boolValue];
        _renrenBtn.selected  = [_task.renren boolValue];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    UIImage *bgimage = [UIImage imageNamed:@"naviBar_background.png"];
    [self.navigationController.navigationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[_textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_textView resignFirstResponder];
}

- (void)refreshLabelWithString:(NSString *)text
{
    int number = [NSString countWeiboTextNum:text];
    int showNum = 140-number;
    _countLabel.text = [NSString stringWithFormat:@"%d",showNum];
    if(showNum<0)
        _countLabel.textColor = [UIColor redColor];
    else
        _countLabel.textColor = [UIColor blackColor];
}

- (BOOL)isNewOne
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber * number = [userDefault objectForKey:isNewUserKey];
    if(!number)
    {
        int videoNum = [AccountHelper getAccount].TopicCount;
        if(videoNum == 0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if([number boolValue] == NO)
    {
        return NO;
    }
    else//([number boolValue] == YES)
    {
        int videoNum = [AccountHelper getAccount].TopicCount;
        if(videoNum == 0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
        return YES;
    }
}

- (void)saveNewOne
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:NO forKey:isNewUserKey];
    [userDefault synchronize];
}

- (NSString *)getPath
{
    if(_path)
        return _path;
    else
        return _task.path;
}

- (BOOL)isValid
{
    int number = [NSString countWeiboTextNum:_textView.text];
    if(number > 140)
        return NO;
    else
        return YES;
}
       
#pragma mark NSNotification
+ (void)didChangeAccount:(NSNotification *)sender
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:YES forKey:isNewUserKey];
    [userDefault synchronize];
}

- (void)reSaveTask
{
    _task.content = _textView.text;
    _task.sina = @(_sinaBtn.selected);
    _task.renren = @(_renrenBtn.selected);
}

#pragma mark IBAction
- (void)didClickBack
{
    if(_style == UploadEditControllerStyleEdit)
    {
        [self reSaveTask];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickPreview
{
    LBMoviePreviewController * controller = [[LBMoviePreviewController alloc] init];
    [controller setURL:[NSURL fileURLWithPath:[self getPath]]];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickSave
{
    if(![self isValid])
    {
        [[UIAlertView alertViewWithTitle:@"评论不能超过140个字" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil onDismiss:nil onCancel:nil] show];
        return ;
    }
    [self saveNewOne];
    [[LBUploadTaskManager sharedInstance] addTaskWithPath:[self getPath] content:_textView.text sinaShare:_sinaBtn.selected renrenShare:_renrenBtn.selected];
    UITabBarController * tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabBarController setSelectedIndex:0];
    [self dismissModalViewControllerAnimated:YES];

    //[tabBarController.tabBar setse]
//    LBUploadManagerController * controller = [[LBUploadManagerController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickPublish
{
    if(![self isValid])
    {
        [[UIAlertView alertViewWithTitle:@"评论不能超过140个字" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil onDismiss:nil onCancel:nil] show];
        return ;
    }
    if(_style == UploadEditControllerStylePublish)
    {
        [self saveNewOne];
        LBUploadTask * realTask = [[LBUploadTaskManager sharedInstance] addTaskWithPath:[self getPath] content:_textView.text sinaShare:_sinaBtn.selected renrenShare:_renrenBtn.selected];
        [[LBUploadTaskManager sharedInstance] startTask:realTask];
        UITabBarController * tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [tabBarController setSelectedIndex:0];
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [self reSaveTask];
        [[LBUploadTaskManager sharedInstance] startTask:_task];
        [self.navigationController popViewControllerAnimated:YES];
    }
    

//    LBUploadManagerController * controller = [[LBUploadManagerController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickDelete
{
    [[LBUploadTaskManager sharedInstance] removeTasks:_task];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickChannel
{
    LBUploadChannelController * controller = [[LBUploadChannelController alloc] init];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickRenRen:(LBShareBtn *)sender
{
    BOOL newSelected = !sender.selected;
    if(newSelected == NO)
        sender.selected = newSelected;
    else
    {
        BOOL flag = [RenRenHelper isSessionValidTarget:self isLogin:YES];
        if(flag)
        {
            sender.selected = newSelected;
        }
        else
        {
            //[[RenRenHelper sharedInstance] login];
        }
      
    }
}

- (void)clickSina:(LBShareBtn *)sender
{
    BOOL newSelected = !sender.selected;
    if(newSelected == NO)
        sender.selected = newSelected;
    else
    {
        if([[SinaHelper getHelper] sinaIsAuthValid])
        {
            sender.selected = newSelected;
        }
        else
        {
            [[SinaHelper getHelper] setDelegate:self];
            [[SinaHelper getHelper] login];
        }
    }
}

#pragma mark LBUploadChannelControllerDelegate

- (void)didFinishEdit:(NSString *)text
{
    NSString * newText = [_textView.text stringByAppendingString:text];
    _textView.text = newText;
    [self refreshLabelWithString:newText];
}

#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    else
    {
        NSString * tempStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        [self refreshLabelWithString:tempStr];
    }
    return YES;
}

#pragma mark RenrenDelegate
-(void)renRenLoginSuccess:(id)result
{
    _renrenBtn.selected = YES;
}

-(void)renRenloginFail:(NSError *)error
{
    _renrenBtn.selected = NO;
}

#pragma mark sinaDelegate
- (void)sinaDidLogin:(NSDictionary *)userInfo
{
    _sinaBtn.selected = YES;
}

// 新浪微博登陆失败
- (void)sinaDidFailLogin:(NSError *)error
{
    _sinaBtn.selected = NO;
}
@end
