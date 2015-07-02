//
//  LBPersonDetailViewController.h
//  lebo
//
//  Created by lebo on 13-4-2.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AKSegmentedControl.h"
#import "RTLabel.h"
#import "LBPersonViewGlobal.h"
#import "LBPersonVideoViewController.h"
#import "LBAttendAndFansViewController.h"
#import "LBSettingViewController.h"
#import "LBMovieView.h"
#import "MBProgressHUD.h"
#import "LBPersonLoadingView.h"
@interface LBPersonDetailViewController : UIViewController <AKSegmentedControlDelegate> {

    UIImageView* _personalHearderView;
    UIImageView* _avatarImageView;
    RTLabel* _nameLabel;
    RTLabel* _signLabel;
    RTLabel* _lovedLabel;
    RTLabel* _playedLabel;
    AKSegmentedControl *_segmentedControl;
    UIButton* _settingOrFocusOnButton;
    AccountDTO* _currentDto;
    AccountDTO *account;
    NSInteger _bottomStyle;
    BOOL _isCurrentUser;
    BOOL _isAttending;
    BOOL _subControllerShouldReload;
    
    CGFloat tableViewHeight;
    
    NSInteger _segmentIndex;
    NSMutableArray* _controllerArray;
    UIView* _tmpView;
    LBPersonLoadingView* _loadingView;
}

@property (nonatomic, copy) NSString *currentAccount;


- (id)getControllerArray;
- (id)initWithAccountID:(NSString*)accountID;
- (void)sendCurrentAccountInfo:(BOOL)isReload;
- (void)disableLoadVideoData;
+ (LBPersonDetailViewController *)sharedInstance;
@end
