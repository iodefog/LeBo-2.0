//
//  LBCommentCell.h
//  lebo
//
//  Created by Zhuang Qiang on 3/28/13.
//  Copyright (c) 2013 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBCommentView.h"
#import "LBTableCellDelegate.h"

@interface LBCommentCell : UITableViewCell<LBTableCellDelegate>

@property (nonatomic, retain) LBCommentView *commentView;

@end
