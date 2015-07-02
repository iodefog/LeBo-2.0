//
//  LBAttendAndFansViewController.m
//  lebo
//
//  Created by lebo on 13-4-2.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBAttendAndFansViewController.h"

@interface LBAttendAndFansViewController ()

@end

@implementation LBAttendAndFansViewController

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
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	// Do any additional setup after loading the view.
    [_tableView setFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    self.enableFooter = NO;
    self.enableHeader = YES;
    _isCurrentUser = [self isOwnAccount];
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [self.tableView setTableHeaderView:_backView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isOwnAccount{
    
    if ([_accountID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"account"]]) {
        return YES;
    }else {
        return NO;
    }
}

- (void)setHeaderView:(UIView*)view
{
    [_backView addSubview:view];
    [_backView setFrame:CGRectMake(0, 0, 320, view.size.height)];
    [self.tableView setTableHeaderView:_backView];
    //[self.tableView reloadData];
}

- (id)initWithAccountid:(NSString*)accountID withStyle:(NSInteger)tStyle
{
    self = [super init];
    if (self) {
        _accountID = accountID;
        _bottomStyle = tStyle;
    }
    return self;
}

- (void)reloadTableViewData
{
    self.model = nil;
    [self loadData:NSURLRequestReloadIgnoringCacheData more:NO];
}

#pragma mark - overwrite

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell setTopLineHidden];
    }
    
    return cell;
}

- (API_GET_TYPE)modelApi
{
    if (_bottomStyle == personBottomStyleAttention) {
        return API_GET_FOllOW_LIST;
    }else{
        return API_GET_FANS_LIST;
    }
}

- (Class)cellClass {
    
    switch (_bottomStyle) {
        
        case personBottomStyleAttention: {
            if (_isCurrentUser) {
                return [LBAttendView class];
            }else {
                return [LBOtherAttendView class];
            }
            
            break;
        }
        case personBottomFuns: {
            if (_isCurrentUser) {
                return [LBFansView class];
            }else {
                return [LBOtherFansView class];
            }
            
            break;
        }
        default:
            return [LBAttendView class];
            break;
    }
}

- (void)reloadHeaderTableViewDataSource
{
    _headerLoading = YES;
    if ([self respondsToSelector:@selector(loadMoreData:)] == YES) {
        [self performSelector:@selector(loadMoreData:) withObject:[NSNumber numberWithBool:NO]];
    }
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    if ([_delegate respondsToSelector:@selector(userInfoShouldReload)]) {
        [_delegate performSelector:@selector(userInfoShouldReload)];
    }
    [self reloadHeaderTableViewDataSource];
}


- (void)loadData:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more{
    
    API_GET_TYPE api_type = [self modelApi];
    
    if (loading) {
        return;
    }
    
    loading = YES;
    
    LBFileClient *client = [LBFileClient sharedInstance];
    
    switch (api_type) {
        case API_GET_FOllOW_LIST:
            [client getMyAttendList:[NSArray arrayWithObjects:_accountID, @"20", [self getListID:more], nil] cachePolicy: NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        case API_GET_FANS_LIST:
            [client getMyFansList:[NSArray arrayWithObjects:_accountID, @"20", [self getListID:more], nil] cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            break;
        default:
            loading = NO;
            break;
    }
}

- (void)requestDidFinishLoad:(NSData*)data
{
    
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    loading = NO;
    
    NSLog(@"-----%@", [json_string JSONValue]);
    
    if(json_string.length > 0)
    {
        
        id responseObject = [[json_string JSONValue] objectForKey:@"error"];
        
        if(responseObject)
        {
            if([responseObject isKindOfClass:[NSString class]] && [responseObject isEqualToString:@"OK"])
            {
                id array = [[json_string JSONValue] objectForKey:@"result"];
                if(array){
                    [self didFinishLoad:array];
                    return;
                }
            }
            
        }
        
    }
//    else {
//        [self didFinishLoad:nil];
//    }
}

- (NSString*)getListID:(BOOL)more
{
    NSString* leboid = @"";
    if (more) {
        if([(NSArray*)self.model count] > 0 && [(NSArray*)self.model isKindOfClass:[NSArray class]]){
            
            leboid = [self.model[[(NSArray*)self.model count] -1] objectForKey:@"accountID"];
            
            if (!leboid) {
                leboid = @"";
            }
        }
    }else {
        leboid = @"";
    }
    
    return leboid;
}

- (void)requestError:(NSData*)data{
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"数据加载失败";
    [hud hide:YES afterDelay:1];
    [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
    loading = NO;
    
    NSLog(@"requestError");
    loading = NO;
}

#pragma mark delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}
@end
