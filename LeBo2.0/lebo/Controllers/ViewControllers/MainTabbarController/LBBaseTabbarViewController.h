//
//  LBBaseTabbarViewController.h
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//


@interface LBBaseTabbarViewController : UITabBarController

- (id)viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image finishedSelectedImage:(UIImage*)finishedSelectedImage viewClass:(NSString*)viewClass;
- (void)addRightButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;
- (UIViewController*)viewControllerWithSubClass:(NSString*)viewClass;
@end
