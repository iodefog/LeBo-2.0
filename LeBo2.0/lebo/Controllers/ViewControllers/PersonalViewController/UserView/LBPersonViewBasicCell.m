//
//  LBPersonViewBasicCell.m
//  lebo
//
//  Created by lebo on 13-4-7.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBPersonViewBasicCell.h"
#import "LBPersonViewGlobal.h"
@implementation LBPersonViewBasicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self customView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)customView
{
    self.bottomImage = [[UIImageView alloc] initWithFrame:kPersonBottomLineRect];
    [self.bottomImage setBackgroundColor:RGB(163, 163, 163)];
    [self.contentView addSubview:self.bottomImage];
    
    self.lineImage = [[UIImageView alloc] initWithFrame:kPersonLineRect];
    [self.lineImage setBackgroundColor:RGB(216, 216, 216)];
    [self.contentView addSubview:self.lineImage];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellDidClicked:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setDelegate:self];
    [self.contentView addGestureRecognizer:tapGesture];
    
    self.avatarImageView = [[UIImageView alloc] initWithFrame:kPersonListImageRect];
    [self.avatarImageView setBackgroundColor:[UIColor lightGrayColor]];
    [self.avatarImageView.layer setCornerRadius:2.0f];
    [self.avatarImageView setClipsToBounds:YES];
    [self.avatarImageView.layer setMasksToBounds:YES];
    [self.contentView addSubview:self.avatarImageView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:kPersonListNameRect];
    [self.nameLabel setBackgroundColor:[UIColor clearColor]];
    [self.nameLabel setTextColor:RGB(30, 30, 30)];
    [self.nameLabel setFont:[UIFont getButtonFont]];
    [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLabel];
    
    self.signLabel = [[UILabel alloc] initWithFrame:kPersonListSignRect];
    [self.signLabel setBackgroundColor:[UIColor clearColor]];
    [self.signLabel setTextColor:RGB(94, 94, 94)];
    [self.signLabel setFont:[UIFont getNormalFont]];
    [self.signLabel setTextAlignment:NSTextAlignmentLeft];
    [self.signLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.contentView addSubview:self.signLabel];
    
    self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.attentionButton addTarget:self action:@selector(attentionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.attentionButton setFrame:kPersonListButtonRect];
    [self.attentionButton setBackgroundImage:[[UIImage imageNamed:@"btn_followed_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateNormal];
    [self.attentionButton setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.attentionButton];
}

- (void)attentionButtonClicked:(id)sender
{
   
}

- (void)cellDidClicked:(id)sender
{
    
}

- (void)setObject:(id)item
{
    
}

- (void)setTopLineHidden
{
    [self.lineImage setHidden:YES];
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 55.0f;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView* view = [touch view];
    if ([view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

@end
