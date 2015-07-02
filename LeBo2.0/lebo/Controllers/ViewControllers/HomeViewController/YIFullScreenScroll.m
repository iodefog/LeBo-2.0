//
//  YIFullScreenScroll.m
//  YIFullScreenScroll
//
//  Created by Yasuhiro Inami on 12/06/03.
//  Copyright (c) 2012 Yasuhiro Inami. All rights reserved.
//

#import "YIFullScreenScroll.h"

#define IS_PORTRAIT         UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)
#define STATUS_BAR_HEIGHT   (IS_PORTRAIT ? [UIApplication sharedApplication].statusBarFrame.size.height : [UIApplication sharedApplication].statusBarFrame.size.width)

#define MIN_SCROLL_DISTANCE_FOR_FULLSCREEN  44

@implementation YIFullScreenScroll

@synthesize viewController = _viewController;
@synthesize enabled = _enabled;
@synthesize shouldShowUIBarsOnScrollUp = _shouldShowUIBarsOnScrollUp;

- (id)initWithViewController:(UIViewController*)viewController
{
    self = [super init];
    if (self) {
        self.enabled = YES;
        self.shouldShowUIBarsOnScrollUp = YES;
        _viewController = viewController;
    }
    return self;
}

- (void)_layoutWithScrollView:(UIScrollView*)scrollView deltaY:(CGFloat)deltaY disApper:(BOOL)disApper
{
    // navbar
    UINavigationBar* navBar = _viewController.navigationController.navigationBar;
    
//    NSLog(@"scrollView.contentOffset.y = %f",scrollView.contentOffset.y);
    if(scrollView.contentOffset.y < 10.0)
       [_viewController.navigationController setNavigationBarHidden:NO animated:YES];
    BOOL isNavBarExisting = navBar && navBar.superview;// && !navBar.hidden ;
    if ((isNavBarExisting && scrollView.contentOffset.y < 80) || (disApper && isNavBarExisting)) {
        navBar.top = MIN(MAX(navBar.top-deltaY, STATUS_BAR_HEIGHT-navBar.height), STATUS_BAR_HEIGHT);
        if(disApper)
        {
            UIEdgeInsets insets = scrollView.scrollIndicatorInsets;
            if (isNavBarExisting) {
                insets.top = navBar.bottom-STATUS_BAR_HEIGHT - 38;
            }
            insets.bottom = 0;
     
            scrollView.scrollIndicatorInsets = insets;
            return;
        }
        
        UITabBar* tabBar = _viewController.tabBarController.tabBar;
        CGFloat viewTop = navBar.top - navBar.height + 24;
 
        _viewController.view.top =  viewTop < -44?-44:viewTop;
        if(viewTop == -44)
        {
            _viewController.navigationController.navigationBarHidden = YES;
        }
        _viewController.view.height = screenSize().height - tabBar.height - _viewController.view.top - 46;
    }
    
//    // toolbar
//    UIToolbar* toolbar = _viewController.navigationController.toolbar;
//    BOOL isToolbarExisting = toolbar && toolbar.superview && !toolbar.hidden;
//    CGFloat toolbarSuperviewHeight = 0;
//    if (isToolbarExisting) {
//        // NOTE: if navC.view.superview == window, navC.view won't change its frame and only rotate-transform
//        if ([toolbar.superview.superview isKindOfClass:[UIWindow class]]) {
//            toolbarSuperviewHeight = IS_PORTRAIT ? toolbar.superview.height : toolbar.superview.width;
//        }
//        else {
//            toolbarSuperviewHeight = toolbar.superview.height;
//        }
//        toolbar.top = MIN(MAX(toolbar.top+deltaY, toolbarSuperviewHeight-toolbar.height), toolbarSuperviewHeight);
//    }
    
    // tabBar
//    UITabBar* tabBar = _viewController.tabBarController.tabBar;
//    BOOL isTabBarExisting = tabBar && tabBar.superview && !tabBar.hidden && (tabBar.left == 0);
//    CGFloat tabBarSuperviewHeight = 0;
//    if (isTabBarExisting) {
//        if ([tabBar.superview.superview isKindOfClass:[UIWindow class]]) {
//            tabBarSuperviewHeight = IS_PORTRAIT ? tabBar.superview.height : tabBar.superview.width;
//        }
//        else {
//            tabBarSuperviewHeight = tabBar.superview.height;
//        }
//        tabBar.top = MIN(MAX(tabBar.top+deltaY, tabBarSuperviewHeight-tabBar.height), tabBarSuperviewHeight);
//    }
    
    // scrollIndicatorInsets
    UIEdgeInsets insets = scrollView.scrollIndicatorInsets;
    if (isNavBarExisting) {
        insets.top = navBar.bottom-STATUS_BAR_HEIGHT - 38;
    }
    insets.bottom = 0;
//    if (isToolbarExisting) {
//        insets.bottom += toolbarSuperviewHeight-toolbar.top;
//    }
//    if (isTabBarExisting) {
//        insets.bottom += tabBarSuperviewHeight-tabBar.top;
//    }
    scrollView.scrollIndicatorInsets = insets;
}

#pragma mark -

- (void)layoutTabBarController
{
    if (_viewController.tabBarController) {
        UIView* tabBarTransitionView = [_viewController.tabBarController.view.subviews objectAtIndex:0];
        tabBarTransitionView.frame = _viewController.tabBarController.view.bounds;
    }
}

- (void)showUIBarsWithScrollView:(UIScrollView*)scrollView animated:(BOOL)animated
{
    [UIView animateWithDuration:(animated ? 0.1 : 0) animations:^{
        [self _layoutWithScrollView:scrollView deltaY:-50 disApper:NO];
    }];
}


#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _prevContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging || _isScrollingTop) {
        CGFloat deltaY = scrollView.contentOffset.y-_prevContentOffsetY;
        _prevContentOffsetY = MAX(scrollView.contentOffset.y, -scrollView.contentInset.top);
        
        if (!self.shouldShowUIBarsOnScrollUp && deltaY < 0 && scrollView.contentOffset.y > 0 && !_isScrollingTop) {
            deltaY = abs(deltaY);
        }
        
        [self _layoutWithScrollView:scrollView deltaY:deltaY disApper:NO];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    _prevContentOffsetY = scrollView.contentOffset.y;
    _isScrollingTop = YES;
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    _isScrollingTop = NO;
}

@end
