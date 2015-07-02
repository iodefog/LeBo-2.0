//
//  LBRedListViewController.h
//  lebo
//
//  Created by King on 13-4-17.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBTableApiViewController.h"
#import "LBTableCellDelegate.h"
#import "LBSearchViewController.h"
#import "CustomSearchBar.h"

@interface LBRedListViewController : LBTableApiViewController<UISearchBarDelegate>

@property (nonatomic, retain) CustomSearchBar *searchBar;
@property (nonatomic, retain) UIView *disableViewOverlay;
@property (nonatomic, retain) LBSearchViewController *searchViewController;
+ (LBRedListViewController *)sharedInstance;
@end
