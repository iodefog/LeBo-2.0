//
//  LBHomeViewController.h
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTableApiViewController.h"


@interface LBHomeViewController : LBTableApiViewController<UIScrollViewDelegate>
{
    CGFloat navigationBarTop;
}
@end

