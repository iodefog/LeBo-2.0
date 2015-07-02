//
//  LBMoviePreviewController.m
//  lebo
//
//  Created by 乐播 on 13-4-17.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBMoviePreviewController.h"
@interface LBMoviePreviewController ()

@end

@implementation LBMoviePreviewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cameraBg];
    UIView * topBar = [self getTopBar];
    [self.view addSubview:topBar];
    
    CALayer * topLine = [CALayer layer];
    topLine.frame = CGRectMake(0, 58, self.view.width, 1);
    topLine.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:topLine];
    
    LBMovieView * tempMovieView = [[LBMovieView alloc] initWithFrame:CGRectMake(0, 59, self.view.width, self.view.width)];
    tempMovieView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tempMovieView];
    _movieView = tempMovieView;

    CALayer * bottomLine = [CALayer layer];
    bottomLine.frame = CGRectMake(0, _movieView.bottom, self.view.width, 1);
    bottomLine.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:bottomLine];

    
    if(_url)
    {
        [_movieView setPlayerURL:_url];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [_movieView pause];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_movieView play];
}

- (UIView *)getTopBar
{
    UIView * topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    topBar.userInteractionEnabled = YES;
    topBar.backgroundColor = [UIColor clearColor];
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:Image(@"camera_btn_back.png") forState:UIControlStateNormal];
    [leftButton sizeToFit];
    [leftButton.titleLabel setFont:[UIFont getButtonFont]];
    leftButton.center =  CGPointMake(30, topBar.height/2);
    [topBar addSubview:leftButton];

    return topBar;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setURL:(NSURL *)url
{
    _url = [url copy];
    [_movieView setPlayerURL:_url];
}
@end
