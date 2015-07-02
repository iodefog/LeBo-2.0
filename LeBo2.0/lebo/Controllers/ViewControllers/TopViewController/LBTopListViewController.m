//
//  LBTopListViewController.m
//  lebo
//
//  Created by yong wang on 13-3-26.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBTopListViewController.h"
#import "LBTempClipsCell.h"
#import "LBMovieView.h"
@implementation LBTopListViewController

static LBTopListViewController *_sharedInstance = nil;

+ (LBTopListViewController *)sharedInstance
{
    @synchronized(self)
    {
        if (_sharedInstance == nil)
        {
            _sharedInstance = [[LBTopListViewController alloc] init];
        }
    }
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.enableHeader = YES;
    //[self setRefresh:YES];
    //[self reloadData];
	// Do any additional setup after loading the view.
}

- (void)setRefresh:(BOOL)bRefresh
{
    self.enableFooter = bRefresh;
}

- (Class)cellClass {
    return [LBTempClipsCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_GET_HOT_VIDEO_LIST;
}

@end
