//
//  AWActionSheet.h
//  AWIconSheet
//
//  Created by Narcissus on 10/26/12.
//  Copyright (c) 2012 Narcissus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AWActionSheetCell;

@protocol AWActionSheetDelegate <NSObject>

- (int)numberOfItemsInActionSheet;
- (AWActionSheetCell*)cellForActionAtIndex:(NSInteger)index;
- (void)DidTapOnItemAtIndex:(NSInteger)index;

@end

@interface AWActionSheet : UIActionSheet

-(id)initwithIconSheetDelegate:(id<AWActionSheetDelegate>)delegate ItemCount:(int)cout;
@end

// tap事件，图片点击阴影
@interface AWActionSheetCell : UIView
@property (nonatomic,retain)UIImageView * iconView;
@property (nonatomic,retain)UILabel     * titleLabel;
@property (nonatomic,assign)int           index;
@property (nonatomic, retain) UIButton  *  iconButton;
@property (nonatomic, assign) BOOL      isButton;
- (id)initIsButton:(BOOL)isButton;

@end

// button ，图片有点击阴影
@interface AWActionSheetButton : UIView
@property (nonatomic, retain) UIButton *sheetButton;
@end