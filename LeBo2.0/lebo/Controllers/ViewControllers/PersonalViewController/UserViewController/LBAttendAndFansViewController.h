//
//  LBAttendAndFansViewController.h
//  lebo
//
//  Created by lebo on 13-4-2.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPersonViewGlobal.h"

@protocol LBAttendAndFansViewControllerDelegate <NSObject>

@optional
- (void)userInfoShouldReload;

@end

@interface LBAttendAndFansViewController : LBTableApiViewController {

    NSInteger _bottomStyle;
    NSString* _accountID;
    UIView* _backView;
    
    BOOL _isCurrentUser;
}
- (void)setHeaderView:(UIView*)view;
- (id)initWithAccountid:(NSString*)accountID withStyle:(NSInteger)tStyle;
- (void)reloadTableViewData;
@property (nonatomic, weak) id <LBAttendAndFansViewControllerDelegate> delegate;
@end
