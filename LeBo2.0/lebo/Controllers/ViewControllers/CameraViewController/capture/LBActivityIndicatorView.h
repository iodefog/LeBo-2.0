//
//  LBActivityIndicatorView.h
//  LeBo
//
//  Created by 乐播 on 13-3-18.
//
//

#import <UIKit/UIKit.h>

@interface LBActivityIndicatorView : UIActivityIndicatorView
{
    int _animationCount;
}
- (void)addAnimation;

- (void)reduceAnimation;

@end
