//
//  SettingViewController.h
//  LBDemo
//
//  Created by Li Hongli on 13-3-25.
//  Copyright (c) 2013年 Li Hongli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeBoImagePicker.h"
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>


@interface LBSettingViewController : UIViewController<MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, SKStoreProductViewControllerDelegate, MBProgressHUDDelegate, UIActionSheetDelegate>
{ 
    UISwitch    *_auto3GPlay;        //3G自动播放
    UIImageView *_headImageView;     // 头像
    UILabel     *_nameLabel;         // 名字
    UILabel     *_vesionLabel;       // 版本号
    LeBoImagePicker *_lbPicker;      // 照相或取照片
    SKStoreProductViewController *_storeVC; //
    UIImage     *_newImage;
    UILabel     *_weiboNameLabel;         // 微博名字
    NSMutableDictionary *_partAccountDtoDict;     //用户部分信息
    MBProgressHUD *_progress;            // 进度提示
    UILabel     *_renRenNameLabel;      // 人人名字载体
    NSTimer     *_mTimer;               // 设置计时器
}
@property (nonatomic, strong) UITableView *settingTabelView; // 设置表
@property (nonatomic, strong) UITextView  *signTextView;      // 签名

@end
