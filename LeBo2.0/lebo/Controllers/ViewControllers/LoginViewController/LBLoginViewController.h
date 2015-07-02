//
//  LBLoginViewController.h
//  lebo
//
//  Created by yong wang on 13-3-26.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBLoginViewController : UIViewController<MBProgressHUDDelegate, UIScrollViewDelegate>
{
    NSString *_sinaID;
    NSString *_sinaToken;
    MBProgressHUD *progressHUD;
    UIPageControl           *pageControl;
    UIScrollView            *beginScroll;
}

- (void)loginBySinaToken;

@end
