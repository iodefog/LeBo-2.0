//
//  LBMessageCell.h
//  lebo
//
//  Created by yong wang on 13-3-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMessageView.h"
#import "NoticeDTO.h"


@interface LBMessageCell : UITableViewCell<LBTableCellDelegate, UIActionSheetDelegate>
{
    NoticeDTO *_noticeDTO;
    NSString *leboID;
}
@property (nonatomic, retain) LBMessageView *messageView;
@property (nonatomic, weak)  id commentDelegate;

@end
