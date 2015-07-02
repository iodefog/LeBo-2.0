//
//  NoticeViewController.h
//  LBDemo
//
//  Created by Li Hongli on 13-3-25.
//  Copyright (c) 2013年 Li Hongli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBNoticeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    UITableView *_mTable;
    NSMutableArray *_dataList;
    NSMutableArray *_switchArray;
    UISwitch *_oneSwitch;
    UISwitch *_secondSwitch;
    UISwitch *_thirdSwitch;
    NSMutableDictionary *_partAccountDict;
}


@end
