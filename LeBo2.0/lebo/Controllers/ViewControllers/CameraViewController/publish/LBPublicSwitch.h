//
//  LBPublicSwitch.h
//  lebo
//
//  Created by 乐播 on 13-4-1.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBPublicSwitch : UIImageView
{
    UIImageView * _btn;
}
@property(nonatomic,getter=isOn) BOOL on;
- (id)init;



@end
