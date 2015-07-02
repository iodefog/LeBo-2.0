//
//  LBPersonDetailViewController.m
//  lebo
//
//  Created by lebo on 13-4-2.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBPersonDetailViewController.h"
#import "LBAppDelegate.h"

#define kPersonDistance 10.0f
@interface LBPersonDetailViewController ()

@end

@implementation LBPersonDetailViewController
@synthesize currentAccount = _currentAccount;

static LBPersonDetailViewController *_sharedInstance = nil;

+ (LBPersonDetailViewController *)sharedInstance
{
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

- (id)initWithAccountID:(NSString*)accountID
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        account = [[AccountDTO alloc] init];
        self.currentAccount = accountID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _subControllerShouldReload = YES;
    _controllerArray = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i = 0; i < 5; i++) {
        _controllerArray[i] = [NSNull null];
    }
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view setFrame:CGRectMake(0, 0, 320, self.view.height)];
    
    _isCurrentUser = [self isOwnAccount];
    
    if (_isCurrentUser) {
        _currentAccount = [[AccountHelper getAccount] AccountID];
    }
    
    if (_currentAccount == nil) {
        
        _currentAccount = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
        _isCurrentUser = YES;
    }
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithTitle:@"返回" image:@"general_back.png" target:self action:@selector(backButtonClicked:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personInfoReload:) name:@"changeHead" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personInfoReload:) name:@"changeSign" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personInfoReload:) name:@"LBUploadTaskDidFinished" object:nil];
    
    [self initTableViewHeader];
    [self initControllerArray];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    NSLog(@"viewDidUnload");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self sendCurrentAccountInfo:YES];
    
    id lvc = [_controllerArray objectAtIndex:_segmentIndex];
    if (_subControllerShouldReload) {
        [lvc viewWillAppear:NO];
    }
    _sharedInstance = self;
    _subControllerShouldReload = YES;
    if ([lvc isKindOfClass:[LBPersonVideoViewController class]]) {
        [lvc changePlayState:YES];
    }
    [lvc reloadTableViewData];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _sharedInstance = nil;
    [LBMovieView pauseAll];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _sharedInstance = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification removeObserver:self];
}

#pragma mark - check is userself

- (BOOL)isOwnAccount{

    if ([_currentAccount isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"account"]]) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - initial array & header view

