//
//  LBVideoViewController.m
//  lebo
//
//  Created by yong wang on 13-3-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBVideoViewController.h"
#import "LBTempClipsCell.h"

@interface LBVideoViewController ()

@end

@implementation LBVideoViewController

@synthesize topicLeboID = _topicLeboID;

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

- (id)initWithTopicID:(NSString*)topicId isTitle:(BOOL)title
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.topicLeboID = topicId;
        self.isTitle = title;
        if (_isTitle) {
            self.navigationController.title = @"查看视频";
        }
    }
    return self;
}

- (NSString*)getTopicLeboID
{
    return _topicLeboID;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.tableView setScrollEnabled:NO];
    
    self.enableHeader = YES;
    self.enableFooter = NO;
    self.title = @"视频详情";
	// Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithTitle:@"返回" image:@"general_back.png" target:self action:@selector(back)];
}

- (void)back{
    [Global clearPlayStatus];
    [self.navigationController popViewControllerAnimated:YES];
}

- (Class)cellClass
{
    return [LBTempClipsCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_GET_TOPIC_LIST;
}

- (void)didFinishLoad:(id)object
{
    [super didFinishLoad:object];
    self.enableFooter = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
