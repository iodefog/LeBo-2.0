//
//  LBSearchView.h
//  lebo
//
//  Created by King on 13-4-19.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBBaseView.h"
#import "SearchDTO.h"

@interface LBSearchUserView : LBBaseView <UIGestureRecognizerDelegate>
{
    SearchDTO *dto;
}

@property (nonatomic, retain)UIImageView *avatarImage;
@property (nonatomic, retain)UIImageView *lineImageView;
@property (nonatomic, retain)UILabel *nameLabel;
@property (nonatomic, retain)UILabel *signLabel;
@property (nonatomic, retain)UIButton *attendBtn;
@property (nonatomic, retain)NSMutableDictionary *modelItem;

+ (CGFloat)rowHeightForObject:(id)item;
- (void)setObject:(id)item;

@end