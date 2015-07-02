//
//  LBAppearance.m
//  lebo
//
//  Created by 乐播 on 13-3-25.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBAppearance.h"

@implementation LBAppearance

+ (void)setLBAppearance
{
    UIImage *bgimage = [UIImage imageNamed:@"naviBar_background.png"];
    [[UINavigationBar appearanceWhenContainedIn:[UINavigationController class], nil] setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
}

@end
