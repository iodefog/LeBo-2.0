//
//  LBRecommendCell.h
//  lebo
//
//  Created by yong wang on 13-4-24.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBRecommendView;

@interface LBRecommendCell : UITableViewCell<LBTableCellDelegate>


@property (nonatomic, strong)LBRecommendView *recomendView;
@end
