//
//  LBTableApiViewController.m
//  lebo
//
//  Created by yong wang on 13-3-21.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBTableApiViewController.h"
#import "LBTableCellDelegate.h"
#import "LBTempClipsCell.h"

@implementation LBTableApiViewController

@synthesize tableView = _tableView;
@synthesize enableFooter;
@synthesize enableHeader;
@synthesize enableFooterTemp;
@synthesize errorImageView = _errorImageView;
@synthesize errorLabel = _errorLabel;
@synthesize errorView = _errorView;
@synthesize activityIndicator = _activityIndicator;
@synthesize isTracking;

- (Class)cellClass {
    //NSAssert(NO, @"subclasses to override");
    return NULL;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didFailWithError:(int)type
{
    
    if(_activityIndicator)
    {
        [self activityIndicatorAni:NO];
    }
    
    if(_footerLoading)
    {
        [self finishLoadFooterTableViewDataSource];
    }
    
    if(_headerLoading)
    {
        [self finishLoadHeaderTableViewDataSource];
    }
    
    NSString *strFailText = @"网络异常，请稍后重试";
    if([Global checkNetWorkWifiOf3G] == 0)
    {
        strFailText = @"当前没有连接到网络";
    }
    else if(-1001 == type)
    {
        strFailText = @"连接超时，请稍后重试";
    }
    
    [_errorView removeFromSuperview];
    
    if(self.model && [self.model count] > 0)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:strFailText];
        return;
    }

    CGFloat fErrorImageViewTop = (self.tableView.height - self.tableView.tableHeaderView.height)/2 + self.tableView.tableHeaderView.height;

    [_errorLabel setText:strFailText];
    [_errorImageView setImage:[UIImage imageNamed:@"no_people_dark"]];
    [_errorView setCenterY:fErrorImageViewTop];
    [_errorView setCenterX:self.tableView.centerX];
    [self.tableView addSubview:_errorView];
}

- (void)didFinishLoad:(id)array {
    
    if(_activityIndicator)
    {
        [self activityIndicatorAni:NO];
    }
    
    //if (array != nil)
    {
        [_errorView removeFromSuperview];
    }
       
    if(_footerLoading)
    {
        [self finishLoadFooterTableViewDataSource];
    }
    
    if(_headerLoading)
    {
        self.model = nil;
        [self finishLoadHeaderTableViewDataSource];
    }
    
    if([array count] == 0)
    {
        if(self.model == nil)
        {
            [self addSubErrorView];
            [self.tableView reloadData];
        }
        self.enableFooter = NO;
        
        return;
    }
    
    if([array count] < 20)
    {
        self.enableFooter = NO;
    }
    else
    {
        self.enableFooter = YES;
    }
    
    [super didFinishLoad:array];
    [self.tableView reloadData];
}

