//
//  LBView.h
//  cameraDemo
//
//  Created by 乐播 on 13-3-6.
//  Copyright (c) 2013年 乐播. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBViewDisplayDelegate <NSObject>
@optional
- (void)didLayoutSubviews:(UIView *)view;

- (void)drawView:(UIView *)view;

@end

@interface LBView : UIView
@property(nonatomic,assign) id<LBViewDisplayDelegate> delegate;

@end
