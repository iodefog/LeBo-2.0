//
//  LBTopView.h
//  lebo
//
//  Created by King on 13-4-18.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBBaseView.h"
#import "TopDTO.h"
#import "RTLabel.h"
@interface LBTopView : LBBaseView <UIGestureRecognizerDelegate>
{
    BOOL isAttend;
    TopDTO *dto;
}

@property (nonatomic, retain)UIImageView *avatarImage;
@property (nonatomic, retain)UILabel *nameLabel;
@property (nonatomic, retain)UILabel *numberLabel;
@property (nonatomic, retain)RTLabel *signLabel;
@property (nonatomic, retain)UIButton *attendBtn;
@property (nonatomic, retain)NSMutableDictionary *modelItem;
@property (nonatomic, retain)UILabel *topLabel;
@property (nonatomic, retain)UIImageView *lineImageView;

+ (CGFloat)rowHeightForObject:(id)item;
- (void)setObject:(id)item topViewIndex:(uint)topViewIndex row:(int)row;
@end