- (void)addSubErrorView
{
    CGFloat fErrorImageViewTop = (self.tableView.height - self.tableView.tableHeaderView.height)/2 + self.tableView.tableHeaderView.height;
    
    [_errorLabel setShadowColor:[UIColor colorWithRed:216./255. green:216./255. blue:216./255. alpha:1.]];
    API_GET_TYPE api_type = [self modelApi];
    switch (api_type) {
        case API_GET_FOllOW_LIST:
            [_errorLabel setText:@"没有关注"];
            [_errorImageView setImage:[UIImage imageNamed:@"no_people_dark"]];
            break;
        case API_GET_FANS_LIST:
            [_errorLabel setText:@"没有粉丝"];
            [_errorImageView setImage:[UIImage imageNamed:@"no_people_dark"]];
            break;
        case API_GET_MESSAGE_LIST:
            [_errorLabel setText:@"没有消息"];
            [_errorImageView setImage:[UIImage imageNamed:@"no_people_light"]];
            break;
        case API_GET_COMMENT_LIST:
            [_errorLabel setText:@"没有评论"];
            [_errorImageView setImage:[UIImage imageNamed:@"no_message"]];
            break;
        case API_GET_SEARCH_USER:
        case API_GET_SEARCH_CHANNEL:
            fErrorImageViewTop -= 80;
            [_errorImageView setImage:[UIImage imageNamed:@"aa"]];
            [_errorLabel setText:@"没有结果"];
            break;
        case API_GET_RECOMMEND_LIST:
            [_errorImageView setImage:[UIImage imageNamed:@"no_people_dark"]];
            [_errorLabel setText:@"没有推荐"];
            break;
        case API_GET_TOPFANS_LIST:
            [_errorImageView setImage:[UIImage imageNamed:@"no_people_dark"]];
            [_errorLabel setText:@"网络异常，请稍后重试"];
            break;
        case API_GET_TOPLOVE_LIST:
            [_errorImageView setImage:[UIImage imageNamed:@"no_people_dark"]];
            [_errorLabel setText:@"网络异常，请稍后重试"];
            break;
        case API_GET_TOPPLAY_LIST:
            [_errorImageView setImage:[UIImage imageNamed:@"no_people_dark"]];
            [_errorLabel setText:@"网络异常，请稍后重试"];
            break;
        case API_GET_CHANNEL_LIST:
            [_errorImageView setImage:[UIImage imageNamed:@"no_movie_dark"]];
            [_errorLabel setText:@"没有频道"];
            [_errorLabel setShadowColor:[UIColor blackColor]];
            break;
            
        default:
            [_errorLabel setText:@"没有视频"];
            [_errorImageView setImage:[UIImage imageNamed:@"no_movie_dark"]];
            break;
    }
    [_errorView setCenterY:fErrorImageViewTop];
    [_errorView setCenterX:self.tableView.centerX];
 
    [_tableView addSubview:_errorView];
    [_tableView sendSubviewToBack:_errorView];
}

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.origin.x, 0, self.view.width, self.view.height + 2) style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorColor:[UIColor clearColor]];
    [_tableView setBackgroundColor:[UIColor colorWithRed:204./255. green:204./255. blue:204./255. alpha:1.0]];
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -60, self.tableView.width, 60)];
    _refreshHeaderView.delegate = self;
    
    [_refreshHeaderView refreshLastUpdatedDate];
    _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 48)];
    _refreshFooterView.delegate = self;
    _headerLoading = NO;
    _footerLoading = NO;
    [_refreshFooterView refreshLastUpdatedDate];
    
    [self.view addSubview:self.tableView];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicator setHidesWhenStopped:YES];
    [_activityIndicator setCenter:self.tableView.center];
    [_activityIndicator setTop:_activityIndicator.top - 50];
    [self activityIndicatorAni:YES];
    [self.tableView addSubview:_activityIndicator];
    [self createErrorView];
} 

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [LBMovieView pauseAll];
    [Global clearPlayStatus];
  
    if(_activityIndicator)
    {
        [self activityIndicatorAni:NO];
    }
}

- (void)createErrorView
{
    self.errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 70)];
    [_errorView setBackgroundColor:[UIColor clearColor]];
    self.errorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_movie"]];
    [_errorImageView setBackgroundColor:[UIColor clearColor]];
    [_errorImageView setFrame:CGRectMake(40, 0, 70, 70)];
    
    self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 12)];
    [_errorLabel setTop:_errorImageView.bottom +5];
    [_errorLabel setFont:[UIFont systemFontOfSize:12.]];
    [_errorLabel setTextColor:[UIColor colorWithRed:155./255. green:155./255. blue:155./255. alpha:1.0]];
    [_errorLabel setShadowColor:[UIColor colorWithRed:216./255. green:216./255. blue:216./255. alpha:1.]];
    [_errorLabel setShadowOffset:CGSizeMake(0, 1)];
    [_errorLabel setTextAlignment:UITextAlignmentCenter];
    [_errorLabel setBackgroundColor:[UIColor clearColor]];
    
    [_errorView addSubview:_errorImageView];
    [_errorView addSubview:_errorLabel];
    [_errorView setCenterX:self.tableView.centerX];
    
}
//
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [LBMovieView pauseAll];
    [Global clearPlayStatus];
    self.isTracking = YES;
    [self.tableView reloadData];
    [self activityIndicatorState];
       
}

