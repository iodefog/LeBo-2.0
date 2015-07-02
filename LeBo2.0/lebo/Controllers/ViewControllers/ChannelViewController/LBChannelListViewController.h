//
//  LBChannelListViewController.h
//  lebo
//
//  Created by yong wang on 13-3-30.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBChannelListViewController : LBTableApiViewController


@property (nonatomic, retain) NSString *channelTitle;

- (id)initVithChannelTitle:(NSString*)channelTitle;
+ (LBChannelListViewController *)sharedInstance;
@end
