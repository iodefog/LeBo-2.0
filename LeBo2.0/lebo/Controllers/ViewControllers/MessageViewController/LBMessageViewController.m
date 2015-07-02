//
//  LBMessageViewController.m
//  lebo
//
//  Created by yong wang on 13-3-24.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBMessageViewController.h"
#import "LBMessageCell.h"
@interface LBMessageViewController ()

@end

@implementation LBMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.enableHeader = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (API_GET_TYPE)modelApi
{
    return API_GET_MESSAGE_LIST;
}

- (Class)cellClass {
    //NSAssert(NO, @"subclasses to override");
    return [LBMessageCell class];
}

@end
