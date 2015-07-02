//
//  SettingViewController.m
//  LBDemo
//
//  Created by Li Hongli on 13-3-25.
//  Copyright (c) 2013年 Li Hongli. All rights reserved.
//

#import "LBSettingViewController.h"
#import "LBNoticeViewController.h"
#import "LBEditSignViewController.h"
#import "LBVoiceOrVibrationViewController.h"
#import "LBAppDelegate.h"
#import "LBFileClient.h"
#import <QuartzCore/QuartzCore.h>
#import "UIDevice+Hardware.h"
#import "LBMovieView.h"
#import "RenRenHelper.h"
#import "SinaHelper.h"
@interface LBSettingViewController ()<RenRenHelperDelegate>

@end

@implementation LBSettingViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _lbPicker = [[LeBoImagePicker alloc]init];
        
    }
    return self;
}

// viewLifeCycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [LBMovieView pauseAll];
    [Global clearPlayStatus];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setHidesBottomBarWhenPushed:YES];
    [self  createUI];
    NSLog(@"%d",[[SinaHelper getHelper] sinaIsAuthValid]);
}

- (void)viewDidUnload{
    _settingTabelView = nil;
}

- (void)createUI{
    self.title = @"设置";
    _partAccountDtoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"partAccountDTO"];
    _lbPicker.parent = self;
    _settingTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) style:UITableViewStyleGrouped];
    _settingTabelView.delegate = self;
    _settingTabelView.dataSource = self;
    _settingTabelView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_settingTabelView];
 
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithTitle:@"返回" image:@"general_back.png" target:self action:@selector(back)];
    
    _signTextView = [[UITextView alloc]initWithFrame:CGRectMake(60, 4, 320 - 90, 88.0f)];
    _signTextView.backgroundColor = [UIColor clearColor];
    _signTextView.font = [UIFont systemFontOfSize:14.0f];
    _signTextView.editable = NO;
    _signTextView.text = [_partAccountDtoDict objectForKey:@"sign"];
       
    [self checkSinaTokenIsSessionValid];
    
    [self checkPhoneVersion];
    
    // 获取人人网名字
    if ([RenRenHelper isSessionValidTarget:self isLogin:NO]) {
         [RenRenHelper getUserInfoTarget:self];
    }
}

// 当版本号大于等于6.0 时，调用6.0支持的自己评价 ,小于6.0，跳到appstore应用
- (void)checkPhoneVersion{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    if (phoneVersion.intValue >= 6.0){ 
        [self performSelector:@selector(createAppStore) withObject:nil];
    }
}

// 检查新浪token 是否有效或者过期
- (void)checkSinaTokenIsSessionValid{
    LBAppDelegate *appDelegate = (LBAppDelegate *)[UIApplication sharedApplication].delegate;
    // sina_token 是否过期
    BOOL isExpired = [appDelegate.sinaweibo isAuthorizeExpired];
    // sina_token 是否有效
    BOOL isAuthValid = [appDelegate.sinaweibo isAuthValid];
    if (!isAuthValid || isExpired) {
        UIView *bgTextView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 22)];
        bgTextView.backgroundColor = [UIColor blackColor];
        bgTextView.alpha = 0.7f;
        bgTextView.tag = 250;
        [self.view addSubview:bgTextView];
        UILabel *warningText = [[UILabel alloc] initWithFrame:bgTextView.frame];
        warningText.backgroundColor = [UIColor clearColor];
        warningText.textColor = [UIColor whiteColor];
        warningText.font = [UIFont systemFontOfSize:14.0f];
        warningText.text = @"微博账号已过期或已失效，请重新绑定";
        warningText.tag = 251;
        warningText.textAlignment = UITextAlignmentCenter;
        [self.view addSubview:warningText];
    }
}

// 当系统版本大于等于6.0时，调用，初始化
- (void)createAppStore{
    _storeVC = [[SKStoreProductViewController alloc]init];
    _storeVC.delegate = self;

    [_storeVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : @"598266288"} completionBlock:^(BOOL result, NSError *error) {
    if (error) {
        NSLog(@"%@",error);
    }else{
        NSLog(@"appstore success");
    }
    }];
}

