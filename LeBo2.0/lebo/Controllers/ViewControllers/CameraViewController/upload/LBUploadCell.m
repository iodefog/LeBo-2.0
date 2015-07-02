//
//  LBUploadCell.m
//  lebo
//
//  Created by 乐播 on 13-3-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBUploadCell.h"
#import "LBCameraTool.h"
#import "LBUploadTaskManager.h"
@implementation LBUploadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UIView * bgView = [[UIView alloc] initWithFrame:CGRectZero];
        bgView.backgroundColor = RGB(244,244,244);
        self.backgroundView = bgView;
        _thumb = [[UIImageView alloc] init];
        [self.contentView addSubview:_thumb];
        
        _text = [[UILabel alloc] init];
        _text.backgroundColor = [UIColor clearColor];
        _text.textColor = [UIColor darkGrayColor];
        _text.font = [UIFont getButtonFont];
        [self.contentView addSubview:_text];
        
        _button = [InfoButton buttonWithType:UIButtonTypeCustom];
        _button.userInfo = self;
        UIImage * img = Image(@"camera_btn_publish.png");
        img = [img stretchableImageWithLeftCapWidth:12 topCapHeight:8];
        [_button setBackgroundImage:img forState:UIControlStateNormal];
        _button.titleLabel.shadowColor = [UIColor blackColor];
        _button.titleLabel.shadowOffset = CGSizeMake(0, 1);
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont getNormalFont];
        [self.contentView addSubview:_button];
        
        UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
        topLine.backgroundColor = [UIColor whiteColor];
        topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:topLine];
        
        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
        bottomLine.backgroundColor = RGB(188,188,188);
        bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:bottomLine];
        
        
    }
    return self;
}


+ (CGFloat)rowHeightForObject:(id)item
{
    return 50;
}

+ (CGFloat)height
{
    return 50;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"layout");
    
    _thumb.frame = CGRectMake(12, 8, 34, 34);
    _text.frame = CGRectMake(_thumb.right + 9, (self.height -20)/2, 250, 20);
    
    float button_space = (self.height-28)/2;
    _button.frame = CGRectMake(self.width - 62 - 14, button_space, 62, 28);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if(editing)
    {
        _button.hidden = YES;
    }
    else
    {
        _button.hidden = NO;
    }
}


- (void)setObject:(LBUploadTask *)item
{
    _object = item;
}

- (void)refresh
{
    LBUploadTask * item = _object;
    UIImage * img = [LBCameraTool getThumbImageWithPath:item.path];
    _thumb.image = [img resizeImageWithNewSize:_thumb.frame.size];
    LBUploadView * uploadingView = [[LBUploadTaskManager sharedInstance] uploadingView];

    NSLog(@"[item uploadStatus]:%d",[[item uploadStatus] intValue]);
    if([[item uploadStatus] intValue] == UploadTaskStatusFailed)
    {
        if(uploadingView.superview == self.contentView)
            [uploadingView removeFromSuperview];
        _button.hidden = NO;
        [_button setTitle:@"重新上传" forState:UIControlStateNormal];
        NSDate * createDate = [item date];
        _text.text = [NSDate getDisplayTime:createDate];
    }
    else if([[item uploadStatus] intValue] == UploadTaskStatusDraft)
    {
        if(uploadingView.superview == self.contentView)
            [uploadingView removeFromSuperview];
        _button.hidden = NO;
        [_button setTitle:@"立即上传" forState:UIControlStateNormal];
        NSDate * createDate = [item date];
        _text.text = [NSDate getDisplayTime:createDate];
    }
    else if([[item uploadStatus] intValue] == UploadTaskStatusUploading)
    {
        if(uploadingView.superview!=self.contentView)
        {
            [self.contentView addSubview:uploadingView];
            _button.hidden = YES;
            _text.text = nil;
            uploadingView.frame = CGRectMake(0, 0, self.width, [uploadingView defaultHeight]);
        }
    }
    else if([[item uploadStatus] intValue] == UploadTaskStatusPrepare)
    {
        if(uploadingView.superview == self.contentView)
            [uploadingView removeFromSuperview];
        _button.hidden = YES;
        _text.text = @"等待上传";
    }
    else
    {
        if(uploadingView.superview == self.contentView)
            [uploadingView removeFromSuperview];
    }
}


@end
