//
//  LBSearchFriendsViewController.h
//  lebo
//
//  Created by lebo on 13-3-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBFriendView.h"
#import "SinaHelper.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "LBFileClient.h"
#import "AddSinaFriendsDTO.h"
#import "LBMovieView.h"
#import "LBPersonLoadingView.h"

@protocol LBSearchFriendsViewControllerDelegate <NSObject>

@optional

- (void)backButtonDidClicked;

@end

@interface LBSearchFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, EGORefreshTableFooterViewDelegate>{

    UITableView* _tableView;
    
    NSMutableArray* _showArray;     //存放从服务器端获取到的新浪好友信息
    
    UIView* _maskView;
    
    NSString* nextCur;  //记录服务器端是否还有更多数据的标记字符
    
    LBPersonLoadingView* _loadingView;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _headerLoading;
    BOOL  headerRefresh;
    BOOL _footerLoading;
    BOOL loading;
    
    NSInteger cursor;        // sina 当前要请求数据的游标
    BOOL      isFinish;     // 刷新一次，是否完成
    BOOL    _shouldClearData;
    
    MBProgressHUD *_progressHUD;
}
@property (nonatomic, strong) UIView* errorView;
@property (nonatomic, strong) UILabel* errorLabel;
@property (nonatomic, strong) UIImageView* errorImageView;
@property (nonatomic, weak) id <LBSearchFriendsViewControllerDelegate> delegate;
@end
