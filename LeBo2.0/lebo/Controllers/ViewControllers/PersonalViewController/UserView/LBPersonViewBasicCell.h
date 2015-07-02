//
//  LBPersonViewBasicCell.h
//  lebo
//
//  Created by lebo on 13-4-7.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface LBPersonViewBasicCell : UITableViewCell <LBTableCellDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView* avatarImageView;
@property (nonatomic, strong) UIImageView* lineImage;
@property (nonatomic, strong) UIImageView* bottomImage;
@property (nonatomic, strong) UIView* backView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* signLabel;
@property (nonatomic, strong) UIButton* attentionButton;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setTopLineHidden;
@end
