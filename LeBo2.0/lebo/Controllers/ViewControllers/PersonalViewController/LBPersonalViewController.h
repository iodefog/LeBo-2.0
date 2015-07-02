//
//  LBPersonalViewController.h
//  lebo
//
//  Created by yong wang on 13-3-24.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DTOBase.h"
#import "AccountDTO.h"
#import "LBMessageViewController.h"
#import "LBSearchFriendsViewController.h"
#import "AKSegmentedControl.h"
#import "LBPersonVideoViewController.h"
#import "LBPersonDetailViewController.h"

@interface LBPersonalViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,AKSegmentedControlDelegate>{
    NSMutableArray* _controllerArray;
    AccountDTO* _currentPageAccount;
    NSString *_accountLeboID;
    UIView* _backgroundView;
    UITableView* _userInfoTableView;
    //NSString* _accountLeboID;
}
@property (nonatomic, assign) NSInteger segmentIndex;
@property (nonatomic, retain)AKSegmentedControl *segmentedControl;
- (void)setIndex:(NSInteger)num;
- (id)getControllerArray;
- (void)segmentedChangeViewController;
- (id)initWithPersonID:(NSString*)accountID;
- (id)initWithBackbuttonAndPersonID:(NSString *)accountID;
@end