// 返回
- (void)back{
    self.tabBarController.tabBar.hidden = NO;
    [Global clearPlayStatus];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tabelViewDelegate

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0 ) {
            return 88.0f;
        }else if (indexPath.row == 2){
            CGSize commentSize;
            commentSize.width = _signTextView.frame.size.width;
            commentSize.height = MAXFLOAT;
            CGSize textSize = [_signTextView.text sizeWithFont:_signTextView.font constrainedToSize:commentSize lineBreakMode:NSLineBreakByCharWrapping];
            if (textSize.height <= 23.0f) {
                return 44.0f;
            }else if (textSize.height > 23.3*2){
                return 88.0f;
            }else{
                return 66.0f;
            }
        }
    }
    return 44.0f;
}

// 支持我们
- (void)supportUsInAppStore{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    if (phoneVersion.intValue >= 6.0){ // 当版本号大于等于6.0 时，调用6.0支持的自己评价Controller
        [self presentViewController:_storeVC animated:YES completion:nil];
    }else{ //  版本小于6.0 时，网页评价
        NSString *url = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", @"598266288"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

// 意见反馈
- (void)sendMailToLebo{
    BOOL mBool =  [MFMailComposeViewController canSendMail];
    if(mBool){
        MFMailComposeViewController *_mail = [[MFMailComposeViewController alloc] init];
        _mail.navigationBar.tintColor = [UIColor blackColor];
        _mail.mailComposeDelegate = self;
        //设备名称
        NSString* deviceName = [[UIDevice currentDevice] systemName];
        NSLog(@"设备名称: %@",deviceName );
        //手机系统版本
        NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
        NSLog(@"手机系统版本: %@", phoneVersion);
        //手机型号
        NSString* phoneModel = [[UIDevice currentDevice] model];
        NSLog(@"手机型号: %@",phoneModel );
        
        // 当前应用软件版本  比如：1.0.1
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSLog(@"当前应用软件版本:%@",appCurVersion);
        
        [_mail setSubject:[NSString stringWithFormat:@"[意见反馈][%@][%@ %@][乐播 %@]",[[UIDevice currentDevice] platformString] , deviceName, phoneVersion, appCurVersion]];
        [_mail setToRecipients:[NSArray arrayWithObjects:@"feedback@lebooo.com", nil]];
        //            [mail setCcRecipients:[NSArray arrayWithObject:@"13811963046@163.com"]];
        //            [mail setBccRecipients:[NSArray arrayWithObject:@"secret@gmail.com"]];
        [_mail setMessageBody:@"" isHTML:NO];
        [self presentModalViewController:_mail animated:YES];
    }else{
        NSLog(@"你还没有设置邮箱帐号");
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"你还没有设置邮箱帐号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [_alert show];
    }
}


- (void)requestDidFinishLoad:(NSData*)data
{
    
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", [json_string JSONValue]);
 
    if(json_string.length > 0)
    {
        id responseObject = [[json_string JSONValue] objectForKey:@"error"];
        if(responseObject)
        {
            for(int i = 0; i < 3; i++)
            {
                id curPlayCellIndex = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"curPlayCellIndex_%d",i]];
                if(curPlayCellIndex)
                {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey: [NSString stringWithFormat:@"curPlayCellIndex_%d",i]];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            
            id selectPlay = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectPlay"];
            
            if(selectPlay)
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectPlay"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            if([responseObject isKindOfClass:[NSString class]] && [responseObject isEqualToString:@"OK"])
            {
                NSLog(@"logout OK");
            }
            
            if([responseObject isKindOfClass:[NSString class]] && [responseObject isEqualToString:@"FAIL"])
            {
                NSLog(@"logOut fail");
            }
        }
    } else {
        [self requestError:nil];
    }
}

- (void)requestError:(NSData*)data{
    NSLog(@"ERROR");
}

- (void)setLogout:(AccountDTO *)account
{
    LBFileClient *client = [LBFileClient sharedInstance];
    
    //  保存用户配置
    //[SettingHelper save];
    //[LocalUserInfo clearUserInfo];
    
    //
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"partAccountDTO"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    BOOL bindDevice = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bindDevice"] boolValue];
    if (bindDevice == YES && deviceToken.length > 20) {
        AccountDTO *account = [AccountHelper getAccount];
     [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"bindDevice"];
#ifdef __OPTIMIZE__
        [client logoutDevice:[NSArray arrayWithObjects:[account Token], [account AccountID], @"Lebo_iPhone", deviceToken, nil] cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
#else
        [client logoutDevice:[NSArray arrayWithObjects:[account Token], [account AccountID], @"Lebo_iPhone_Dev", deviceToken, nil] cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
#endif
    }
}

//NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
//BOOL bindDevice = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bindDevice"] boolValue];
//if (bindDevice == YES && deviceToken.length > 20) {
//    AccountDTO *account = [AccountHelper getAccount];
//#ifdef __OPTIMIZE__
//    [DeviceService logoutDevice:self accessToken:[account Token] accountID:[account AccountID] deviceType:@"Lebo_iPhone" deviceToken:deviceToken];
//#else
//    [DeviceService logoutDevice:self accessToken:[account Token] accountID:[account AccountID] deviceType:@"Lebo_iPhone_Dev" deviceToken:deviceToken];
//#endif
//}
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 4) {
        return 3;
    }else if (section == 1 ||section == 3){
        return 2;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    UITableViewCell *cell;
    // 当cell类型== UITableViewCellStyleDefault，可以用UITextAlient 居中
    if (indexPath.section == 5 || indexPath.section == 6) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }else{
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    cell.accessoryType = 0;
    cell.selectionStyle = 1;
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:// 头像
                {
                    cell.textLabel.text = @"头像";
                    cell.accessoryType = 1;
                    cell.selectionStyle = 0;
                    _headImageView = [[UIImageView alloc] init];
                    _headImageView.frame = CGRectMake(190, 4, 80, 80);
                    _headImageView.backgroundColor = RGB(234, 234, 234);
                    _headImageView.layer.cornerRadius = 2.0;
                    _headImageView.layer.masksToBounds = YES;
                    if (_newImage) {
                        _headImageView.image = _newImage;
                    }else{
                        [_headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerUrl2], [_partAccountDtoDict objectForKey:@"photoUrl"]]]];
                    }
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeadImageClicked:)];
                    [_headImageView addGestureRecognizer:tap];
                    [cell.contentView addSubview:_headImageView];
                    break;
                }
                case 1:// 名字
                {
                    cell.textLabel.text = @"名字";
                    cell.selectionStyle = 0;
                    if (!_nameLabel) {
                        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, cell.frame.size.width - 60.0f - 50.0f, 44.0f)];
                        _nameLabel.font = [UIFont systemFontOfSize:16.0f];
                        _nameLabel.backgroundColor = [UIColor clearColor];
                        _nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
                        _nameLabel.textAlignment = UITextAlignmentRight;
                        _nameLabel.textColor = RGB(131, 131, 131);
                    }
                    [cell.contentView addSubview:_nameLabel];
                    break;
                }
                case 2:// 签名
                {
                    cell.textLabel.text = @"签名";
                    cell.accessoryType = 1;
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
                    [cell addGestureRecognizer:tapGesture];
                    CGSize commentSize;
                    commentSize.width = _signTextView.frame.size.width;
                    commentSize.height = MAXFLOAT;
                    CGSize textSize = [_signTextView.text sizeWithFont:_signTextView.font constrainedToSize:commentSize lineBreakMode:NSLineBreakByCharWrapping];
                    CGRect frame = _signTextView.frame;
                    if (textSize.height <= 23.0f ) {
                        frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 33.0f);
                        _signTextView.center = CGPointMake(cell.center.x + 20, cell.center.y);
                    }
                    else if (textSize.height <= 23.0f * 2) {
                        frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 56.0f);
                        _signTextView.center = CGPointMake(cell.center.x + 20, cell.center.y + 10);
                    }else{
                        frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 23.0f*3 + 10);
                        _signTextView.center = CGPointMake(cell.center.x + 20, cell.center.y + 20);
                    }
                    _signTextView.font = [UIFont systemFontOfSize:14.0f];
                    _signTextView.frame = frame;
                    _signTextView.textAlignment = UITextAlignmentRight;
                    [cell addSubview:_signTextView];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:// 微博
                {
                    cell.textLabel.text = @"微博";
                    cell.selectionStyle = 0;
                    LBAppDelegate *appDelegate = (LBAppDelegate *)[UIApplication sharedApplication].delegate;
                    
                    if (!_weiboNameLabel) {
                        _weiboNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, cell.frame.size.width - 60.0f - 50.0f, 44.0f)];
                        _weiboNameLabel.backgroundColor = [UIColor clearColor];
                        _weiboNameLabel.textAlignment = UITextAlignmentRight;
                        _weiboNameLabel.font = [UIFont systemFontOfSize:16.0f];
                        _weiboNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
                        _weiboNameLabel.textColor = RGB(131, 131, 131);
                    }
                    
                    // token是否过期
                    BOOL isExpired = [appDelegate.sinaweibo isAuthorizeExpired];
                    // token 是否有效
                    BOOL isAuthValid = [appDelegate.sinaweibo isAuthValid];
                    if (!isAuthValid || isExpired) {
                        UIButton *reBundleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        [reBundleBtn setTitle:@"重新绑定" forState:UIControlStateNormal];
                        [reBundleBtn addTarget:self action:@selector(reBundleClicked:) forControlEvents:UIControlEventTouchUpInside];
                        UIImage *bgImage = [UIImage imageNamed:@"btn_followed_background.png"];
                         bgImage =  [bgImage stretchableImageWithLeftCapWidth:14 topCapHeight:14];
                         [reBundleBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
                        reBundleBtn.frame =CGRectMake(cell.frame.size.width - 110, 4, 80, 34);
                        [cell.contentView addSubview:reBundleBtn];
                    }else{
                        [cell.contentView addSubview:_weiboNameLabel];
                    }
                    break;
                }
                case 1:// 人人网
                {
                    cell.textLabel.text = @"人人网";
                    cell.accessoryType = 1;
                    if (!_renRenNameLabel) {
                        _renRenNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, cell.frame.size.width - 60.0f - 50.0f, 44.0f)];
                        _renRenNameLabel.backgroundColor = [UIColor clearColor];
                        _renRenNameLabel.textAlignment = UITextAlignmentRight;
                        _renRenNameLabel.font = [UIFont systemFontOfSize:16.0f];
                    }
                    if ([RenRenHelper isSessionValidTarget:self isLogin:NO]) {
                        _renRenNameLabel.textColor = RGB(131, 131, 131);
                    }
                    else{
                        _renRenNameLabel.text = @"未绑定";
                        _renRenNameLabel.textColor = [UIColor redColor];
                    }
                    
                    [cell.contentView addSubview:_renRenNameLabel];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            cell.textLabel.text = @"3G网络自动播放";
            cell.selectionStyle = 0;
            NSNumber *autoPlay = [[NSUserDefaults standardUserDefaults] objectForKey:@"3GAutoPlay"];
            if (!_auto3GPlay) {
                _auto3GPlay = [[UISwitch alloc]initWithFrame:CGRectMake(cell.frame.size.width - 100, 10, 60, 34)];
                
                [_auto3GPlay addTarget:self action:@selector(auto3GPlay:) forControlEvents:UIControlEventValueChanged];
            }
            
            if (autoPlay) {
                if (autoPlay.boolValue == YES) {
                    [_auto3GPlay setOn:YES];
                }else{
                    [_auto3GPlay setOn:NO];
                }
            }else{
                [_auto3GPlay setOn:YES];
            }
            
            [cell addSubview:_auto3GPlay];
            break;
        }
        case 3:
        {
            switch (indexPath.row) {
                case 0:// 通知设置
                {
                    cell.textLabel.text = @"通知设置";
                    cell.accessoryType = 1;
                    break;
                }
                case 1:// 声音与振动
                {
                    cell.textLabel.text = @"声音和振动";
                    cell.accessoryType = 1;
                }
                default:
                    break;
            }
            break;
        }
        case 4:
        {
            switch (indexPath.row) {
                case 0:// 意见反馈
                {
                    cell.textLabel.text = @"意见反馈";
                    cell.accessoryType = 1;
                    break;
                }
                    case 1://支持我们
                {
                    cell.textLabel.text = @"支持我们";
                    cell.accessoryType = 1;
                    break;
                }
                case 2:
                {
                    cell.textLabel.text = @"版本号";
                    cell.selectionStyle = 0;
                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                    NSLog(@"当前应用软件版本:%@",appCurVersion);
                    if (!_vesionLabel) {
                        _vesionLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, cell.frame.size.width- 130, 44)];
                        _vesionLabel.textAlignment = UITextAlignmentRight;
                        _vesionLabel.text = appCurVersion;
                        _vesionLabel.font = [UIFont systemFontOfSize:16.0f];
                        _vesionLabel.backgroundColor = [UIColor clearColor];
                        _vesionLabel.textColor = RGB(131, 131, 131);
                    }
                    [cell addSubview:_vesionLabel];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 5:
        {
            cell.textLabel.text = @"清除缓存";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            break;
        }
        case 6:
        {
            cell.textLabel.text = @"退出登录";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            break;
        }
        default:
            break;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0: // 修改头像
                {
                    [self changeHeadImageClicked:nil];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            if (indexPath.row == 0) {  // 微博
                
            }else if(indexPath.row == 1){ // 人人网
                if ([_renRenNameLabel.text isEqualToString:@"未绑定"]) {
                    [self renRenReBundleClicked];
                }
                else{
                    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"人人网" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"解除绑定", nil];
                    [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
                    [sheet showInView:self.view];
                }
            }
            break;
        }
        case 2: 
        { 
            break;
        }
        case 3:// 消息提醒
        {
            switch (indexPath.row) {
                case 0:
                {
                    LBNoticeViewController *_noticeVC = [[LBNoticeViewController alloc]init];
                    [self.navigationController pushViewController:_noticeVC animated:YES];
                    break;
                }
                case 1:
                {
                    LBVoiceOrVibrationViewController *_voiceOrVibartion = [[LBVoiceOrVibrationViewController alloc]init];
                    [self.navigationController pushViewController:_voiceOrVibartion animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 4:
        {
            switch (indexPath.row) {
                case 0:// 意见反馈
                {
                    [self sendMailToLebo];
                    break;
                }
                case 1:// 支持我们
                {
                    [self supportUsInAppStore];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 5:// 清除缓存
        {
            [FileUtil clearCache];
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"删除成功";
            [hud hide:YES afterDelay:1];
            [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
            break;
        }
        case 6: //退出登陆
        {
            LBFileClient *client = [LBFileClient sharedInstance];
            [client logout:nil cachePolicy:NSURLRequestReloadRevalidatingCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
            [self setLogout:[AccountHelper getAccount]];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"退出成功"];
            
            LBAppDelegate *delegate = (LBAppDelegate *)[UIApplication sharedApplication].delegate;
            if ([delegate respondsToSelector:@selector(changedRootVCToLogin)]) {
                [delegate performSelector:@selector(changedRootVCToLogin)];
            }
            
            [[SinaHelper getHelper] setDelegate: self];
            [[SinaHelper getHelper] logout];
            [AccountHelper loginDidChange];
            
            [[RenRenHelper sharedInstance] logOut];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"session"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
            
            break;
        }
        default:
            break;
    }
}

// 3G 自动播放 
- (void)auto3GPlay:(UISwitch *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_auto3GPlay.isOn] forKey:@"3GAutoPlay"];
    
    // 观察者
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center postNotificationName:@"3GAutoPlay" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"1",[NSNumber numberWithBool:sender.isOn], nil]];
}

//  修改头像 
- (void)changeHeadImageClicked:(UIButton *)sender{
    [_lbPicker tap:_headImageView inView:self.tabBarController.view inController: self.tabBarController toCut: YES];
}

// 修改完签名后返回是调用
- (void)changeSignText:(NSString *)text{
    _signTextView.text = text;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_partAccountDtoDict];
    [dict removeObjectForKey:@"sign"];
    [dict setObject:text forKey:@"sign"];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"partAccountDTO"];
    [_settingTabelView reloadData];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"changeSign" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:text,@"sign", nil]];
}

