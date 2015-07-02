//
//  LBLoginViewController.m
//  lebo
//
//  Created by yong wang on 13-3-26.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBLoginViewController.h"
#import "LBTopListViewController.h"
#import "LBAppDelegate.h"
#import "LBFileClient.h"
#import "AccountDTO.h"
#import "AccountHelper.h"
#import "SinaHelper.h"
#import "TKAlertCenter.h"

@interface LBLoginViewController ()

@end

@implementation LBLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //if()
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        // 这里判断是否第一次
        beginScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        beginScroll.backgroundColor = [UIColor blackColor];
        beginScroll.pagingEnabled = YES;
        beginScroll.delegate = self;
        beginScroll.showsHorizontalScrollIndicator = NO;
        beginScroll.contentSize = CGSizeMake(self.view.frame.size.width * 4, self.view.frame.size.height);
        [self.view addSubview:beginScroll];
        
        NSArray *images = [[NSArray alloc] initWithObjects:@"begin_one.png", @"begin_two.png", @"begin_three.png", @"begin_four.png", nil];
        for (int i = 0; i<4; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*320, 0, self.view.frame.size.width, self.view.frame.size.height)];
            imageView.image = [UIImage imageNamed:[images objectAtIndex:i]];
            imageView.tag = 996 + i;
            [beginScroll addSubview:imageView];
        }
        
        UIImageView *lastView = (UIImageView *)[self.view viewWithTag:999];
        lastView.userInteractionEnabled = YES;
        UIButton *lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
        lastButton.frame = CGRectMake(12.5, self.view.frame.size.height - 130, 295, 92);
        [lastButton setImage:[UIImage imageNamed:@"begin_button.png"] forState:UIControlStateNormal];
        [lastButton addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
        [lastView addSubview:lastButton];
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 55, 320, 20)];
        pageControl.numberOfPages = 4;
        [self.view addSubview:pageControl];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }

    [self createUI];
	// Do any additional setup after loading the view.
}

- (void)sinaGetUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"user info: %@", userInfo);
    
    //if (userInfo != nil) {
    //微博
    [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"screen_name"] forKey:@"screen_name"];
    [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"gender"] forKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"avatar_large"] forKey:@"avatar_large"];
    [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"description"] forKey:@"description"];
    
    //}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    pageControl.currentPage = beginScroll.contentOffset.x / 320;
}

- (void)createUI
{
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.title = @"乐播·热门";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bottom_background"]];
    [imageView setFrame:CGRectMake(0, screenSize().height - 88, screenSize().width, 44)];
    [imageView setUserInteractionEnabled:YES];
    
    UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sinaButton setBackgroundImage: [ImageCenter getBundleImage:@"btn_sina_background.png"] forState:UIControlStateNormal];
    [sinaButton setBackgroundImage:[ImageCenter getBundleImage:@"btn_sina_background_tape"] forState:UIControlStateHighlighted];
    sinaButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [sinaButton setTitle:@"使用新浪微博账号，一键登录" forState:UIControlStateNormal];
    sinaButton.titleLabel.shadowColor = [UIColor blackColor];
    sinaButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    sinaButton.titleEdgeInsets = UIEdgeInsetsMake(0, 32, 0, 0);
    [sinaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sinaButton setFrame: CGRectMake(6, 4, 308, 38)];
    [sinaButton addTarget:self action:@selector(weiboClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:sinaButton];
    [self.view addSubview:imageView]; 
 
    LBTopListViewController *topListViewController = [LBTopListViewController sharedInstance];
    
    [self addChildViewController:topListViewController];
    [topListViewController setRefresh:NO];
    [self transitionFromViewController:topListViewController toViewController:topListViewController duration:4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
    }  completion:^(BOOL finished) {
     
    }];
    
    [topListViewController.tableView setFrame:CGRectMake(0, 0, screenSize().width, screenSize().height - 44)];
    [self.view addSubview:topListViewController.tableView];
}

//微博登陆
- (void)weiboClick
{
    [self.view endEditing:YES];
    
    [[SinaHelper getHelper] setDelegate: self];
    [[SinaHelper getHelper] login];
}

#pragma mark - Delegate for SinaHelper

- (void)sinaDidLogin:(NSDictionary *)userInfo
{
    [[SinaHelper getHelper] getUserInfo];
    
    _sinaID = [userInfo objectForKey: LB_SINA_USERID];
    _sinaToken = [userInfo objectForKey: LB_SINA_TOKEN];
    
    [[NSUserDefaults standardUserDefaults] setObject:_sinaID forKey:@"ID"];
    [[NSUserDefaults standardUserDefaults] setObject:_sinaToken forKey:@"Token"];
    LBFileClient *client = [LBFileClient sharedInstance];
    
    [client loginBySinaToken:[NSArray arrayWithObjects:@"", _sinaID, _sinaToken, nil] cachePolicy:NSURLRequestReloadIgnoringCacheData  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
    
    //[self loginBySinaToken];
    progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:progressHUD];
    progressHUD.delegate = self;
    progressHUD.labelText = @"正在加载...";
//    [progressHUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [progressHUD show:YES];
}

