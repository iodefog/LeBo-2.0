//
//  LBPersonVideoViewController.h
//  lebo
//
//  Created by lebo on 13-4-2.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPersonViewGlobal.h"
#import "LBTempClipsCell.h"
@protocol LBPersonVideoViewControllerDelegate <NSObject>

@optional
- (void)userInfoShouldReload;

@end

@interface LBPersonVideoViewController : LBTableApiViewController <EGORefreshTableFooterViewDelegate, EGORefreshTableHeaderDelegate> {

    NSInteger _bottomStyle;
    NSString* _accountID;
    
    UIView* _backView;
    
    BOOL shouldShow;
}
@property (nonatomic, weak) id <LBPersonVideoViewControllerDelegate> delegate;
- (void)changePlayState:(BOOL)state;
- (id)initWithAccountid:(NSString*)accountID withStyle:(NSInteger)tStyle;
- (void)setHeaderView:(UIView*)view;
- (void)reloadTableViewData;;
@end
