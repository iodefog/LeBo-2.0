//
//  LBRedListViewController.m
//  lebo
//
//  Created by King on 13-4-17.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBRedListViewController.h"
#import "LBPersonViewBasicCell.h"
#import "CustomSearchBar.h"
#import "LBSearchViewController.h"
#import "LBTopViewController.h"
#import "LBRecommendCell.h"

@interface LBRedListViewController ()

@end

@implementation LBRedListViewController
@synthesize searchViewController = _searchViewController;
@synthesize disableViewOverlay =_disableViewOverlay;
@synthesize searchBar = _searchBar;

static LBRedListViewController *_sharedInstance = nil;

+ (LBRedListViewController *)sharedInstance
{
    @synchronized(self)
    {
        if (_sharedInstance == nil)
        {
            _sharedInstance = [[LBRedListViewController alloc] init];
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
    BOOL isHide = [self.searchViewController.view isDescendantOfView:self.tableView];
    [self.navigationController setNavigationBarHidden:isHide animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    self.enableHeader = YES;

    self.searchBar = [[CustomSearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.placeholder = @"搜索乐播用户";
    _searchBar.delegate = self;
    [_searchBar sizeToFit];
    
    self.disableViewOverlay = [[UIView alloc]
                               initWithFrame:CGRectMake(0.0f,44.0f,320.0f,416.0f)];
    _disableViewOverlay.backgroundColor=[UIColor blackColor];
    _disableViewOverlay.alpha = 0;
    [_disableViewOverlay setUserInteractionEnabled:YES];
    [_disableViewOverlay addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disableViewOverlayTapped:)]];

    UIView *tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 150)];
    [tableViewHeader setBackgroundColor:[UIColor colorWithRed:192. green:192. blue:192.]];
    [tableViewHeader addSubview:_searchBar];
    
    NSArray *arrayTitles = @[@"粉丝最多",@"最受喜欢",@"票房最高"];
    //NSArray *arrayImages = @[@"btn_fans_icon",@"btn_fav_icon",@"btn_boxoffice_icon"];
    NSArray *arrayImages = @[@"/rank-images/btn_fans_icon.png", @"/rank-images/btn_fav_icon.png", @"/rank-images/btn_boxoffice_icon.png"];
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(18.5, 10, 69, 69)];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerBaseUrl], arrayImages[i]]]];
        NSLog(@"%@%@", [Global getServerBaseUrl], arrayImages[i]);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor blackColor]];
        [button setFrame:CGRectMake(i *107, _searchBar.bottom, 106, 106)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13.]];
        [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:50. green:50. blue:50.] forState:UIControlStateNormal];
        [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [button setTitle:arrayTitles[i] forState:UIControlStateNormal];
        //[button setImage:[UIImage imageNamed:arrayImages[i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_searchview_background"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_searchview_background_select"] forState:UIControlStateHighlighted];
        //[button setImageEdgeInsets:UIEdgeInsetsMake(-25., 14., .0, 14.)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(70., 0., 0, 0)];
        button.tag = i + 123;
        [button.layer addSublayer:imageView.layer];
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewHeader addSubview:button];
    }    
    [self.tableView setTableHeaderView:tableViewHeader];

    self.searchViewController = [[LBSearchViewController alloc] init];
    [self.view setBackgroundColor:[UIColor grayColor]];
    //[self.tableView setBackgroundColor:[UIColor whiteColor]];
}

- (Class)cellClass {
    return [LBRecommendCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_GET_RECOMMEND_LIST;
}

#pragma mark - TableView Delegate
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImage *image = [UIImage imageNamed:@"section_header"];
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 22)];
    
    [headerView setImage:[image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 22)];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setFont:[UIFont systemFontOfSize:12]];
    [headerLabel setTextColor:[UIColor colorWithRed:50./255. green:50./255. blue:50./255. alpha:1.0]];
    [headerLabel setShadowOffset:CGSizeMake(0, 1)];
    [headerLabel setText:@"   推荐关注"];
    [headerView addSubview:headerLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.;
}
 
- (void)clickBtn:(UIButton *)btn
{
    LBTopViewController *topContrller = [[LBTopViewController alloc] init];
    
    switch (btn.tag) {
        case 123:
            topContrller.controllerTag = 1;
            break;
        case 124:
            topContrller.controllerTag = 2;
            break;
        case 125:
            topContrller.controllerTag = 3;
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:topContrller animated:YES];
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
    _searchViewController.searchWho = 1;
    _searchViewController.searchString = searchBar.text;
    [_searchViewController.view setTop:self.searchBar.bottom];

    [self.tableView addSubview:_searchViewController.view];
    
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
            _disableViewOverlay.alpha = 0;
            [self.tableView addSubview:_disableViewOverlay];
            [self.tableView bringSubviewToFront:_disableViewOverlay];
            
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
            //[_searchViewController.tableView reloadData];
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
