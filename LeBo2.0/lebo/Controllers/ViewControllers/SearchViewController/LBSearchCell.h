//
//  LBSearchCell.h
//  lebo
//
//  Created by King on 13-4-19.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBSearchUserView.h"
#import "LBSearchChannelView.h"

@interface LBSearchCell : UITableViewCell<LBTableCellDelegate>

@property (nonatomic, retain)LBSearchUserView *searchUserView;
@property (nonatomic, retain)LBSearchChannelView *searchChannelView;

@end
