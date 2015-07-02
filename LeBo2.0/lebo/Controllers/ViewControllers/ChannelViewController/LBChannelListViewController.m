//
//  LBChannelListViewController.m
//  lebo
//
//  Created by yong wang on 13-3-30.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBChannelListViewController.h"
#import "LBTempClipsCell.h"

@interface LBChannelListViewController ()

@end

@implementation LBChannelListViewController
@synthesize channelTitle = _channelTitle;

static LBChannelListViewController *_sharedInstance = nil;

+ (LBChannelListViewController *)sharedInstance
{
    return _sharedInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _sharedInstance = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _sharedInstance = nil;
}

- (id)initVithChannelTitle:(NSString*)lChannelTitle
{
    if(self = [super init])
    {
        NSString *channel = lChannelTitle;
        self.navigationItem.title = lChannelTitle;
        if([lChannelTitle length] > 2)
            channel = [lChannelTitle substringWithRange:NSMakeRange(1, lChannelTitle.length - 2)];
        self.channelTitle = channel;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (NSString *)channelTitles
{
    return _channelTitle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _sharedInstance = self;
    
    self.enableHeader = YES;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithTitle:@"返回" image:@"general_back.png" target:self action:@selector(back)];
	// Do any additional setup after loading the view.
}

- (void)back
{
    [Global clearPlayStatus];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (API_GET_TYPE)modelApi
{
    return API_GET_CHANNEL_TOPIC_LIST;
}

- (Class)cellClass {
    return [LBTempClipsCell class];
}

@end
