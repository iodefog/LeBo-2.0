//
//  LBTopCell.h
//  lebo
//
//  Created by King on 13-4-18.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTopView.h"

@interface LBTopCell : UITableViewCell<LBTableCellDelegate>

@property (nonatomic, retain) LBTopView *topView;
@end