// 签名框点击
- (void)tapGesture:(UITapGestureRecognizer *)tapGesture{
    LBEditSignViewController *editSignVC = [[LBEditSignViewController alloc]init];
    editSignVC.signText = _signTextView.text;
    editSignVC.parent = self;
    editSignVC.action = @selector(changeSignText:);
    [self.navigationController pushViewController:editSignVC animated:YES];
}

// 人人网重新绑定
- (void)renRenReBundleClicked{
    [RenRenHelper isSessionValidTarget:self isLogin:YES];
}

#pragma mark - Delegate for LeBoImagePicker

- (void)setViewPhoto:(NSString *)path sender:(id)sender {
//    UIImageView *headImageView = (UIImageView *)sender;
    _newImage = [UIImage imageWithContentsOfFile: path];
//    [headImageView setImage:_newImage];
    
    _progress = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_progress];
    _progress.labelText = @"加载中";
    _progress.delegate = self;
    [_progress show:YES];
    
    [[LBFileClient sharedInstance] uploadAvatar:_newImage cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData delegate:self selector:@selector(didFinishUpload:) selectorError:@selector(didFailedUpload:)];
}

- (void)didFinishUpload:(id)date {
    NSString * result = [[NSString alloc] initWithData:date encoding:NSUTF8StringEncoding];
    NSLog(@"successUpload1:%@",[result JSONValue]);
    NSDictionary *dict = [[result JSONValue] objectForKey:@"result"];
    NSString *photoUrl = [dict objectForKey:@"fileName"];
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] initWithDictionary:_partAccountDtoDict];
    [newDict removeObjectForKey:@"photoUrl"];
    [newDict setObject:[NSString stringWithFormat:@"?cmd=GEOWEIBOD.mime3+%@",photoUrl] forKey:@"photoUrl"];
    _partAccountDtoDict = newDict;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"partAccountDTO"];
    [[NSUserDefaults standardUserDefaults] setObject:newDict forKey:@"partAccountDTO"];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"changeHead" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:photoUrl,@"headUrl", nil]];
    
    [[LBFileClient sharedInstance] setAvatar:[[[result JSONValue] objectForKey:@"result"] objectForKey:@"fileName"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData delegate:self selector:@selector(setAvatarDidFinishLoad:) selectorError:@selector(didFailedUpload:)];
}

