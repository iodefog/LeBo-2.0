//
//  LBSearchFriendsViewController.m
//  lebo
//
//  Created by lebo on 13-3-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBSearchFriendsViewController.h"
#define searchFriendsCount 50
@interface LBSearchFriendsViewController ()

@end

@implementation LBSearchFriendsViewController

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
    [self initialViewAndData];
    _progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
    _progressHUD.labelText = @"加载好友...";
    [_progressHUD setUserInteractionEnabled:NO];
    [_progressHUD show:YES];
    
    [self loadData:NSURLRequestReloadIgnoringLocalCacheData more:YES];
    [self addTableView];
    [self customLeftItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialViewAndData
{
    self.title = @"查找好友";
    [self.view setFrame:CGRectMake(0, 0, 320, screenSize().height - self.navigationController.navigationBar.height-self.tabBarController.tabBar.height+4)];
    _showArray = [[NSMutableArray alloc] initWithCapacity:0];
    nextCur = @"0";
    _shouldClearData = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, screenSize().height - self.navigationController.navigationBar.height)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -60, 320, 60)];
    _refreshHeaderView.delegate = self;
    
    [_refreshHeaderView refreshLastUpdatedDate];
    _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    _refreshFooterView.delegate = self;
    [_refreshFooterView refreshLastUpdatedDate];
    
    [_tableView addSubview:_refreshHeaderView];
    [_tableView setTableFooterView:_refreshFooterView];
    
    [self.view addSubview:_tableView];
}

#pragma mark - tableview delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [imageView setImage:[UIImage imageNamed:@"upload_bg_header"]];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, imageView.size.height)];
    [label setText:@"新浪好友"];
    [label setFont:[UIFont getNormalFont]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [imageView addSubview:label];
    
    return imageView;
}

- (CGRect)rectForHeaderInSection:(NSInteger)section
{
    return CGRectMake(0, 0, 320, 20);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"新浪好友";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_showArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellid = @"cellid";
    LBFriendView* friendCell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!friendCell) {
        friendCell = [[LBFriendView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
    }
    if ([_showArray count] == 0) {
        
    }else {
        [friendCell setObject:[_showArray objectAtIndex:indexPath.row]];
    }
    return friendCell;
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    } else if (scrollView.contentOffset.y > 10) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGSize size = scrollView.frame.size;
    CGFloat offsety = scrollView.contentOffset.y;
    
    CGFloat offset = scrollView.contentSize.height - size.height;
    if (offset < 0) {
        offset = 0;
    }
    if (offsety < -44) {
        // header刷新
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    } else if (offsety > offset+10) {
        // footer刷新
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark -

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    NSLog(@"egoRefreshTableHeaderDidTriggerRefresh");
    [self reloadHeaderTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _headerLoading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date];
}

- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView*)view
{
    [self reloadFooterTableViewDataSource];
}

- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView*)view
{
    return _footerLoading;
}

- (NSDate*)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView*)view
{
    return [NSDate date];
}

- (void)loadMoreData:(NSNumber *)loadHeader
{
    BOOL isMore = [loadHeader boolValue];
    [self loadData:NSURLRequestReloadIgnoringCacheData more:isMore];
}

- (void)reloadHeaderTableViewDataSource
{
    _headerLoading = YES;
    headerRefresh = YES;
    cursor = 0;
    if ([self respondsToSelector:@selector(loadMoreData:)] == YES) {
        [self performSelector:@selector(loadMoreData:) withObject:[NSNumber numberWithBool:NO]];
    }
    [self finishLoadHeaderTableViewDataSource];
}

- (void)reloadFooterTableViewDataSource
{
	_footerLoading = YES;
    headerRefresh = NO;
    if ([self respondsToSelector:@selector(loadMoreData:)] == YES ) {
        
        [self performSelector:@selector(loadMoreData:) withObject:[NSNumber numberWithBool:YES]];
    }
    
    [self finishLoadFooterTableViewDataSource];
}

- (void)finishLoadHeaderTableViewDataSource
{
    [self checkTimeout: _refreshHeaderView];
    [self performSelector:@selector(checkTimeout:) withObject:_refreshHeaderView afterDelay:0.01];
}

- (void)finishLoadFooterTableViewDataSource
{
    [self checkTimeout: _refreshFooterView];
    [self performSelector:@selector(checkTimeout:) withObject:_refreshFooterView afterDelay:0.01];
}

