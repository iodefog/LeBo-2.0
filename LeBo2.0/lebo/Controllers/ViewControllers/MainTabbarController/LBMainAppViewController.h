//
//  LBBaseTabbarViewController.h
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBBaseTabbarViewController.h"

@interface LBMainAppViewController : LBBaseTabbarViewController<UITabBarControllerDelegate>

@property (nonatomic, retain)UIImageView *imageViewMsgTip;
@property (nonatomic, retain)UIViewController *tempViewController;
- (void)postMessage;
- (void)changeVCToMessageVC;
@end