- (void)initControllerArray
{
    LBPersonVideoViewController* lvc = [[LBPersonVideoViewController alloc] initWithAccountid:_currentAccount withStyle:personBottomStyleVideo];
    [lvc setDelegate:(id)self];
    [lvc.view setFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
    [lvc setHeaderView:_personalHearderView];
    [_controllerArray replaceObjectAtIndex:0 withObject:lvc];
    [self.view addSubview:lvc.view];
    //[self.view addSubview:_tmpView];
    //_tmpView = lvc.view;
    _segmentIndex = 0;
    
    _loadingView = [[LBPersonLoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    [_loadingView setBackgroundColor:RGB(214, 214, 214)];
    
    [self.view addSubview:_loadingView];
    //[self.view addSubview:_tmpView];
}

- (void)initTableViewHeader
{
    _personalHearderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, kPersonInfoDefaultHeight)];
    [_personalHearderView setBackgroundColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1.0]];
    [_personalHearderView setUserInteractionEnabled:YES];
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(127, 20, 65, 65)];
    [_avatarImageView setBackgroundColor:RGB(234, 234, 234)];
    [_avatarImageView.layer setCornerRadius:2.0f];
    [_avatarImageView.layer setMasksToBounds:YES];
    [_personalHearderView addSubview:_avatarImageView];
    
    _nameLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, _avatarImageView.origin.y + _avatarImageView.size.height +kPersonDistance - 5, 300, 20.)];
    [_nameLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    [_nameLabel setTextColor:kPersonViewTextColor];
    [_nameLabel setTextAlignment:RTTextAlignmentCenter];
    [_personalHearderView addSubview:_nameLabel];
    
    _signLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, _nameLabel.origin.y+ _nameLabel.frame.size.height+kPersonDistance-5, 300, 0)];
    [_signLabel setFont:[UIFont systemFontOfSize:14.0f]];
     [_signLabel setLineSpacing:5];
    [_signLabel setBackgroundColor:[UIColor clearColor]];
    [_signLabel setTextAlignment:RTTextAlignmentCenter];
    [_signLabel setTextColor:RGB(204, 204, 204)];
    [_signLabel setLineBreakMode:RTTextLineBreakModeWordWrapping];
    [_personalHearderView addSubview:_signLabel];
    
    _lovedLabel= [[RTLabel alloc] initWithFrame:CGRectMake(10, _signLabel.bottom  +kPersonDistance, 145, 12)];
    [_lovedLabel setFont:[UIFont systemFontOfSize:12]];
    [_lovedLabel setBackgroundColor:[UIColor clearColor]];
    [_lovedLabel setTextColor:RGB(204, 204, 204)];
    [_lovedLabel setLineBreakMode:RTTextLineBreakModeWordWrapping];
    [_lovedLabel setTextAlignment:RTTextAlignmentRight];
    [_personalHearderView addSubview:_lovedLabel];
    
    _playedLabel = [[RTLabel alloc] initWithFrame:CGRectMake(_lovedLabel.right , _signLabel.bottom  +kPersonDistance, 145, 12)];
    [_playedLabel setFont:[UIFont systemFontOfSize:12]];
    [_playedLabel setBackgroundColor:[UIColor clearColor]];
    [_playedLabel setTextColor:RGB(204, 204, 204)];
    [_playedLabel setLineBreakMode:RTTextLineBreakModeWordWrapping];
    [_playedLabel setTextAlignment:RTTextAlignmentLeft];
    [_personalHearderView addSubview:_playedLabel];
    
    _settingOrFocusOnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_settingOrFocusOnButton setFrame:CGRectMake(10, _playedLabel.bottom + kPersonDistance, 300, 37)];
    [_settingOrFocusOnButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_settingOrFocusOnButton addTarget:self action:@selector(settingOrFouseOnButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_settingOrFocusOnButton setBackgroundColor:[UIColor clearColor]];
    
    [_settingOrFocusOnButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    [_personalHearderView addSubview:_settingOrFocusOnButton];
    [_settingOrFocusOnButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    
    _segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(10, _settingOrFocusOnButton.origin.y+_settingOrFocusOnButton.frame.size.height+kPersonDistance+10, 300, 38)];
    
    UIButton *buttonVideoList = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonVideoList setFrame:CGRectMake(0,7, 75, 38)];
    [buttonVideoList setBackgroundImage:[UIImage imageNamed:@"segment_left"] forState:UIControlStateNormal];
    [buttonVideoList setBackgroundImage:[[UIImage imageNamed:@"segment_press_left"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 5, 15, 5)] forState:UIControlStateDisabled];
    [buttonVideoList setTitle:@"视频" forState:UIControlStateNormal];
    [buttonVideoList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonVideoList setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonVideoList.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [buttonVideoList.titleLabel setFont:[UIFont getNormalFont]];
    [buttonVideoList setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    UIButton *buttonLikedList = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonLikedList setFrame:CGRectMake(0,7, 75, 38)];
    [buttonLikedList setBackgroundImage:[UIImage imageNamed:@"segment_mid"] forState:UIControlStateNormal];
    [buttonLikedList setBackgroundImage:[[UIImage imageNamed:@"segment_press_mid"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 5, 15, 5)] forState:UIControlStateDisabled];
    [buttonLikedList setTitle:@"喜欢" forState:UIControlStateNormal];
    [buttonLikedList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonLikedList setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonLikedList.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [buttonLikedList.titleLabel setFont:[UIFont getNormalFont]];
    [buttonLikedList setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    UIButton *buttonFollowList = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonFollowList setFrame:CGRectMake(0, 7, 75, 38)];
    [buttonFollowList setBackgroundImage:[UIImage imageNamed:@"segment_mid"] forState:UIControlStateNormal];
    [buttonFollowList setBackgroundImage:[[UIImage imageNamed:@"segment_press_mid"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 5, 15, 5)] forState:UIControlStateDisabled];
    [buttonFollowList setTitle:@"关注" forState:UIControlStateNormal];
    [buttonFollowList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonFollowList setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonFollowList.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [buttonFollowList.titleLabel setFont:[UIFont getNormalFont]];
    [buttonFollowList setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    UIButton *buttonFansList = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonFansList setFrame:CGRectMake(0,7, 75, 38)];
    [buttonFansList setBackgroundImage:[UIImage imageNamed:@"segment_right"] forState:UIControlStateNormal];
    [buttonFansList setBackgroundImage:[[UIImage imageNamed:@"segment_press_right"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 5, 15, 5)] forState:UIControlStateDisabled];
    [buttonFansList setTitle:@"粉丝" forState:UIControlStateNormal];
    [buttonFansList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonFansList setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonFansList.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [buttonFansList.titleLabel setFont:[UIFont getNormalFont]];
    [buttonFansList setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [_segmentedControl setButtonsArray:@[buttonVideoList, buttonLikedList,buttonFollowList,buttonFansList]];
    [_segmentedControl setBackgroundColor:[UIColor clearColor]];
    [_segmentedControl setDelegate:self];
    [_personalHearderView addSubview:_segmentedControl];
    
    [_controllerArray replaceObjectAtIndex:4 withObject:_personalHearderView];
    
    UIImageView* shadowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, _segmentedControl.origin.y+_segmentedControl.frame.size.height+kPersonDistance+10-5, 320, 5)];
    [shadowImage setTag:201];
    [shadowImage setBackgroundColor:[UIColor clearColor]];;
    [shadowImage setImage:[UIImage imageNamed:@"shadow1"]];
    [shadowImage setAlpha:0.3f];
    [shadowImage setBackgroundColor:[UIColor clearColor]];
    
    [_personalHearderView addSubview:shadowImage];
    
    UIImageView* _arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(36, _segmentedControl.origin.y+_segmentedControl.frame.size.height+kPersonDistance+10-10, 23, 10)];
    [_arrowImage setImage:[UIImage imageNamed:@"triangle"]];
    [_arrowImage setBackgroundColor:[UIColor clearColor]];
    [_arrowImage setTag:200];
    [_personalHearderView addSubview:_arrowImage];
    
    [_personalHearderView setFrame:CGRectMake(0, 0, 320, _segmentedControl.origin.y+_segmentedControl.frame.size.height+kPersonDistance+10)];
    
    //[self.navigationController hidesBottomBarWhenPushed];
}

- (void)changeHeaderView
{
    RTLabel* label = [[RTLabel alloc] initWithFrame:CGRectMake(10, _nameLabel.origin.y+ _nameLabel.frame.size.height+kPersonDistance-5, 300, 0)];
    [label setFont:[UIFont systemFontOfSize:14.0f]];
    [label setTextAlignment:RTTextAlignmentCenter];
    [label setTextColor:RGB(204, 204, 204)];
    [label setLineBreakMode:RTTextLineBreakModeWordWrapping];
    [label setLineSpacing:5];
    [label setText:account.Sign];
    CGFloat height = [label optimumSize].height;

    [_avatarImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerUrl2], account.PhotoUrl]]];
    
    [_nameLabel setTop:_avatarImageView.bottom +5];
    NSLog(@"header :%@", [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerUrl2], account.PhotoUrl]]);
    if([account.DisplayName isKindOfClass:[NSString class]])
    {
        [_nameLabel setText:account.DisplayName];
    }
    

    if(account.Sign)
    {
        if([account.Sign isEqualToString:@""])
        {
            [_signLabel setFrame:CGRectMake(10, _nameLabel.bottom, 300, 0)];
        }
        else
        {
            [_signLabel setFrame:CGRectMake(10, _nameLabel.bottom + 5, 300, height)];
            
            [_signLabel setText:account.Sign];
        }

    }

    
    
    [_lovedLabel setFrame:CGRectMake(10, _signLabel.bottom + kPersonDistance, 145, 20)];
    [_lovedLabel setText:[NSString stringWithFormat:@"<font face=Futura size=12 color='#FFFFFF'>%@</font></a> 收到喜欢", account.TotalLoveCount]];
    
    [_playedLabel setFrame:CGRectMake(_lovedLabel.right+ 3, _signLabel.bottom+kPersonDistance, 145, 20)];
    [_playedLabel setText:[NSString stringWithFormat:@"• <font face=Futura size=12 color='#FFFFFF'>%@</font></a> 总播放",account.TotalPlayCount]];
    if (height == 0) {
        [_settingOrFocusOnButton setFrame:CGRectMake(10, _lovedLabel.bottom + 10, 300, 37)];
    }else {
        [_settingOrFocusOnButton setFrame:CGRectMake(10,  _lovedLabel.bottom + 10, 300, 37)];
    }
    
    [_segmentedControl setFrame:CGRectMake(10, _settingOrFocusOnButton.origin.y+_settingOrFocusOnButton.frame.size.height+kPersonDistance+4, 300, 38)];
    
    UIImageView* arrow = (UIImageView*)[_personalHearderView viewWithTag:200];
    [arrow setFrame:CGRectMake(_segmentIndex*75+36, _segmentedControl.origin.y+_segmentedControl.frame.size.height+kPersonDistance+10-10, 23, 10)];
    
    UIImageView* shadowImage = (UIImageView*)[_personalHearderView viewWithTag:201];
    [shadowImage setHidden:NO];
    [shadowImage setFrame:CGRectMake(0, _segmentedControl.origin.y+_segmentedControl.frame.size.height+kPersonDistance+10-5, 320, 5)];
    
    [_personalHearderView setFrame:CGRectMake(0, 0, 320, _segmentedControl.origin.y+_segmentedControl.frame.size.height+kPersonDistance+10)];
    
    NSArray* array = [_segmentedControl buttonsArray];
    for (int i = 0; i < [array count]; i++) {
        UIButton* button = [array objectAtIndex:i];
        [button.titleLabel setNumberOfLines:2];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        switch (i) {
            case 0:
                [button setTitle:[NSString stringWithFormat:@"%d\r视频", account.TopicCount] forState:UIControlStateNormal];
                break;
            case 1:
                [button setTitle:[NSString stringWithFormat:@"%d\r喜欢", account.LoveTopicCount] forState:UIControlStateNormal];
                break;
            case 2:
                [button setTitle:[NSString stringWithFormat:@"%d\r关注",account.AttendCount] forState:UIControlStateNormal];
                break;
            case 3:
                [button setTitle:[NSString stringWithFormat:@"%d\r粉丝",account.FansCount] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    
    if (!_isCurrentUser) {
        if (_isAttending) {
            [_settingOrFocusOnButton setBackgroundImage:[[UIImage imageNamed:@"fouseOn"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 145, 13, 145)] forState:UIControlStateNormal];
            [_settingOrFocusOnButton setTitle:@"已关注" forState:UIControlStateNormal];
            [_settingOrFocusOnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_settingOrFocusOnButton setTitleShadowColor:RGB(30, 30, 30) forState:UIControlStateNormal];
        }else {
            [_settingOrFocusOnButton setBackgroundImage:[[UIImage imageNamed:@"unFouseOn"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 145, 13, 145)] forState:UIControlStateNormal];
            [_settingOrFocusOnButton setTitle:@"关注" forState:UIControlStateNormal];
            [_settingOrFocusOnButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }else {
        [_settingOrFocusOnButton setBackgroundImage:[[UIImage imageNamed:@"setting"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 145, 13, 145)] forState:UIControlStateNormal];
        [_settingOrFocusOnButton setTitle:@"设置" forState:UIControlStateNormal];
        [_settingOrFocusOnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_settingOrFocusOnButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    NSArray* tableViewArray = [self.view subviews];
    for (id tableView in tableViewArray) {
        if ([tableView isKindOfClass:[UITableView class]]) {
            [tableView reloadData];
        }
    }
    
    UIView* view = _controllerArray[4];
    
    switch (_segmentIndex) {
        case 0: {
            LBPersonVideoViewController* lvc = [_controllerArray objectAtIndex:_segmentIndex];
            [lvc setHeaderView:view];
        }
            break;
        case 1: {
            LBPersonVideoViewController* lvc = [_controllerArray objectAtIndex:_segmentIndex];
            [lvc setHeaderView:view];
        }
            break;
        case 2: {
            LBAttendAndFansViewController* lvc = [_controllerArray objectAtIndex:_segmentIndex];
            [lvc setHeaderView:view];
        }
            break;
        case 3: {
            LBAttendAndFansViewController* lvc = [_controllerArray objectAtIndex:_segmentIndex];
            [lvc setHeaderView:view];
        }
            break;
        default:
            break;
    }
    if ([account.DisplayName isKindOfClass:[NSString class]])
        self.title = account.DisplayName;
}

- (id)getControllerArray
{
    return _controllerArray[_segmentIndex];
}

#pragma mark - disable load data

- (void)disableLoadVideoData
{
    if ([_controllerArray count] != 0) {
        LBPersonVideoViewController* lvc1 = [_controllerArray objectAtIndex:0];
        [lvc1 changePlayState:NO];
        
        id lvc2 = [_controllerArray objectAtIndex:1];
        if ([lvc2 isKindOfClass:[NSNull class]]) {
            
        }else {
            [lvc2 changePlayState:NO];
        }
    }
}

#pragma mark - segment delegate

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    _segmentIndex = index;
    NSLog(@"segmentedViewController");
    UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction;
    [UIView transitionWithView:_personalHearderView duration:0.3 options:option animations:^{
        UIImageView* imageView = (UIImageView*)[_personalHearderView viewWithTag:200];
        [imageView setFrame:CGRectMake(36+index*75, _segmentedControl.origin.y+_segmentedControl.frame.size.height+kPersonDistance+10-10, 20, 10)];
    } completion:Nil];
    
    id controller = [_controllerArray objectAtIndex:index];
    if ([controller isKindOfClass:[NSNull class]]) {
        switch (index) {
            case 0:{
                LBPersonVideoViewController* lvc = [[LBPersonVideoViewController alloc] initWithAccountid:_currentAccount withStyle:personBottomStyleVideo];
                [lvc setDelegate:(id)self];
                [lvc.view setFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
                [lvc setHeaderView:_personalHearderView];
                [lvc reloadTableViewData];
                [lvc changePlayState:YES];
                [_controllerArray replaceObjectAtIndex:index withObject:lvc];
                [self.view addSubview:lvc.view];
            }
                break;
            case 1: {
                LBPersonVideoViewController* lvc = [[LBPersonVideoViewController alloc] initWithAccountid:_currentAccount withStyle:personBottomStyleFavor];
                [lvc.view setFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
                [lvc setDelegate:(id)self];
                [lvc setHeaderView:_personalHearderView];
                [lvc reloadTableViewData];
                [lvc changePlayState:YES];
                
                LBPersonVideoViewController* lvc2 = [_controllerArray objectAtIndex:0];
                [lvc2 changePlayState:NO];
                
                [_controllerArray replaceObjectAtIndex:index withObject:lvc];
                [self.view addSubview:lvc.view];
            }
                break;
            case 2: {
                
                LBPersonVideoViewController* lvc1 = [_controllerArray objectAtIndex:0];
                [lvc1 changePlayState:NO];
                
                id lvc2 = [_controllerArray objectAtIndex:1];
                if ([lvc2 isKindOfClass:[NSNull class]]) {
                    
                }else {
                    [lvc2 changePlayState:NO];
                }
                
                LBAttendAndFansViewController* lvc = [[LBAttendAndFansViewController alloc] initWithAccountid:_currentAccount withStyle:personBottomStyleAttention];
                [lvc.view setFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
                [lvc setDelegate:(id)self];
                [lvc setHeaderView:_personalHearderView];
                [lvc reloadTableViewData];
                [_controllerArray replaceObjectAtIndex:index withObject:lvc];
                [self.view addSubview:lvc.view];
            }
                break;
            case 3: {
                LBPersonVideoViewController* lvc1 = [_controllerArray objectAtIndex:0];
                [lvc1 changePlayState:NO];
            
                id lvc2 = [_controllerArray objectAtIndex:1];
                if ([lvc2 isKindOfClass:[NSNull class]]) {
                    
                }else {
                    [lvc2 changePlayState:NO];
                }
                
                LBAttendAndFansViewController* lvc = [[LBAttendAndFansViewController alloc] initWithAccountid:_currentAccount withStyle:personBottomFuns];
                [lvc.view setFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
                [lvc setDelegate:(id)self];
                [lvc setHeaderView:_personalHearderView];
                [lvc reloadTableViewData];
                [_controllerArray replaceObjectAtIndex:index withObject:lvc];
                [self.view addSubview:lvc.view];
            }
                break;
            default:
                break;
        }
    } else {
        UIView* view = _controllerArray[4];
        switch (index) {
            case 0:{
                
                LBPersonVideoViewController* lvc = [_controllerArray objectAtIndex:index];
                [lvc changePlayState:YES];
                [lvc reloadTableViewData];
                [lvc viewWillAppear:YES];
                [lvc setHeaderView:view];
                [lvc.tableView setContentOffset:CGPointMake(0, 0)];
                [lvc.view setFrame:self.view.bounds];
                [self.view addSubview:lvc.view];
                
                id lvc2 = [_controllerArray objectAtIndex:1];
                if ([lvc2 isKindOfClass:[NSNull class]]) {
                    
                }else {
                    [lvc2 changePlayState:NO];
                }
            }
                break;
            case 1:{
                LBPersonVideoViewController* lvc1 = [_controllerArray objectAtIndex:0];
                [lvc1 changePlayState:YES];
                id lvc2 = [_controllerArray objectAtIndex:1];
                if ([lvc2 isKindOfClass:[NSNull class]]) {
                    
                }else {
                    [lvc2 changePlayState:NO];
                }
                
                LBPersonVideoViewController* lvc = [_controllerArray objectAtIndex:index];
                [lvc changePlayState:YES];
                [lvc reloadTableViewData];
                [lvc viewWillAppear:YES];
                [lvc setHeaderView:view];
                [lvc.view setFrame:self.view.bounds];
                [lvc.tableView setContentOffset:CGPointMake(0, 0)];
                [self.view addSubview:lvc.view];
            }
                break;
            case 2:{
                LBPersonVideoViewController* lvc1 = [_controllerArray objectAtIndex:0];
                [lvc1 changePlayState:NO];
                
                id lvc2 = [_controllerArray objectAtIndex:1];
                if ([lvc2 isKindOfClass:[NSNull class]]) {
                    
                }else {
                    [lvc2 changePlayState:NO];
                }
                
                LBAttendAndFansViewController* lvc = [_controllerArray objectAtIndex:index];
                
                [lvc setHeaderView:view];
                [lvc.tableView setContentOffset:CGPointMake(0, 0)];
                [lvc.view setFrame:self.view.bounds];
                [lvc reloadTableViewData];
                [self.view addSubview:lvc.view];
            }
                break;
            case 3:{
                
                LBPersonVideoViewController* lvc1 = [_controllerArray objectAtIndex:0];
                [lvc1 changePlayState:NO];
                id lvc2 = [_controllerArray objectAtIndex:1];
                if ([lvc2 isKindOfClass:[NSNull class]]) {
                    
                }else {
                    [lvc2 changePlayState:NO];
                }
                
                LBAttendAndFansViewController* lvc = [_controllerArray objectAtIndex:index];
                [lvc setHeaderView:view];
                [lvc.tableView setContentOffset:CGPointMake(0, 0)];
                [lvc.view setFrame:self.view.bounds];
                [lvc reloadTableViewData];
                [self.view addSubview:lvc.view];
            }
            default:
                break;
        }
    }
    [LBMovieView pauseAll];
}

#pragma mark - button click

- (void)settingOrFouseOnButtonClicked:(id)sender
{
    [Global clearPlayStatus];
    
    if (_isCurrentUser) {
        LBSettingViewController *setting = [[LBSettingViewController alloc]init];
        [setting setHidesBottomBarWhenPushed:YES];
        [selected_navigation_controller() pushViewController:setting animated:YES];
    }else {
        LBFileClient* client = [LBFileClient sharedInstance];
        if (_isAttending) {
            //取消关注
            [_settingOrFocusOnButton setBackgroundImage:[[UIImage imageNamed:@"unFouseOn"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 145, 13, 145)] forState:UIControlStateNormal];
            [_settingOrFocusOnButton setTitle:@"关注" forState:UIControlStateNormal];
            [_settingOrFocusOnButton setTitleColor:RGB(30, 30, 30) forState:UIControlStateNormal];
            [_settingOrFocusOnButton.titleLabel setShadowColor:[UIColor whiteColor]];
            [client unFollow:_currentAccount cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(unFollowDidFinished:) selectorError:@selector(unFollowDidFailed:)];
        }else {
            [_settingOrFocusOnButton setBackgroundImage:[[UIImage imageNamed:@"fouseOn"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 145, 13, 145)] forState:UIControlStateNormal];
            [_settingOrFocusOnButton setTitle:@"已关注" forState:UIControlStateNormal];
            [_settingOrFocusOnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_settingOrFocusOnButton.titleLabel setShadowColor:RGB(94, 94, 94)];
            [client follow:_currentAccount cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(followDidFinished:) selectorError:@selector(followDidFailed:)];
        }
        _isAttending = !_isAttending;
    }
}

- (void)backButtonClicked:(id)sender
{
    [Global clearPlayStatus];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - send personal info request & request delegate

- (void)sendCurrentAccountInfo:(BOOL)isReload
{
    //[_loadingView setHidden:NO];
    LBFileClient* client = [LBFileClient sharedInstance];
    if (_currentAccount) {
        [client getAccountInfo:_currentAccount cachePolicy:NSURLRequestReloadIgnoringLocalCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
    }else {
        
        [client getAccountInfo:[[AccountHelper getAccount] AccountID] cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
    }
}

- (void)getCacheData
{
    LBFileClient* client = [LBFileClient sharedInstance];
    if (_currentAccount) {
        [client getAccountInfo:_currentAccount cachePolicy:NSURLRequestReturnCacheDataElseLoad delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(reloadError:)];
    }else {
        [client getAccountInfo:[[AccountHelper getAccount] AccountID] cachePolicy:NSURLRequestReturnCacheDataElseLoad delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(reloadError:)];
    }
}

- (void)requestDidFinishLoad:(id)sender
{
    NSError* error = nil;
    if (sender == nil) {
        return;
    }
    
    NSDictionary* jsonString = [NSJSONSerialization JSONObjectWithData:sender options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return;
    }
    
//    BOOL isNoError;
//    isNoError = [account parse:jsonString];
//    
    NSLog(@"getAccountInfo---------%@", jsonString);
    
    if ([[jsonString objectForKey:@"error"] isEqualToString:@"REDUPLICATION"]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"重复登陆,请重新登陆"];
        LBAppDelegate *LBdelegate = (id)[UIApplication sharedApplication].delegate;
        if ([LBdelegate respondsToSelector:@selector(changedRootVCToLogin)]) {
            [LBdelegate performSelector:@selector(changedRootVCToLogin)];
//                AccountDTO *account = [AccountHelper getAccount];
//                [self setLogout:account];
        }
    }
    
    [account parse:jsonString];
    
    AccountDTO *dto = [[AccountDTO alloc] init];
    [dto parse:jsonString];
    [AccountHelper setAccount:dto];
    [AccountHelper save];
    
    if (account.Attended == 0) {
        _isAttending = NO;
    }else {
        _isAttending = YES;
    }
    [_loadingView setHidden:YES];
    [_loadingView setBackgroundColor:[UIColor clearColor]];
    
    [self changeHeaderView];
}

- (void)requestError:(id)sender
{
    if (account.AccountID) {
        //刷新失败
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"数据加载失败";
        [hud hide:YES afterDelay:1];
        [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
    }else {
        //数据获取失败
        [self getCacheData];
    }
}

- (void)reloadError:(id)sender
{
    [_loadingView noData];
}

//取消关注
- (void)unFollowDidFinished:(id)sender
{
//    NSString *json_string = [[NSString alloc] initWithData:sender encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"%@", [json_string JSONValue]);
}

- (void)unFollowDidFailed:(id)sender
{
    
}

//关注
- (void)followDidFinished:(id)sender
{
    //NSString *json_string = [[NSString alloc] initWithData:sender encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", [json_string JSONValue]);
}

- (void)followDidFailed:(id)sender
{
    
}

#pragma mark - controller delegate

- (void)userInfoShouldReload
{
    //NSLog(@"userInfoShouldReload");
    [self sendCurrentAccountInfo:YES];
}

#pragma mark - notification

- (void)personInfoReload:(NSNotification*)note
{
    //NSLog(@"personInfoReload");
    [self sendCurrentAccountInfo:YES];
}

@end
