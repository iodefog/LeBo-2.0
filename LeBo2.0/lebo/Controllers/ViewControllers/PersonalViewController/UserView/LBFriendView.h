//
//  LBFriendView.h
//  lebo
//
//  Created by lebo on 13-3-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddSinaFriendsDTO.h"
#import "LBFileClient.h"
#import "UIViewController+Addition.h"
#import "LBPersonalViewController.h"
#import "LBPersonViewBasicCell.h"
#import "LBEditSignViewController.h"
@protocol LBFriendViewDelegate <NSObject>

- (void)getItem:(NSMutableArray*)item;

@end

@interface LBFriendView : UITableViewCell <UIGestureRecognizerDelegate>{

    AddSinaFriendsDTO* _dto;
}
@property (nonatomic, strong) UIImageView* avatarImageView;
@property (nonatomic, strong) UIImageView* lineImageView;
@property (nonatomic, strong) UIImageView* bottomView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* signLabel;
@property (nonatomic, strong) UIButton* attentionButton;
- (void)setObject:(id)item;
@end
