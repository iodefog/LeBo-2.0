
//
//  LBHomeViewController.m
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBHomeViewController.h"
#import "LBTempClipsCell.h"
#import "YIFullScreenScroll.h"
#import "LBUploadTaskManager.h"

@interface LBHomeViewController ()
{
    YIFullScreenScroll* _fullScreenDelegate;
}
@end

@implementation LBHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.enableHeader = YES;
    [self.view setAutoresizesSubviews:YES];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewContentModeBottom];
    _fullScreenDelegate = [[YIFullScreenScroll alloc] initWithViewController:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUploadCount:) name:LBUploadViewDidChange object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [_fullScreenDelegate _layoutWithScrollView:self.tableView deltaY:-50 disApper:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[LBUploadTaskManager sharedInstance].uploadingView setStyle:1];
    [self.navigationController setNavigationBarHidden:navigationBarTop < 44 ?NO:YES animated:animated];
}

- (void)getUploadCount:(NSNotification*)notification
{
    id taskCount = [notification.userInfo objectForKey:LBUploadTaskNumberKey];
    if(taskCount)
    {
        [[NSUserDefaults standardUserDefaults] setObject:taskCount forKey:@"uploadTask"];
        
        //if(self.tableView.sectionFooterHeight == 0)
        {
            [self.tableView reloadData];
        }
    }
}

- (Class)cellClass {
    return [LBTempClipsCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_GET_HOME_LIST;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int uploadCount =  [LBUploadTaskManager sharedInstance].uploadingView.taskNumber;
    //[[NSUserDefaults standardUserDefaults] objectForKey:@"uploadTask"];
    if(uploadCount > 0)
        return [[LBUploadTaskManager sharedInstance].uploadingView defaultHeight];
    else
        return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [LBUploadTaskManager sharedInstance].uploadingView;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //[super scrollViewWillBeginDragging:scrollView];
    [_fullScreenDelegate scrollViewWillBeginDragging:scrollView];

    int uploadCount =  [LBUploadTaskManager sharedInstance].uploadingView.taskNumber;
    if(_headerLoading && uploadCount > 0)
    {
        [self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
      
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];

    if(!(self.model == nil || [self.model count] == 1))
    {
        [_fullScreenDelegate scrollViewDidScroll:scrollView];
        navigationBarTop = scrollView.contentOffset.y;
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return [_fullScreenDelegate scrollViewShouldScrollToTop:scrollView];;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [_fullScreenDelegate scrollViewDidScrollToTop:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
