//
//  LBRecommendCell.m
//  lebo
//
//  Created by yong wang on 13-4-24.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBRecommendCell.h"
#import "LBRecommendView.h"
@implementation LBRecommendCell
@synthesize recomendView = _recomendView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.recomendView = [[LBRecommendView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        [self.contentView addSubview:_recomendView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // Initialization code
    }
    return self;
}

- (void)setObject:(id)item
{
    if(_recomendView)
    {
        [_recomendView setObject:item];
    }
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return [LBRecommendView rowHeightForObject:item];
}


@end
