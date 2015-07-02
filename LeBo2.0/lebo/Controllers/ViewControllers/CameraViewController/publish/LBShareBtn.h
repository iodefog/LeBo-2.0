//
//  LBShareBtn.h
//  lebo
//
//  Created by 乐播 on 13-4-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LBShareBtnStatus) {
    LBShareBtnStatusNormal,
    LBShareBtnStatusSelected,
    LBShareBtnStatusHightlighted
};
@interface LBShareBtn : UIView
{
    UIImageView * _iconView;
    UIImageView * _backgroundView;
    UIImageView * _highlightedView;
    
    __weak id _target;
    SEL _selector;
}
@property(nonatomic,readonly) UILabel * titleLable;


@property(nonatomic,retain) UIImage * icon;
@property(nonatomic,retain) UIImage * selectedIcon;

@property(nonatomic,retain) UIImage * backgroundImg;
@property(nonatomic,retain) UIImage * highlightedBackgroundImg;

@property(nonatomic,assign) BOOL selected;

- (id)init;

- (void)setHighlightedBackgroundImg:(UIImage *)highlightedImg;

- (void)addTarget:(id)target forSelector:(SEL)selector;
@end
