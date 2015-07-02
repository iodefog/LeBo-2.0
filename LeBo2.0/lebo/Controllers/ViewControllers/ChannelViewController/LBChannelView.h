//
//  LBChannelView.h
//  lebo
//
//  Created by yong wang on 13-3-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LBBaseView.h"

@interface LBChannelView : LBBaseView


@property (nonatomic, retain) UIImageView *channelImageView;
@property (nonatomic, retain) UILabel *channelNameLabel;
@property (nonatomic, retain) UIButton *button;
- (void)createSubview;

- (void)setObject:(id)item;
+ (CGFloat)rowHeightForObject;
@end
