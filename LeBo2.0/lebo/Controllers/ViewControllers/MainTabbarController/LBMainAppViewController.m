//
//  LBBaseTabbarViewController.m
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBMainAppViewController.h"
#import "LBFileClient.h"
#import "LBMovieView.h"
#import "LBPersonalViewController.h"
@implementation LBMainAppViewController
@synthesize imageViewMsgTip = _imageViewMsgTip;
@synthesize tempViewController = _tempViewController;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setDelegate:self];

    self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTabTitle:@"首页" image:[UIImage imageNamed:@"tabbar_home.png"] finishedSelectedImage:[UIImage imageNamed:@"tabbar_home_tape.png"] viewClass:@"LBHomeViewController"],
                            [self viewControllerWithTabTitle:@"发现" image:[UIImage imageNamed:@"tabbar_find.png"]  finishedSelectedImage:[UIImage imageNamed:@"tabbar_find_tape.png"] viewClass:@"LBFindViewController"],
                            [self viewControllerWithTabTitle:@"" image:[UIImage imageNamed:@"tabbar_persion.png"] finishedSelectedImage:[UIImage imageNamed:@"tabbar_persion_tape.png"]  viewClass:@"LBPersonalViewController"],
                            [self viewControllerWithTabTitle:@"" image:[UIImage imageNamed:@"tabbar_cam.png"] finishedSelectedImage:[UIImage imageNamed:@"tabbar_cam.png"]  viewClass:@"UIViewController"],
                            nil];
    [self addRightButtonWithImage:[UIImage imageNamed:@"tabbar_cam.png"] highlightImage:[UIImage imageNamed:@"tabbar_cam_tape.png"]];
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    
    [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"emptyIndicator.png"]];
    
    
    CGFloat fHeight = [[UIScreen mainScreen] bounds].size.height;
    [[[self.view subviews] objectAtIndex:0] setHeight: fHeight  - 44];
    [self.tabBar setTop:fHeight  - 46.];
    [self.tabBar setHeight:46.];
    
    [self setSelectedViewController: self.viewControllers[0]];
    
    id autoPlay = [[NSUserDefaults standardUserDefaults] objectForKey:@"3GAutoPlay"] ;
    if(autoPlay == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"3GAutoPlay"];
    }
    
    self.imageViewMsgTip = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_tipe"]];
    [_imageViewMsgTip setUserInteractionEnabled:YES];
    [_imageViewMsgTip setFrame:CGRectMake(210, 10, 10, 10)];
    
    [self clearPlayUrl];
    
}

- (void)clearPlayUrl
{
    [Global clearPlayStatus];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self clearPlayUrl];
}

- (void)postMessage
{
    if([self.viewControllers count] > 2)
    {
        [_imageViewMsgTip removeFromSuperview];
        [self.tabBar addSubview:_imageViewMsgTip];
        _imageViewMsgTip.tag = 1;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self clearPlayUrl];
    
    if(viewController == _tempViewController)
    {
        return;
    }
    
    _tempViewController = viewController;
    if(tabBarController.selectedIndex == 2)
    {
        if (_imageViewMsgTip.tag ==1) {
            [self changeVCToMessageVC];
        }
        [_imageViewMsgTip removeFromSuperview];
        _imageViewMsgTip.tag = 2;
        [[tabBarController.viewControllers objectAtIndex:2] viewWillAppear:YES];
    }
    
    [viewController viewDidAppear:YES];
}

- (void)changeVCToMessageVC{
    if (self.viewControllers.count >= 2)
    {
        [self setSelectedIndex:2];//
        id personalViewController = ((LBPersonalViewController*)((UINavigationController*)[self.viewControllers objectAtIndex:2]).visibleViewController);
        
        [[LBFileClient sharedInstance] setAllReaded:nil cachePolicy:NSURLRequestReloadIgnoringCacheData  delegate:self selector:@selector(allReadedDidFinishLoad:) selectorError:@selector(requestError:)];
        
        if([personalViewController respondsToSelector:@selector(segmentedChangeViewController)] == YES) {
            [personalViewController setIndex:1];
            [personalViewController segmentedChangeViewController];
            [_imageViewMsgTip removeFromSuperview];
        }
    }
}

- (void)bindDeviceToken:(AccountDTO *)account
{
    LBFileClient *client = [LBFileClient sharedInstance];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    BOOL bindDevice = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bindDevice"] boolValue];
    if (bindDevice == NO && deviceToken.length > 20) {
#ifdef __OPTIMIZE__
        [client registerDeviceInfo:[NSArray arrayWithObjects:[account Token], [account AccountID], @"Lebo_iPhone", deviceToken, nil] cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
#else
        [client registerDeviceInfo:[NSArray arrayWithObjects:[account Token], [account AccountID], @"Lebo_iPhone_Dev", deviceToken, nil] cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
#endif
    }
}

- (void)requestError:(NSError *)error{
    NSLog(@"%@", error);
}

- (void)requestDidFinishLoad:(id)result{
    NSString *json_string = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"%@", [json_string JSONValue]);
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey :@"bindDevice"];
}

- (void)allReadedDidFinishLoad:(id)result{
    NSString *json_string = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"allReadedDidFinishLoad---> %@", [json_string JSONValue]);
}

@end
