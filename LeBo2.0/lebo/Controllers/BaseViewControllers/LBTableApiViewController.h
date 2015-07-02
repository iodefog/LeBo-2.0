//
//  LBTableApiViewController.h
//  lebo
//
//  Created by yong wang on 13-3-21.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBModelApiViewController.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface LBTableApiViewController : LBModelApiViewController <UITableViewDelegate, UITableViewDataSource,EGORefreshTableHeaderDelegate, EGORefreshTableFooterViewDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _headerLoading;
    BOOL _footerLoading;
    
    BOOL enableHeader;
    BOOL enableFooter;
    BOOL enableFooterTemp;
    int _lastPosition;
    BOOL _reloading;
    UITableView *_tableView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIImageView *errorImageView;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) UIView *errorView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) BOOL enableHeader;
@property (nonatomic, assign) BOOL enableFooter;
@property (nonatomic, assign) BOOL enableFooterTemp;
@property (nonatomic, assign) BOOL isTracking;
- (void)createUI;
- (void)createErrorView;
- (void)updateFooter;

- (void)showDataLoading:(CGFloat)offsety;
- (void)activeRefresh;

- (Class)cellClass;
- (void)setSeparatorClear;

- (void)reloadHeaderTableViewDataSource;
- (void)reloadFooterTableViewDataSource;
- (void)finishLoadHeaderTableViewDataSource;
- (void)finishLoadFooterTableViewDataSource;

- (void)didFinishLoad:(id)array;
- (void)didFailWithError:(int)type;

@end

@protocol RefreshTableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@optional

- (void)loadHeader;
- (void)loadFooter;
@end

