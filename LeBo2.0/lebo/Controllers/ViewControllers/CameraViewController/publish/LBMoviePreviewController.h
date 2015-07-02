//
//  LBMoviePreviewController.h
//  lebo
//
//  Created by 乐播 on 13-4-17.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMovieView.h"
@interface LBMoviePreviewController : UIViewController
{
    __weak LBMovieView * _movieView;
    NSURL * _url;
}

- (void)setURL:(NSURL *)url;

@end
