//
//  LBTableCell.h
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

@protocol LBTableCellDelegate <NSObject>

+ (CGFloat)rowHeightForObject:(id)item;
@optional
- (void)setObject:(id)item;
- (void)setObject:(id)item topViewIndex:(uint)topViewIndex;
- (void)setObject:(id)item topViewIndex:(uint)topViewIndex row:(int)row;
- (void)playVideo:(int)rowCell;
- (BOOL)isPreLoadPhoto:(UIImageView *)imageView;
- (void)loadCacheInfo:(id)info;
- (void)clearCacheInfo:(id)info;
@end
