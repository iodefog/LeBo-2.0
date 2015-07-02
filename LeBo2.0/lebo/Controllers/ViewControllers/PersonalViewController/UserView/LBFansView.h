//
//  LBFansView.h
//  lebo
//
//  Created by lebo on 13-3-28.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendAndFansDTO.h"
#import "LBFileClient.h"
#import "LBPersonalViewController.h"
#import "LBPersonDetailViewController.h"
#import "LBPersonViewBasicCell.h"
@interface LBFansView : LBPersonViewBasicCell <LBTableCellDelegate> {

    AttendAndFansDTO* _friendDto;
}
@end
