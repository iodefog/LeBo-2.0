//
//  LBCommentView.h
//  lebo
//
//  Created by Zhuang Qiang on 3/28/13.
//  Copyright (c) 2013 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBBaseView.h"
#import "RTLabel.h"
#import "CommentDTO.h"

@interface LBCommentView : LBBaseView


@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) RTLabel *commentLabel;
@property(nonatomic, strong) UIImageView *avatarImage;
@property(nonatomic, strong) NSString *commentID;
@property(nonatomic, strong) NSString *commentUser;
@property(nonatomic, strong) LeboDTO *leboDTO;
@property(nonatomic, strong) NSString *commentTo;
@property(nonatomic, strong) CommentDTO *commentDTO;
@property(nonatomic, strong) UIImageView *sperateLine;

+ (CGFloat)rowHeightForObject:(id)item;
- (void)setObject:(id)item;

@end
