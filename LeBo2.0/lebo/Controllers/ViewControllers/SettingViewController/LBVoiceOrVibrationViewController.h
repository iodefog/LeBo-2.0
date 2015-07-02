//
//  LBVoiceOrVibrationViewController.h
//  lebo
//
//  Created by Li Hongli on 13-3-26.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBVoiceOrVibrationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UISwitch        *_voiceSwitch;       // 声音开关
    UISwitch        *_vibartionSwitch;   //  振动开关
    UITableView     *_mTable;
}

@end
