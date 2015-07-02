//
//  LBSearvhChannelView.h
//  lebo
//
//  Created by King on 13-4-19.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBBaseView.h"

@interface LBSearchChannelView : LBBaseView

@property (nonatomic, retain) UILabel *channelLabel;
@property (nonatomic, retain) UIImageView* lineImageView;

+ (CGFloat)rowHeightForObject:(id)item;
- (void)setObject:(id)item;

@end