- (void)setAvatarDidFinishLoad:(id)date {
    NSString * result = [[NSString alloc] initWithData:date encoding:NSUTF8StringEncoding];
    NSLog(@"successUpload2:%@",[result JSONValue]);
    [[AccountHelper getAccount] setPhotoUrl:[[[result JSONValue] objectForKey:@"result"] objectForKey:@"photoUrl"]];
    NSLog(@"success");
    [_headImageView setImage:_newImage];
    _progress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    _progress.labelText = @"成功";
    _progress.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(removeProgress) withObject:nil afterDelay:1.0f];
}

// 移除进度条 
- (void)removeProgress{
    [_progress show:NO];
    [_progress removeFromSuperview];
}

- (void)didFailedUpload:(id)date {
    NSLog(@"fail");
}

#pragma mark -
#pragma mark mail Delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

// 退出新浪时调用
- (void)sinaDidLogout{
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey: @"SinaWeiboAutoData"]);
    NSLog(@"logout sina");
}

//  重新绑定新浪账号
- (void)reBundleClicked:(UIButton *)sender{
    [[SinaHelper getHelper] setDelegate:self];
    [[SinaHelper getHelper] login];
}

// sina登陆成功
- (void)sinaDidLogin:(NSDictionary *)userInfo
{
    [[SinaHelper getHelper] getUserInfo];
    
    //    NSString *sinaID = [userInfo objectForKey: LB_SINA_USERID];
    //    NSString *sinaToken = [userInfo objectForKey: LB_SINA_TOKEN];
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"绑定成功"];
    UIView *bgText = [self.view viewWithTag:250];
    UIView *labelView = [self.view viewWithTag:251];
    [bgText removeFromSuperview];
    [labelView removeFromSuperview];
}

