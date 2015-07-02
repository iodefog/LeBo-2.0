//
//  LBFindViewController.h
//  lebo
//
//  Created by yong wang on 13-3-24.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBModelApiViewController.h"
#import "AKSegmentedControl.h"
@interface LBFindViewController : LBModelApiViewController<AKSegmentedControlDelegate>

@property(nonatomic, retain) UITableViewController *tempViewController;
- (id)getControllerArray;
@end
