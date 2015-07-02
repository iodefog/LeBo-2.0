//
//  LBPersonVideoViewController.m
//  lebo
//
//  Created by lebo on 13-4-2.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBPersonVideoViewController.h"
@interface LBPersonVideoViewController ()

@end

@implementation LBPersonVideoViewController

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
    if (shouldShow) {
        self.enableFooter = NO;
        [super viewWillAppear:animated]; 
    }else {
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (id)initWithAccountid:(NSString*)accountID withStyle:(NSInteger)tStyle{

    self = [super init];
    if (self) {
        _accountID = accountID;
        _bottomStyle = tStyle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    shouldShow = YES;
    self.enableFooter = NO;
    self.enableHeader = YES;
    [_tableView setFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [self loadData:NSURLRequestReloadIgnoringLocalCacheData more:NO];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}

- (void)changePlayState:(BOOL)state
{
    shouldShow = state;
}

- (void)setHeaderView:(UIView*)view
{
    [_backView addSubview:view];
    [_backView setFrame:CGRectMake(0, 0, 320, view.size.height)];
    [_tableView setFrame:CGRectMake(0, 0, 320, self.view.size.height)];
    [self.tableView setTableHeaderView:_backView];
    //[self.tableView reloadData];
}

- (void)reloadTableViewData
{
    self.model = nil;
    [self loadData:NSURLRequestReloadIgnoringCacheData more:NO];
}

#pragma mark - overwrite

- (API_GET_TYPE)modelApi
{
    if (_bottomStyle == personBottomStyleVideo) {
        return API_GET_MY_VIDEO_LIST;
    }else if (_bottomStyle == personBottomStyleFavor){
        return API_GET_MY_LOVE_VIDEO_LIST;
    }
    return 100;
}

- (Class)cellClass {
   
    switch (_bottomStyle) {
        case personBottomStyleVideo:
            return [LBTempClipsCell class];
            break;
        case personBottomStyleFavor:
            return [LBTempClipsCell class];
            break;
        default:
            return [LBTempClipsCell class];
            break;
    }
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    if ([_delegate respondsToSelector:@selector(userInfoShouldReload)]) {
        
        [_delegate performSelector:@selector(userInfoShouldReload)];
        
    }
    [self reloadHeaderTableViewDataSource];
}

- (void)reloadHeaderTableViewDataSource
{
    _headerLoading = YES;
    if ([self respondsToSelector:@selector(loadMoreData:)] == YES) {
        [self performSelector:@selector(loadMoreData:) withObject:[NSNumber numberWithBool:NO]];
    }
}

- (void)loadMoreData:(NSNumber *)loadHeader
{
    BOOL loadMore = [loadHeader boolValue];
    [self loadData:loadMore ?NSURLRequestReturnCacheDataElseLoad:NSURLRequestReloadIgnoringCacheData more:loadMore];
}

- (void)loadData:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more
{    
    API_GET_TYPE api_type = [self modelApi];
    
    if (loading) {
        
        return;
    }
    
    loading = YES;
    
    LBFileClient *client = [LBFileClient sharedInstance];
    switch (api_type) {
        case API_GET_MY_VIDEO_LIST: {
            [client getMyLeboList:[NSArray arrayWithObjects: _accountID, @"20", [self getLeboID:more], nil] cachePolicy:NSURLRequestReloadIgnoringCacheData  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
        }
            break;
        case API_GET_MY_LOVE_VIDEO_LIST: {
            [client getMyLoveList:[NSArray arrayWithObjects:_accountID, @"20", [self getLeboID:more], nil] cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
        }
            break;
        default:
            loading = NO;
            break;
    }
}

- (void)requestDidFinishLoad:(NSData*)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"---**getMyList**--%@", [json_string JSONValue]);
    loading = NO;
    
    [self.errorView removeFromSuperview];
    
    if(json_string.length > 0)
    {
        id responseObject = [[json_string JSONValue] objectForKey:@"error"];
        
        if(responseObject)
        {
            if([responseObject isKindOfClass:[NSString class]] && [responseObject isEqualToString:@"OK"])
            {
                id array = [[json_string JSONValue] objectForKey:@"result"];
                if(array){
                    if (shouldShow) {
                        [self didFinishLoad:array];
                    }
                    return;
                }
            }
        }
    }
}

- (void)requestError:(NSData*)data
{
    loading = NO;
    //NSLog(@"error----%@", data);
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"数据加载失败";
    [hud hide:YES afterDelay:1];
    [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
    if (_headerLoading) {
        [self finishLoadHeaderTableViewDataSource];
    }
    if (_footerLoading) {
        [self finishLoadFooterTableViewDataSource];
    }
    
}

@end
