//
//  LBPersonLoadingView.h
//  lebo
//
//  Created by lebo on 13-4-10.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBPersonLoadingView : UIView {

    UIActivityIndicatorView* activity;
    UIImageView* loadingError;
    UILabel* label;
}
- (void)noData;
- (void)setMaskViewBackgroundColor:(UIColor*)color;
- (void)changeActivityCenter:(CGPoint)center;
@end
