//
//  LBUploadCell.h
//  lebo
//
//  Created by 乐播 on 13-3-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBUploadTask.h"
#import "InfoButton.h"

@interface LBUploadCell : UITableViewCell<LBTableCellDelegate>
{
    UIImageView * _thumb;
    UILabel * _text;
}
@property(nonatomic,retain) LBUploadTask * object;
@property(nonatomic,readonly) InfoButton * button; //add target to controller
- (void)setObject:(LBUploadTask *)item;

- (void)refresh;

+ (CGFloat)rowHeightForObject:(id)item;

+ (CGFloat)height;
@end