- (void)checkTimeout:(id)view
{
    if ([view isKindOfClass:[EGORefreshTableHeaderView class]] == YES) {
        _headerLoading = NO;
        EGORefreshTableHeaderView *header = (EGORefreshTableHeaderView *)view;
        if ([header getState] != EGOOPullRefreshNormal) {
            [header egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        }
    } else if ([view isKindOfClass:[EGORefreshTableFooterView class]] == YES) {
        _footerLoading = NO;
        EGORefreshTableFooterView *footer = (EGORefreshTableFooterView *)view;
        if ([footer getState] != EGOOPullRefreshNormal) {
            [footer egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        }
    }
}

- (void)getFriendRequestFinished:(NSData*)data
{
    
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"sina ---------***--------%@", [json_string JSONValue]);
    
    if([json_string rangeOfString:@"java.lang.NullPointerException"].location != NSNotFound)
    {
        loading = NO;
        return;
    }
    
    loading = NO;
    
    if(json_string.length > 0)
    {
        id responseObject = [[json_string JSONValue] objectForKey:@"error"];
        nextCur = [[json_string JSONValue] objectForKey:@"error"];
        [_progressHUD setHidden:YES];
        if(responseObject)
        {
            if([responseObject isKindOfClass:[NSString class]] && ([responseObject isEqualToString:@"OK"] || [responseObject isEqualToString:@"MORE"]))
            {
                id array = [[json_string JSONValue] objectForKey:@"result"];
                if(array){
                    if ([(NSArray*)array count]==0) {
                        [self didFinishLoad:nil];
                    }else {
                        [self didFinishLoad:array];
                    }
                    return;
                }else {
                    [self didFinishLoad:nil];
                }
            }else {
                [_tableView setTableFooterView:nil];
                [self didFinishLoad:nil];
            }
        }
    }
    
    else {
        [self didFinishLoad:nil];
    }
}

- (void)getFriendRequestFailed:(id)sender
{
    NSLog(@"getFriendRequestFailed");
    loading = NO;
}

- (void)didFinishLoad:(id)object
{
    if (_shouldClearData) {
        [_showArray removeAllObjects];
    }
    
    if ([object isKindOfClass:[NSArray class]]) {
        for (NSDictionary* dict in object) {
            AddSinaFriendsDTO* dto = [[AddSinaFriendsDTO alloc] init];
            NSString* accountid = [dict objectForKey:@"accountID"];
            if (accountid == nil || [accountid isEqualToString:@""]) {
                //没有乐播账号
                dto.name = [dict objectForKey:@"screen_name"];
                dto.description = [dict objectForKey:@"description"];
                dto.sinaHeaderPhotoPath = [dict objectForKey:@"avatar"];
                dto.sinaID = [dict objectForKey:@"id"];
            }else {
                //有乐播账号
                dto.name = [dict objectForKey:@"displayName"];
                dto.description = [dict objectForKey:@"sign"];
                dto.isFriends = [[dict objectForKey:@"attended"] integerValue];
                dto.sinaHeaderPhotoPath = [dict objectForKey:@"photoUrl"];
                dto.accountID = [dict objectForKey:@"accountID"];
                dto.mImageData = [dict objectForKey:@"photoUrl"];
            }
            [_showArray addObject:dto];
        }
    }
    
    if (![nextCur isEqualToString:@"MORE"]) {
        [_tableView setTableFooterView:nil];
    }
    [_tableView reloadData];
}

#pragma mark - navi item

- (void)customLeftItem
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithTitle:@"返回" image:@"general_back.png" target:self action:@selector(back)];
}

- (void)back
{
    if ([self.delegate respondsToSelector:@selector(backButtonDidClicked:)]) {
        [self.delegate performSelector:@selector(backButtonDidClicked:)];
    }
    [_progressHUD setHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    if (loading) {
        return;
    }
    loading = YES;
    _shouldClearData = !more;
    LBFileClient* client = [LBFileClient sharedInstance];
    
    if (more) {
        NSLog(@"count:%d", [_showArray count]);
        NSArray* array = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d", [_showArray count]],[NSString stringWithFormat:@"%d", [_showArray count]+searchFriendsCount],nil];
        [client checkSinaUser:array cachePolicy:NSURLRequestReloadIgnoringLocalCacheData delegate:self selector:@selector(getFriendRequestFinished:) selectorError:@selector(getFriendRequestFailed:)];
    }else {
        [client checkSinaUser:[NSArray arrayWithObjects:@"0",[NSString stringWithFormat:@"%d", searchFriendsCount],nil] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData delegate:self selector:@selector(getFriendRequestFinished:) selectorError:@selector(getFriendRequestFailed:)];
    }
    
}

@end
