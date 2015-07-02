//
//  LBTempClipView.h
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "LBMovieView.h"
#import "LBBaseView.h"
#import "LeboDTO.h"
#import "LBAppDelegate.h"
#import "AWActionSheet.h"


@interface LBTempClipView : LBBaseView<UIActionSheetDelegate, RTLabelDelegate, AWActionSheetDelegate>
{
    BOOL isSceneSession ;
}
@property(nonatomic, retain) LBMovieView *playerVideoView;
@property(nonatomic, retain) RTLabel *instructionLabel;
@property(nonatomic, retain) UILabel *timeLabel;
@property(nonatomic, retain) RTLabel *nameLabel;
@property(nonatomic, retain) UILabel *relayNameLabel;
@property(nonatomic, retain) UILabel *playCountLabel;
@property(nonatomic, retain) UIImageView *avatarImage;
@property(nonatomic, retain) UIButton *likedButton;
@property(nonatomic, retain) UIButton *commentButton;
@property(nonatomic, retain) UIButton *moreButton;
@property(nonatomic, retain) UIButton *relayButton;
@property(nonatomic, retain) UIImageView *imageViewBackground;
@property(nonatomic, retain) LeboDTO *leboDTO;
@property(nonatomic, retain) NSMutableDictionary *modelItem;
@property(nonatomic, retain) UIImageView *recommendImageView;

+ (CGFloat)rowHeightForObject:(id)item;
- (void)setObject:(id)item;

- (void)createSubview;
- (void)updateItem:(LeboDTO *)dto;
- (void)playVideo:(int)rowCell;
- (void)pauseVideoClear;
@end
