//
//  LBFindViewController.m
//  lebo
//
//  Created by yong wang on 13-3-24.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBFindViewController.h"
#import "LBTopListViewController.h"
#import "LBChannelViewController.h"
#import "LBRedListViewController.h"
#import "AKSegmentedControl.h"
#import "LBMovieView.h"
@implementation LBFindViewController
@synthesize tempViewController = _tempViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
 {
     
     UITableViewController *viewController = [self.childViewControllers objectAtIndex:index];

    if(viewController == _tempViewController)
        return;
    //[_tempViewController.view removeFromSuperview];
    [self transitionFromViewController:_tempViewController toViewController:viewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
    }  completion:^(BOOL finished) {
        
    }];

    [viewController.tableView setFrame:self.view.frame];
    [_tempViewController.tableView removeFromSuperview];
    _tempViewController = viewController;
    [self.view addSubview:viewController.tableView];
}

- (id)getControllerArray
{
    return [self.childViewControllers objectAtIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_tempViewController)
    {
        [_tempViewController viewWillAppear:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)createUI
{

    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(0, 4, 240, 30)];

    UIButton *buttonTop = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonTop setFrame:CGRectMake(0,7, 80, 28)];
    [buttonTop setBackgroundImage:[UIImage imageNamed:@"seg_navigationbar_left.png"] forState:UIControlStateNormal];
    [buttonTop setBackgroundImage:[UIImage imageNamed:@"seg_navigationbar_left_tape.png"] forState:UIControlStateDisabled];
    [buttonTop setTitle:@"热门" forState:UIControlStateNormal];
    [buttonTop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonTop setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonTop.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [buttonTop.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [buttonTop setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];

    
    UIButton *buttonChannel = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonChannel setFrame:CGRectMake(0,7, 80, 28)];
    [buttonChannel setBackgroundImage:[UIImage imageNamed:@"seg_navigationbar_mid.png"] forState:UIControlStateNormal];
    [buttonChannel setBackgroundImage:[UIImage imageNamed:@"seg_navigationbar_mid_tape.png"] forState:UIControlStateDisabled];
    [buttonChannel setTitle:@"频道" forState:UIControlStateNormal];
    [buttonChannel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonChannel setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonChannel.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [buttonChannel.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [buttonChannel setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    UIButton *buttonHot = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonHot setFrame:CGRectMake(0,7, 80, 28)];
    [buttonHot setBackgroundImage:[UIImage imageNamed:@"seg_navigationbar_right.png"] forState:UIControlStateNormal];
    [buttonHot setBackgroundImage:[UIImage imageNamed:@"seg_navigationbar_right_tape.png"] forState:UIControlStateDisabled];
    [buttonHot setTitle:@"红人榜" forState:UIControlStateNormal];
    [buttonHot setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonHot setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonHot.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [buttonHot.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [buttonHot setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];

    
    [segmentedControl setButtonsArray:@[buttonTop, buttonChannel, buttonHot]];
    [segmentedControl setBackgroundColor:[UIColor clearColor]];
    [segmentedControl setDelegate:self];
    [self.navigationItem setTitleView:segmentedControl];
    
    LBTopListViewController *topListViewController = [[LBTopListViewController alloc] init];
    [topListViewController setRefresh:YES];
    
    LBChannelViewController *channelViewController = [LBChannelViewController sharedInstance];
    
    LBRedListViewController *redListViewController = [LBRedListViewController sharedInstance];
    
    [self addChildViewController:topListViewController];
    [self addChildViewController:channelViewController];
    [self addChildViewController:redListViewController];
   
    [self transitionFromViewController:topListViewController toViewController:topListViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
    }  completion:^(BOOL finished) {
        
    }];
    
    [topListViewController.tableView setFrame:CGRectMake(0, 0, self.view.width, self.view.height + 2)];
    _tempViewController = (UITableViewController*)topListViewController;
    [self.view addSubview:topListViewController.tableView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end