// sian登陆失败
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"绑定失败"];
}

//@description 当应用从后台唤起时，应调用此方法，需要完成退出当前登录状态的功能
- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo{
    
}

#pragma mark -  appstoreVC  delegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - renrenHelper
// 获取人人用户姓名回调成功
- (void)renrenHelper:(Renren *)renren requestDidReturnResponse:(ROResponse *)response{
    NSLog(@"%@",response.rootObject);
    NSDictionary *dict = [response.rootObject lastObject];
    _renRenNameLabel.text = [dict objectForKey:@"name"];
    [_settingTabelView reloadData];
}

// 获取人人用户姓名回调失败 
- (void)renrenHelper:(Renren *)renren requestFailWithError:(ROError *)error{
    NSLog(@"error  %@",error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// 注销成功 @param renren 传回代理登出接口请求的 Renren 类型对象。
- (void)renrenDidLogout:(Renren *)renren{
    _renRenNameLabel.textColor = [UIColor redColor];
    _renRenNameLabel.text = @"未绑定";
    [_mTimer invalidate]; //停掉计时器
    _mTimer = nil;
    _progress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    _progress.labelText = @"成功";
    _progress.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(removeProgress) withObject:nil afterDelay:1.0f];
}

// 登陆成功回调
- (void)renRenLoginSuccess:(id)result{
    [RenRenHelper getUserInfoTarget:self];
}

// 登陆失败回调
- (void)renRenLoginFail:(NSError *)error{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"登陆失败"];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        // 注销人人账号
        _progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _mTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(TimeRunning) userInfo:nil repeats:NO];

        [[RenRenHelper sharedInstance] logOut:self];
    }
}

- (void)TimeRunning{
    _progress.labelText = @"解绑失败";
    NSLog(@"%d", _mTimer.isValid);
    [self performSelector:@selector(removeProgress) withObject:nil afterDelay:1.0f];
}

@end
