//
//  LBVideoViewController.h
//  lebo
//
//  Created by yong wang on 13-3-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LBVideoViewController : LBTableApiViewController


@property (nonatomic, retain) NSString *topicLeboID;
@property (nonatomic, assign) BOOL isTitle;

- (id)initWithTopicID:(NSString*)topicId isTitle:(BOOL)title;

@end
