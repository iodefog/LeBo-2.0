//
//  LBChannelViewController.h
//  lebo
//
//  Created by yong wang on 13-3-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTableApiViewController.h"
#import "LBSearchViewController.h"
#import "CustomSearchBar.h"

@interface LBChannelViewController : LBTableApiViewController< UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, retain) CustomSearchBar *searchBar;
@property (nonatomic, retain) UIView *disableViewOverlay;
@property (nonatomic, retain) LBSearchViewController *searchViewController;
@property (nonatomic, retain) UISearchDisplayController *searchbarDisplay;

+ (LBChannelViewController *)sharedInstance;
@end