- (void)getAccountInfo {
    
}

- (void)loginBySinaToken {
    NSString *ID = [[NSUserDefaults standardUserDefaults] objectForKey:@"ID"];
    NSString *TOKEN = [[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
    if (ID && TOKEN) {
        LBFileClient *client = [LBFileClient sharedInstance];
        [client loginBySinaToken:[NSArray arrayWithObjects:@"", ID, TOKEN, nil] cachePolicy:NSURLRequestReloadIgnoringCacheData  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
        //[[TKAlertCenter defaultCenter] postAlertWithMessage:@"登陆"];
    } else {
        //[[TKAlertCenter defaultCenter] postAlertWithMessage:@"请重新登陆"];
    }
}

// 登陆失败
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
     //[[TKAlertCenter defaultCenter] postAlertWithMessage:@"登陆失败"];
}

//@description 当应用从后台唤起时，应调用此方法，需要完成退出当前登录状态的功能
- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo{
    
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
            if([responseObject isKindOfClass:[NSString class]] && ([responseObject isEqualToString:@"NEXT"] || [responseObject isEqualToString:@"AGAIN"])) {
                
                [NSTimer scheduledTimerWithTimeInterval:[[[json_string JSONValue] objectForKey:@"wait"] integerValue] target:self selector:@selector(waitLogin) userInfo:nil repeats:NO];
                
                return;
            }
            
            if([responseObject isKindOfClass:[NSString class]] && [responseObject isEqualToString:@"ERROR"])
            {
                NSLog(@"login ERROR");
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"登陆失败，请重新登录"];
                [progressHUD setHidden:YES];
            }
            
            if([responseObject isKindOfClass:[NSString class]] && [responseObject isEqualToString:@"OK"])
            {
                LBAppDelegate *delegate = (id)[UIApplication sharedApplication].delegate;
                if ([delegate respondsToSelector:@selector(changedRootVC)]) {
                    [delegate performSelector:@selector(changedRootVC)];
                    [progressHUD show:NO];
                    [progressHUD removeFromSuperview];
                }
                
                //[[TKAlertCenter defaultCenter] postAlertWithMessage:@"登陆成功"];
                
                AccountDTO *dto = [[AccountDTO alloc] init];
                [dto parse:[json_string JSONValue]];
                [AccountHelper setAccount:dto];
                [AccountHelper save];
                
                [[NSUserDefaults standardUserDefaults] setObject:[json_string JSONValue] forKey:@"dto"];
                
                [[NSUserDefaults standardUserDefaults] setObject:[[AccountHelper getAccount] DisplayName] forKey:@"name"];
                [[NSUserDefaults standardUserDefaults] setObject:[[AccountHelper getAccount] Token] forKey:@"token"];
                [[NSUserDefaults standardUserDefaults] setObject:[[AccountHelper getAccount] SessionID] forKey:@"session"];
                [[NSUserDefaults standardUserDefaults] setObject:[[AccountHelper getAccount] AccountID] forKey:@"account"];
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:[AccountHelper getAccount].PhotoUrl forKey:@"photoUrl"];
                [dict setObject:[AccountHelper getAccount].Sign forKey:@"sign"];
                [dict setObject:[AccountHelper getAccount].CommentMode forKey:@"commentMode"];
                [dict setObject:[AccountHelper getAccount].FansMode forKey:@"fansMode"];
                [dict setObject:[AccountHelper getAccount].LoveMode forKey:@"loveMode"];
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"partAccountDTO"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"%@ %@", dto, [[AccountHelper getAccount] DisplayName]);
                
                [AccountHelper loginDidChange];
            }
        }
    }
    else {
        [self requestError:nil];
    }
}

- (void)requestError:(NSError *)data {
    NSLog(@"%@", data);
    [progressHUD setHidden:YES];
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"登陆失败，请重新登录"];
    NSLog(@"ERROR");
}

- (void)waitLogin {
    LBFileClient *client = [LBFileClient sharedInstance];
    [client waitLoginBySinaToken:[NSArray arrayWithObjects:@"", _sinaID, _sinaToken, nil] cachePolicy:NSURLRequestReloadIgnoringCacheData  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
}

- (void)setObject:(id)item {
    AccountDTO *dto = [[AccountDTO alloc] init];
    [dto parse:item];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
