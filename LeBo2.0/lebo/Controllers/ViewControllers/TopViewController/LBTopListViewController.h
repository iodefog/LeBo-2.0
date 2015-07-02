//
//  LBTopListViewController.h
//  lebo
//
//  Created by yong wang on 13-3-26.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTableApiViewController.h"


@interface LBTopListViewController : LBTableApiViewController

+ (LBTopListViewController *)sharedInstance;
- (void)setRefresh:(BOOL)bRefresh;
@end
