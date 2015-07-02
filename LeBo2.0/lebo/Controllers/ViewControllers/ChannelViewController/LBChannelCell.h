//
//  LBTempChannelCell.h
//  lebo
//
//  Created by yong wang on 13-3-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//


#import "LBChannelView.h"
#import "LBTableCellDelegate.h"

@interface LBTempChannelCell : UITableViewCell<LBTableCellDelegate>

@property (nonatomic, retain) NSMutableArray *channelViewArray;
@end
