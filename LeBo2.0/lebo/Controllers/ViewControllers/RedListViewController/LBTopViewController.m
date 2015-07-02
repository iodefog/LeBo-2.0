//
//  LBTopViewController.m
//  lebo
//
//  Created by King on 13-4-18.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBTopViewController.h"
#import "LBTopCell.h"

@interface LBTopViewController ()

@end

@implementation LBTopViewController
@synthesize controllerTag = _controllerTag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setHidesBottomBarWhenPushed:YES];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithTitle:@"返回" image:@"general_back.png" target:self action:@selector(back)];

    self.enableHeader = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (API_GET_TYPE)modelApi
{
    if (self.controllerTag == 1) {
        self.title = @"粉丝最多";
        return API_GET_TOPFANS_LIST;
    } else if (self.controllerTag == 2) {
        self.title = @"最受喜欢";
        return API_GET_TOPLOVE_LIST;
    } else {
        self.title = @"票房最高";
        return API_GET_TOPPLAY_LIST;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBTopCell *topCell = (LBTopCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if([topCell respondsToSelector:@selector(setObject: topViewIndex: row:)])
    {
        if([self.model count] > indexPath.row)                           
        {
            id item = [self.model objectAtIndex:indexPath.row];
            [topCell setObject:item topViewIndex:_controllerTag row:indexPath.row];

        }
    }
    
    return topCell;
}

- (Class)cellClass {
    return [LBTopCell class];
}

- (void)back
{
    [Global clearPlayStatus];
    self.navigationController.title = @"";
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
