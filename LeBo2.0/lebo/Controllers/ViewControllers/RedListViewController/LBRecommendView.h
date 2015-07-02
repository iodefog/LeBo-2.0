//
//  LBRecommendView.h
//  lebo
//
//  Created by yong wang on 13-4-24.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBBaseView.h"
@class RecommentDTO;

@interface LBRecommendView : LBBaseView <UIGestureRecognizerDelegate>

@property(nonatomic, retain) UIImageView *avatarImage;
@property(nonatomic, retain) UILabel *textLabel;
@property(nonatomic, retain) UILabel *detailLabel;
@property(nonatomic, retain) UIButton *followButton;
@property(nonatomic, retain) RecommentDTO *dto;
@property(nonatomic, retain) NSMutableDictionary *modelItem;
@property(nonatomic, retain) UIImageView *lineImageView;

+ (CGFloat)rowHeightForObject:(id)item;
- (void)setObject:(id)item;

- (void)createUI;
@end
