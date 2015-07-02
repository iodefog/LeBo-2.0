//
//  LBPersonViewGlobal.h
//  lebo
//
//  Created by lebo on 13-3-26.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#ifndef lebo_LBPersonViewGlobal_h
#define lebo_LBPersonViewGlobal_h

#endif
#define kPersonInfoDefaultHeight 188.0f
#define kPersonViewTextColor [UIColor whiteColor]
#define kPersonViewButtonColor [UIColor grayColor]
#define kPersonClearColor [UIColor clearColor]
#define kPersonImageWidth 35
#define kPersonLabelWidth 120
#define kPersonLabelHeight 16
#define kPersonCellHeight 55
#define kPersonListImageRect CGRectMake(9, 10, 35, 35)
#define kPersonListNameRect CGRectMake(52, 10, 200, 16)
#define kPersonListSignRect CGRectMake(52, 28, 200, 16)
#define kPersonListButtonRect CGRectMake(260, 12, 50, 31)
#define kPersonLineRect CGRectMake(0, 0, 320, 1)
#define kPersonBottomLineRect CGRectMake(0, 54, 320, 1)
#define kPersonBackFrameRect CGRectMake(0, 0, 260, 55)
#import "LBAttendView.h"
#import "LBFansView.h"
#import "LBOtherAttendView.h"
#import "LBOtherFansView.h"
#import "LBPersonalViewController.h"

typedef NS_ENUM(NSInteger, PersonBottomStyle)
{
    personBottomStyleVideo,
    personBottomStyleFavor,
    personBottomStyleAttention,
    personBottomFuns
};

typedef NS_ENUM(NSInteger, PersonListStyle) {

    personListStyleUserAttend,
    personListStyleUserFans,
    personListStyleOtherAttend,
    personListStyleOtherFans,
    personListStyleFindFriends
};