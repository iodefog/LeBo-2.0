//
//  LBChannelViewController.m
//  lebo
//
//  Created by yong wang on 13-3-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBChannelViewController.h"
#import "LBChannelCell.h"
#import "CustomSearchBar.h"
#import "LBSearchViewController.h"

@implementation LBChannelViewController

static LBChannelViewController *_sharedInstance = nil;

+ (LBChannelViewController *)sharedInstance
{
    @synchronized(self)
    {
        if (_sharedInstance == nil)
        {
            _sharedInstance = [[LBChannelViewController alloc] init];
        }
    }
    return _sharedInstance;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BOOL isHide = [self.searchViewController.view isDescendantOfView:self.tableView];
    [self.navigationController setNavigationBarHidden:isHide animated:YES];
}

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
    self.enableFooter = NO;
    self.enableHeader = YES;
    self.tableView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    
    self.searchBar = [[CustomSearchBar alloc] initWithFrame: CGRectZero];
    _searchBar.placeholder = @"频道搜索";
    _searchBar.delegate = self;
    [_searchBar setHeight:44.];
    [_searchBar sizeToFit];
    
    self.disableViewOverlay = [[UIView alloc]
                               initWithFrame:CGRectMake(0.0f,44.0f,320.0f,416.0f)];
    _disableViewOverlay.backgroundColor = [UIColor blackColor];
    _disableViewOverlay.alpha = 0;
    [_disableViewOverlay setUserInteractionEnabled:YES];
    [_disableViewOverlay addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disableViewOverlayTapped:)]];
    
    self.searchViewController = [[LBSearchViewController alloc] init];
    [self.tableView setTableHeaderView:_searchBar];
}

- (void)didFinishLoad:(id)object
{
    [super didFinishLoad:object];
    self.enableFooter = NO;
}

- (Class)cellClass {
    return [LBTempChannelCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_GET_CHANNEL_LIST;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.model == nil)
        return 0;
    
    return [self.model count] / 3 + (([self.model count] % 3) > 0 ?1:0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Class cls = [self cellClass];
    static NSString *identifier = @"Cell";
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[cls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    int nStep = (3 * indexPath.row);
    NSRange range = NSMakeRange(nStep, 3);
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    
    if([self.model count] / (3 + range.location) > 0)
    {
        [cell setObject:[self.model objectsAtIndexes:indexSet]];
    } else {
        NSRange range = NSMakeRange(nStep, [self.model count] - nStep);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [cell setObject:[self.model objectsAtIndexes:indexSet]];
    }

    return cell;
}

- (void)disableViewOverlayTapped:(UIGestureRecognizer*)gestureRecognizer
{
    [self searchBarCancelButtonClicked:_searchBar];
}

#pragma mark -
#pragma mark CustomSearchBarDelegate method

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self finishLoadHeaderTableViewDataSource];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self searchBar:searchBar activate:YES];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    if([self.searchViewController.view isDescendantOfView:self.tableView])
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self searchBar:searchBar activate:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchViewController.view removeFromSuperview];
    _searchViewController.searchWho = 0;
    _searchViewController.searchString = searchBar.text;
    [_searchViewController.view setTop:self.searchBar.bottom];
    [self.tableView addSubview:_searchViewController.view];
    _searchViewController.view.backgroundColor = [UIColor redColor];
    [searchBar resignFirstResponder];
    
    for(UIView *subView in searchBar.subviews) {
        if(!(subView == nil)) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *sbtn = (UIButton *)subView;
                [sbtn setEnabled:YES];
                
            }
        }
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active{
    
    if (!active) {
        [_searchViewController.view removeFromSuperview];
        [_disableViewOverlay removeFromSuperview];
        searchBar.text = @"";
        [searchBar resignFirstResponder];
        
    } else{
        if(![_searchViewController.view isDescendantOfView:self.tableView])
        {
            self.disableViewOverlay.alpha = 0;
            [self.tableView addSubview:self.disableViewOverlay];
            
            [UIView beginAnimations:@"FadeIn" context:nil];
            [UIView setAnimationDuration:0.4];
            self.disableViewOverlay.alpha = 0.7;
            [UIView commitAnimations];
        }
        else
        {
            [self.tableView bringSubviewToFront:_disableViewOverlay];
            _searchViewController.model = nil;
            [_searchViewController.view removeFromSuperview];
        }
        
    }
    [self.tableView setScrollEnabled:!active];
    [searchBar setShowsCancelButton:active animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
