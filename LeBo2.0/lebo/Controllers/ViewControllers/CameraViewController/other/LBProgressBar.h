//
//  LBProgressBar.h
//  lebo
//
//  Created by 乐播 on 13-4-7.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBProgressBar : UIView
{
    UIImageView * _barView;
    UIImageView * _backgroundView;
    float _progress;
}
@property(nonatomic,assign) float progress;
- (void)setBackgroundImage:(UIImage *)image;

- (void)setProgressImage:(UIImage *)image;

- (void)setBarColor:(UIColor *)color;

- (void)setBackgroundColor:(UIColor *)backgroundColor;
@end
