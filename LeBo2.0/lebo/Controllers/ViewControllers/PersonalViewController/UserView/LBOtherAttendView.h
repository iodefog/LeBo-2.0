//
//  LBOtherAttendView.h
//  lebo
//
//  Created by lebo on 13-3-31.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendAndFansDTO.h"
#import "LBPersonDetailViewController.h"
#import "LBPersonViewBasicCell.h"
@interface LBOtherAttendView : LBPersonViewBasicCell <LBTableCellDelegate>{

    AttendAndFansDTO* _personDto;
}
@property (nonatomic, strong) NSMutableDictionary* dataDict;
@end
