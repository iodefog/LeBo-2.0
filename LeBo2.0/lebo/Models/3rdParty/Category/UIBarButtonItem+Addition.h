//
//  UIBarButtonItemAddition.h
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIBarButtonItem (Addition)

+ (UIBarButtonItem*)barButtonWithTitle:(NSString *)title image:(NSString*)imageName target:(id)target action:(SEL)action;
@end

