//
//  LBBaseController.m
//  lebo
//
//  Created by 乐播 on 13-3-26.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBBaseController.h"

@interface LBBaseController ()

@end

@implementation LBBaseController

#pragma mark orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark Manage memory warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
//    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0") && [self isViewLoaded])
//    {
//        if(!self.view.window)
//        {
//            self.view = nil;
//            [self viewDidUnload];
//        }
//    }
}

@end
