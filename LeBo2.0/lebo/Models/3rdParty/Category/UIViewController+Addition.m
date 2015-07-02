//
//  UIViewController+Addition.m
//  lebo
//
//  Created by 乐播 on 13-3-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "UIViewController+Addition.h"



@implementation UIViewController(Addition)

+ (UINavigationController *)getTopNavigation
{
    return (UINavigationController *)((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController;
}
@end
