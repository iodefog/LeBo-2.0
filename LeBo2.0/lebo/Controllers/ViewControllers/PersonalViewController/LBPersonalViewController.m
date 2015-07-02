//
//  LBPersonalViewController.m
//  lebo
//
//  Created by yong wang on 13-3-24.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBPersonalViewController.h"
#import "LBSettingViewController.h"
#import "AKSegmentedControl.h"

@interface LBPersonalViewController ()

@end

@implementation LBPersonalViewController
@synthesize segmentedControl = _segmentedControl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPersonID:(NSString*)accountID
{
    self = [super init];
    if (self) {
        _accountLeboID = [[NSString alloc] init];
        _accountLeboID = accountID;
        //NSLog(@"----account:%@------%@", accountID,_accountLeboID);
        [self setHidesBottomBarWhenPushed:YES];
    }
    return self;
}

- (id)initWithBackbuttonAndPersonID:(NSString *)accountID
{
    self = [super init];
    if (self) {
        _accountLeboID = [[NSString alloc] init];
        _accountLeboID = accountID;
        //NSLog(@"----account:%@------%@", accountID,_accountLeboID);
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithTitle:@"返回" image:@"general_back.png" target:self action:@selector(backButtonClicked:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.segmentIndex = 0;
   
    if(_controllerArray == nil)
    {
        [self createController];
    }
    
    [self customTitleView];
    [self createRightItem];
}

- (void)createController
{
    _controllerArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    LBPersonDetailViewController* lvc = [[LBPersonDetailViewController alloc] initWithAccountID:[[AccountHelper getAccount] AccountID]];
    _controllerArray[0] = lvc;
    [lvc.view setFrame:self.view.bounds];
    
    LBMessageViewController* messageController = [[LBMessageViewController alloc] init];
    _controllerArray[1] = messageController;
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
    [self.view addSubview:_backgroundView];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    LBPersonDetailViewController* lvc = _controllerArray[0];
    [lvc.view setFrame:self.view.bounds];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.segmentedControl.selectedIndex == 1 && _controllerArray && [_controllerArray count] == 2)
    {
        [_controllerArray[1] viewWillAppear:YES];
    }
    
    if (self.segmentIndex == 0) {
        LBPersonDetailViewController* lvc = _controllerArray[0];
        [lvc viewWillAppear:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [LBMovieView pauseAll];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createRightItem
{
    UIButton* rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItem setFrame:CGRectMake(0, 0, 50, 32)];
    [rightItem setBackgroundImage:[UIImage imageNamed:@"button_back"] forState:UIControlStateNormal];//button_back
    [rightItem setImage:[UIImage imageNamed:@"search_friend"] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightItem setImageEdgeInsets:UIEdgeInsetsMake(2, 10, 2, 10)];
    UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

#pragma mark - custom title view

- (id)getControllerArray
{
    return _controllerArray[0];
}

- (void)customTitleView
{
    if(_segmentedControl != nil)
        return;
    self.segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(0, 4, 164, 30)];
    
    UIButton *buttonMine = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonMine setFrame:CGRectMake(0,7, 82, 30)];
    [buttonMine setBackgroundImage:[UIImage imageNamed:@"seg_navigationbar_left"] forState:UIControlStateNormal];
    [buttonMine setBackgroundImage:[UIImage imageNamed:@"seg_navigationbar_left_tape.png"] forState:UIControlStateDisabled];
    [buttonMine setTitle:@"我的" forState:UIControlStateNormal];
    
    [buttonMine setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonMine setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonMine.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [buttonMine.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [buttonMine setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    UIButton *buttonMsg = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonMsg setFrame:CGRectMake(0,7, 82, 30)];
    [buttonMsg setBackgroundImage:[UIImage imageNamed:@"seg_navigationbar_right"] forState:UIControlStateNormal];
    [buttonMsg setBackgroundImage:[UIImage imageNamed:@"seg_navigationbar_right_tape.png"] forState:UIControlStateDisabled];
    [buttonMsg setTitle:@"消息" forState:UIControlStateNormal];
    [buttonMsg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonMsg setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonMsg.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [buttonMsg.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [buttonMsg setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [_segmentedControl setButtonsArray:@[buttonMine,  buttonMsg]];
    [_segmentedControl setBackgroundColor:[UIColor clearColor]];
    [_segmentedControl setDelegate:self];
    [self.navigationItem setTitleView:_segmentedControl];
    
    [self segmentedViewController:_segmentedControl touchedAtIndex:0];
}

#pragma mark - segment & button click

- (void)setIndex:(NSInteger)num
{
    self.segmentIndex = num;
}

- (void)segmentedChangeViewController
{
    if(_controllerArray == nil)
    {
        [self createController];
        [self customTitleView];
    }
    
    [_segmentedControl setSelectedIndex:1];
    [self segmentedViewController:_segmentedControl touchedAtIndex:self.segmentIndex];
    [LBMovieView pauseAll];
    [[LBFileClient sharedInstance] getAllNotices:0 endPos:10 cachePolicy:NSURLRequestReloadIgnoringCacheData  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
}

- (void)requestDidFinishLoad:(NSData*)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(json_string.length > 0)
    {
        id responseObject = [[json_string JSONValue] objectForKey:@"error"];
        //NSLog(@"%@", [json_string JSONValue]);
        if(responseObject)
        {
            if([responseObject isKindOfClass:[NSString class]] && [responseObject isEqualToString:@"OK"])
            {
                //NSLog(@"OK");
            }
        }
    }
    else
    {
        [self requestError:nil];
    }
}

- (void)requestError:(NSData*)data
{    
    //NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", [json_string JSONValue]);
}

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    UIViewController* controller = _controllerArray[index];
    NSArray* array = [_backgroundView subviews];
    self.segmentIndex = index;
    for (UIView* view in array) {
        [view performSelector:@selector(removeFromSuperview)];
    }
    
    [Global clearPlayStatus];
    
    if (index == 1) {
        LBPersonDetailViewController* lvc = _controllerArray[0];
        [lvc disableLoadVideoData];
    }
    [LBMovieView pauseAll];
    [controller.view setFrame:self.view.bounds];
    [_backgroundView addSubview:controller.view];
}

- (void)rightBtnClicked:(UIButton *)sender
{    
    LBPersonDetailViewController* lvc = _controllerArray[0];
    [lvc disableLoadVideoData];
    LBSearchFriendsViewController* sinaAndSearch = [[LBSearchFriendsViewController alloc] init];
    sinaAndSearch.hidesBottomBarWhenPushed = YES;
    [selected_navigation_controller() pushViewController:sinaAndSearch animated:YES];
}

- (void)backButtonClicked:(id)sender
{
    [Global clearPlayStatus];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
