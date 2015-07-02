//
//  LBCommentViewController.h
//  lebo
//
//  Created by Zhuang Qiang on 3/28/13.
//  Copyright (c) 2013 lebo. All rights reserved.
//

#import "LBTableApiViewController.h"
#import "UIInputToolbar.h"

@interface LBCommentViewController : LBTableApiViewController <UIInputToolbarDelegate,UIScrollViewDelegate>
{
    NSString *text;
    MBProgressHUD *progress;
}

@property (nonatomic, retain) NSString *leboID;
@property (nonatomic, retain) NSString *topicID;
@property (nonatomic, retain) NSString *toCommentUser;
@property (nonatomic, retain) NSString *commentTo;
@property (nonatomic, assign) BOOL keyboardIsVisible;
@property (nonatomic, retain) UIInputToolbar *inputToolbar;
@property (nonatomic, retain) UIView *upperView;
@property (nonatomic, retain) UILabel *replyLabel;
@property (nonatomic, retain) NSMutableDictionary *modelItem;

- (id)initWithLeboID:(id)item;
@end
