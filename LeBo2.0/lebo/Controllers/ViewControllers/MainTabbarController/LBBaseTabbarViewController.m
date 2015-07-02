//
//  LBBaseTabbarViewController
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBBaseTabbarViewController.h"

@implementation LBBaseTabbarViewController

- (id)viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image finishedSelectedImage:(UIImage*)finishedSelectedImage viewClass:(NSString*)viewClass
{   
    
    Class viewControllerClass = NSClassFromString(viewClass);
    UIViewController* viewController = [[viewControllerClass alloc] init];
    viewController.title = title;
    [viewController.tabBarItem setFinishedSelectedImage:finishedSelectedImage withFinishedUnselectedImage:image];
    [viewController.tabBarItem setTitle:nil];
    [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    return navigationController;
}

- (UIViewController*)viewControllerWithSubClass:(NSString*)viewClass
{   
    Class viewControllerClass = NSClassFromString(viewClass);
    UIViewController* viewController = [[viewControllerClass alloc] init];
    return viewController;
}

- (void)addRightButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIView *rightBarView = [[UIView alloc] initWithFrame:CGRectMake(self.tabBar.width - self.tabBar.width / [self.viewControllers count] , 0, self.tabBar.width / [self.viewControllers count], self.tabBar.height)];
    
    [rightBarView setBackgroundColor:[UIColor clearColor]];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(8.0, 6.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(capBtnTape:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBarView addSubview:button];
     //button.center = rightBarView.center;
    [self.tabBar addSubview:rightBarView];
    
}

- (void)capBtnTape:(id)sender
{
    id selectPlay = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectPlay"];
    
    if(selectPlay)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectPlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    UIViewController* viewController = [[NSClassFromString(@"LBCameraController") alloc] init];

    [selected_navigation_controller() presentModalViewController:viewController animated:YES];

    NSLog(@"presentViewController");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