- (void)activityIndicatorAni:(BOOL)animal
{
    if(animal)
    {
        CGFloat activityIndicatorY = (self.tableView.height - self.tableView.tableHeaderView.height)/2 + self.tableView.tableHeaderView.height;
        int nHeight = 15.;
        
        switch ((int)[self modelApi]) {
            case API_GET_MY_VIDEO_LIST:
            case API_GET_MY_LOVE_VIDEO_LIST:
            case API_GET_FOllOW_LIST:
            case API_GET_FANS_LIST:
                nHeight = 0.0;
                break;
        }
     
        [_activityIndicator setCenterY:activityIndicatorY - nHeight];
        
        
        [_activityIndicator startAnimating];
    }
    else
    {
        [_activityIndicator stopAnimating];
    }
    
}
- (void)activityIndicatorState
{
    if(_activityIndicator && _errorView &&![_errorView isDescendantOfView:self.tableView] && self.model == nil)
    {
        [self activityIndicatorAni:YES];
    }
    else if(_activityIndicator)
    {
        [self activityIndicatorAni:NO];
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setSeparatorClear
{
    [self.tableView setSeparatorColor:[UIColor clearColor]];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.model== nil)
        return 0;
    if([self.model isKindOfClass:[NSDictionary class]])
        return 1;
    
    return [self.model count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class cls = [self cellClass];
    static NSString *identifier = @"Cell";
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[cls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if ([cell respondsToSelector:@selector(setObject:)]) {
        if([self.model count] > indexPath.row)
        {
            id item = nil;
            if(self.model != nil && [self.model isKindOfClass:[NSArray class]])
                item = [self.model objectAtIndex:indexPath.row];
            else if(self.model != nil && [self.model isKindOfClass:[NSDictionary class]])
                item = self.model;
            //item = [self.model objectAtIndex:indexPath.row];
            [cell setObject:item];
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![cell isKindOfClass:[LBTempClipsCell class]])
        return;
    
    if(self.isTracking == NO)
        return;
    
    self.isTracking = NO;
    
    id curPlayRow = [self getCurPlayCellIndex];
    
    if((indexPath.row == 0 && curPlayRow == nil) )
    {
        if([self respondsToSelector:@selector(changeCellPlay:)])
            
            [self performSelector:@selector(changeCellPlay:) withObject:[NSNumber numberWithInt:0] afterDelay:0.0];
    }
    else
    {
        if(curPlayRow)
        {
            if([self respondsToSelector:@selector(changeCellPlay:)])
            {
                [self performSelector:@selector(changeCellPlay:) withObject:curPlayRow afterDelay:0.0];
                
            }
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id item = nil;
    if(self.model != nil && [self.model isKindOfClass:[NSArray class]])
        item = [self.model objectAtIndex:indexPath.row];
    else if(self.model != nil && [self.model isKindOfClass:[NSDictionary class]])
        item = self.model;
    Class cls = [self cellClass];
    if ([cls respondsToSelector:@selector(rowHeightForObject:)]) {
        return [cls rowHeightForObject:item];
    }
    return tableView.rowHeight; // failover
}

- (id)getCurPlayCellIndex
{
    id curPlayCellIndex = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"curPlayCellIndex_%d",[self modelApi]]];
    
    if(curPlayCellIndex)
    {
        return [self.tableView.indexPathsForVisibleRows count] > [curPlayCellIndex intValue]?  curPlayCellIndex: [NSNumber numberWithInt:0];
    }
    
    return [NSNumber numberWithInt:0];
}

#pragma scro

- (void)setEnableFooter:(BOOL)tf
{
    enableFooter = tf;
    enableFooterTemp = tf;
    /*
     if (tf == YES) {
     if ([self.subviews containsObject:_refreshFooterView] == NO) {
     [self addSubview:_refreshFooterView];
     }
     } else {
     if ([self.subviews containsObject:_refreshFooterView] == YES) {
     [_refreshFooterView removeFromSuperview];
     }
     }
     */
    if (tf == YES) {
        //[_refreshFooterView setBackgroundColor:[UIColor redColor]];
        [self.tableView setTableFooterView:_refreshFooterView];
    } else {
        [self.tableView setTableFooterView:nil];
    }
}

- (void)setEnableHeader:(BOOL)tf
{
    enableHeader = tf;
    if (tf == YES) {
        if ([self.tableView.subviews containsObject:_refreshHeaderView] == NO) {
            [self.tableView addSubview:_refreshHeaderView];
        }
    } else {
        if ([self.tableView.subviews containsObject:_refreshHeaderView] == YES) {
            [_refreshHeaderView removeFromSuperview];
        }
    }
}

- (void)updateFooter
{
    /*
     CGSize size = self.contentSize;
     CGSize size2 = self.frame.size;
     if (size.height < size2.height) {
     size.height = size2.height;
     }
     
     _refreshFooterView.frame = CGRectMake(0, size.height, size.width, 60);
     */
}

- (void)showDataLoading:(CGFloat)offsety
{
    // 会调用loadHeader
    if (enableHeader == YES && offsety < -44)
    {
        self.tableView.contentOffset = CGPointMake(0, offsety);
        [_refreshHeaderView egoRefreshScrollViewDidScroll: self.tableView];
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging: self.tableView];
    }
}

- (void)activeRefresh
{
    [self showDataLoading: -70];
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([LBTempClipsCell class] != [self cellClass])
        return;
    
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 5) {
        _lastPosition = currentPostion;
    }
    else if (_lastPosition - currentPostion > 5)
    {
        _lastPosition = currentPostion;
    }
    
    if([self.tableView.indexPathsForVisibleRows count] == 1)
    {
        [self changeCellPlay:[NSNumber numberWithInt:0]];
    }
    else if([self.tableView.indexPathsForVisibleRows count] == 2)
    {
        CGRect cellRectTemp1 = [self.tableView rectForRowAtIndexPath:[self.tableView.indexPathsForVisibleRows objectAtIndex:0]] ;
        CGRect cellRect1 = [self.tableView convertRect:cellRectTemp1 toView:[self.tableView superview]];
        CGRect cellRectTemp2 = [self.tableView rectForRowAtIndexPath:[self.tableView.indexPathsForVisibleRows objectAtIndex:1]] ;
        CGRect cellRect2 = [self.tableView convertRect:cellRectTemp2 toView:[self.tableView superview]];
        
        if(cellRect1.size.height - abs(cellRect1.origin.y) > cellRect2.size.height- abs(cellRect2.origin.y))
        {
            [self changeCellPlay:[NSNumber numberWithInt:0]];
        }
        else
        {
            [self changeCellPlay:[NSNumber numberWithInt:1]];
        }
    }
    else if([self.tableView.indexPathsForVisibleRows count] == 3)
    {
        [self changeCellPlay:[NSNumber numberWithInt:1]];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //[LBMovieView pauseAll];
    [Global clearPlayStatus];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[Global clearPlayStatus];
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
    //NSLog(@"scrollViewDidEndDragging %f %f",scrollView.contentSize.height, offsety);
    
    CGFloat offset = scrollView.contentSize.height - size.height;
    if (offset < 0) {
        offset = 0;
    }
    if (enableHeader == YES && offsety < -50) {
        // header刷新
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    } else if (enableFooter == YES && offsety > offset+10) {
        // footer刷新
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    if(!scrollView.isDecelerating && [LBTempClipsCell class] == [self cellClass])
    {   
        [self playVideoFowScroller:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //[LBMovieView pauseAll];
}

- (void)playVideoFowScroller:(UIScrollView*)scrollView
{
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 5) {
        _lastPosition = currentPostion;
        if([self.tableView.indexPathsForVisibleRows count] > 1)
        {
            CGRect rect1 = [self.tableView rectForRowAtIndexPath:[self.tableView.indexPathsForVisibleRows objectAtIndex:1]] ;
            CGRect rect = [self.tableView convertRect:rect1 toView:[self.tableView superview]];
            NSLog(@"ScrollUP now  %f",rect.origin.y);
            
            if([[[UIDevice currentDevice] platformString] isEqualToString: IPHONE_5_NAMESTRING])
            {
                if(rect.origin.y < 230)
                {
                    [self changeCellPlay:[NSNumber numberWithInt:1]];
                }
            }
            else
            {
                if(rect.origin.y < 180)
                {
                    [self changeCellPlay:[NSNumber numberWithInt:1]];
                }
            }
        }
        
    }
    else if (_lastPosition - currentPostion > 5)
    {
        _lastPosition = currentPostion;
        
        if([self.tableView.indexPathsForVisibleRows count] > 1)
        {
            CGRect rect1 = [self.tableView rectForRowAtIndexPath:[self.tableView.indexPathsForVisibleRows objectAtIndex:0]] ;
            CGRect rect = [self.tableView convertRect:rect1 toView:[self.tableView superview]];
            NSLog(@"ScrollDOWN now  %f",rect.origin.y);
            
            if([[[UIDevice currentDevice] platformString] isEqualToString: IPHONE_5_NAMESTRING])
            {
                if(rect.origin.y < -100 )
                {
                    [self changeCellPlay:[NSNumber numberWithInt:0]];
                }
            }
            else
            {
                if(rect.origin.y > -230)
                {
                    [self changeCellPlay:[NSNumber numberWithInt:0]];
                }
            }
        }
    }
}

- (void)changeCellPlay:(NSNumber*)rowIndex
{
    int row = [rowIndex intValue];
    if([self.tableView.indexPathsForVisibleRows count] > row)
    {
        LBTempClipsCell *cell = (LBTempClipsCell*)[self.tableView cellForRowAtIndexPath:[self.tableView.indexPathsForVisibleRows objectAtIndex:row]];
        if([cell isKindOfClass:[LBTempClipsCell class]])
        {
            BOOL play = [cell respondsToSelector:@selector(playVideo:)];
            if (play)
            {
                
                [[NSUserDefaults standardUserDefaults] setObject:rowIndex forKey: [NSString stringWithFormat:@"curPlayCellIndex_%d",[self modelApi]]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [cell playVideo:[rowIndex intValue]];
                
            }
            else
            {
                [self changeCellPlay:[NSNumber numberWithInt:row]];
                //[self performSelector:@selector(changeCellPlay:) withObject:[NSNumber numberWithInt:row] afterDelay:1];
            }
        }
    }
}

#pragma mark -

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
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
    [super loadMoreData:loadHeader];
    //[self updateFooter];
}

- (void)reloadHeaderTableViewDataSource
{
    if([_activityIndicator isAnimating])
    {
        [self finishLoadHeaderTableViewDataSource];
        return;
    }
    _headerLoading = YES;
    if ([self respondsToSelector:@selector(loadMoreData:)] == YES) {
        [self performSelector:@selector(loadMoreData:) withObject:[NSNumber numberWithBool:NO]];
    }
    //[self finishLoadHeaderTableViewDataSource];
}

- (void)reloadFooterTableViewDataSource
{
	_footerLoading = YES;
    if ([self respondsToSelector:@selector(loadMoreData:)] == YES) {
        [self performSelector:@selector(loadMoreData:) withObject:[NSNumber numberWithBool:YES]];
    }
    
    //[self finishLoadFooterTableViewDataSource];
}

- (void)finishLoadHeaderTableViewDataSource
{
 
    //    [self checkTimeout: _refreshHeaderView];
    [self performSelector:@selector(checkTimeout:) withObject:_refreshHeaderView afterDelay:0.01];
}

- (void)finishLoadFooterTableViewDataSource
{
    //    [self checkTimeout: _refreshF ooterView];
    [self performSelector:@selector(checkTimeout:) withObject:_refreshFooterView afterDelay:0.01];
}

- (void)checkTimeout:(id)view
{
    if ([view isKindOfClass:[EGORefreshTableHeaderView class]] == YES) {
        _headerLoading = NO;
        if([LBTempClipsCell class] == [self cellClass])
        {
            [Global clearPlayStatus];
            [self changeCellPlay:[NSNumber numberWithInt:0]];
        }
        EGORefreshTableHeaderView *header = (EGORefreshTableHeaderView *)view;
        if ([header getState] != EGOOPullRefreshNormal) {
            [header egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
    } else if ([view isKindOfClass:[EGORefreshTableFooterView class]] == YES) {
        _footerLoading = NO;
        EGORefreshTableFooterView *footer = (EGORefreshTableFooterView *)view;
        if ([footer getState] != EGOOPullRefreshNormal) {
            [footer egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
    }
}

@end
