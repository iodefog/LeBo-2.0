    //
//  LBAppDelegate.m
//  lebo
//
//  Created by yong wang on 13-3-21.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBAppDelegate.h"
#import "LBMainAppViewController.h"
#import "LBAppearance.h"
#import "LBLoginViewController.h"
#import "LBHarpy.h"
#import "LBMainAppViewController.h"
#import "MobClick.h"
#import "LeBoImagePicker.h"

// sina
#define kAppKey             @"2274665609"
#define kAppSecret          @"62b23290002d54e83f66500e20d9b05b"
#define kAppRedirectURI     @"http://lebooo.com/yes"
#define sinaSource          @"com.sina.weibo"
// weixin
#define APPID               @"wx838c5a7df779191b"
#define APPKEY              @"2a47f23a9fad6275e84bbd5aca56bbac"
#define weixinSource        @"com.tencent.xin"
// renren
#define renAPPID            @"232244"
#define renAPIKEY           @"6ca58e3d6dee4ec39bdeb0cbddd701b9"
#define renSecretKey        @"a14173d129784a3c9324c8b4a6016cf1"

@implementation LBAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize sinaweibo = _sinaweibo;

- (id)init{
    if (self = [super init]) {
        _scene = WXSceneSession;
    }
    return self;
}

+ (LBAppDelegate*)shareInstance{
    
    return (LBAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (id)returnMainVC{
    return mainController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [LBAppearance setLBAppearance];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    
    _sinaweibo = [[SinaWeibo alloc]initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate: [SinaHelper getHelper]];
    
    mainController = [[LBMainAppViewController alloc] init];
    
    //if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"account"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"session"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"token"])
    {
        // 读取缓存
        _sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        _sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        _sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
        [self.window setRootViewController:mainController];
    }
    else
    {
        LBLoginViewController *rvc = [[LBLoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:rvc];
        [self.window setRootViewController:nav] ;
    }
    
    
    [MobClick startWithAppkey:@"51219c66527015480400001a" reportPolicy:0 channelId:nil];
    // 向微信注册
    [WXApi registerApp:APPID];
    // 版本提醒
    [LBHarpy checkVersion];
    
    //第一次
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
     
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)changedRootVC{
    
    LBMainAppViewController *rootViewController = [[LBMainAppViewController alloc] init];
    [self.window setRootViewController:rootViewController];
    
    [[LBFileClient sharedInstance] getShareTextAndImage:nil cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(shareFileSuccess:) selectorError:@selector(shareFileFail:)];

    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
}

- (void)changedRootVCToLogin{
    [[SinaHelper getHelper] setDelegate:self];
    [[SinaHelper getHelper] logout];
    LBLoginViewController *rvc = [[LBLoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:rvc];
    [self.window setRootViewController:nav] ;
}

- (void)shareFileSuccess:(id)result{
    NSString *mResult = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"shareFile:%@", mResult);
    NSArray *resultArray = [[mResult JSONValue] objectForKey:@"result"];
    NSString *publishText = nil;
    NSString *imageUrl = nil;
    NSString *inviteText = nil;
    NSString *shareText = nil;
    if (resultArray.count >= 3) {
        publishText = [[resultArray objectAtIndex:0] objectForKey:@"publishText"];
        imageUrl = [[resultArray objectAtIndex:1] objectForKey:@"imageUrl"];
        inviteText = [[resultArray objectAtIndex:1] objectForKey:@"inviteText"];
        shareText = [[resultArray objectAtIndex:2] objectForKey:@"shareText"];
    }
   
    NSDate *updateDate = [NSDate date];
    
    NSMutableDictionary *fileDict =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"shareData"]];
    if (fileDict.count == 0) {
        fileDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:publishText, @"publishText", imageUrl, @"imageUrl",inviteText, @"inviteText",shareText ,@"shareText",updateDate, @"updateDate", nil];
        [[NSUserDefaults standardUserDefaults] setObject:fileDict forKey:@"shareData"];
        NSURLRequest *mRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
        mImageData = [[NSMutableData alloc] init];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:mRequest delegate:self];
        [connection start];
    } else {
       
        if (![[fileDict objectForKey:@"imageUrl"] isEqualToString:imageUrl]) {
            fileDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:publishText, @"publishText", imageUrl, @"imageUrl",inviteText, @"inviteText",shareText ,@"shareText",updateDate, @"updateDate", nil];
            if (imageUrl) {
                [fileDict setObject:imageUrl forKey:@"imageUrl"];
            }
            NSURLRequest *mRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
            mImageData = [[NSMutableData alloc] init];
            NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:mRequest delegate:self];
            [connection start];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"shareData"];
            [[NSUserDefaults standardUserDefaults] setObject:fileDict forKey:@"shareData"];
        }
    }
    
    NSLog(@"%@ %@ %@ %@ %@",publishText, imageUrl, inviteText , shareText, updateDate);
    NSLog(@"shareFileSuccess resultDict %@",resultArray);
}

- (void)shareFileFail:(NSError *)error{
    NSLog(@"shareFileFail error %@",error);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"回应成功");
    [mImageData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [mImageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSMutableDictionary *fileDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"shareData"]];
    [fileDict removeObjectForKey:@"imageData"];
    [fileDict setObject:mImageData forKey:@"imageData"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"shareData"];
    [[NSUserDefaults standardUserDefaults] setObject:fileDict forKey:@"shareData"];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"shareData"]);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    application.applicationIconBadgeNumber = 0;//外部提示清0
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;//外部提示清0
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"account"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"session"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"token"])
    {
        [[LBFileClient sharedInstance] getShareTextAndImage:nil cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(shareFileSuccess:) selectorError:@selector(shareFileFail:)];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.sinaweibo handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL mm = NO;
    if ([sourceApplication isEqualToString:sinaSource]) {
        mm = [self.sinaweibo handleOpenURL:url];
    }
    else if ([sourceApplication isEqualToString:weixinSource]){
    [WXApi handleOpenURL:url delegate:self];
    }
    return mm;
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken %@", deviceToken);
    //
    NSString *tokenStr = [deviceToken description];
    NSString *pushToken = [[[tokenStr
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *localToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    if ([pushToken isEqualToString:localToken] == NO) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"bindDevice"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:pushToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (mainController != nil && [mainController respondsToSelector:@selector(bindDeviceToken:)] == YES) {
        [mainController performSelector:@selector(bindDeviceToken:) withObject:[AccountHelper getAccount]];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive)
    {
        [selected_navigation_controller() popToRootViewControllerAnimated:YES];
        [selected_navigation_controller() dismissViewControllerAnimated:YES completion:^{
            [self changeToMsgView];
        }];
        
        [self changeToMsgView];
    }
    
    LBMainAppViewController *mainViewController = (LBMainAppViewController*)self.window.rootViewController;
    
    if ([mainViewController respondsToSelector:@selector(postMessage)] == YES && ![[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [((LBMainAppViewController*)self.window.rootViewController) postMessage];
    }
}

- (void)changeToMsgView
{
    LBMainAppViewController *mainViewController =  (LBMainAppViewController*)self.window.rootViewController;
    
    if ([mainViewController respondsToSelector:@selector(changeVCToMessageVC)] == YES) {
        [((LBMainAppViewController*)self.window.rootViewController) changeVCToMessageVC];
    }
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"lebo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"lebo.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - 微信 method
// 发视频到微信好友回调
-(void) onResp:(BaseResp*)resp
{
    NSLog(@"微信发送完毕,  返回时调用!");
//    if([resp isKindOfClass:[SendMessageToWXResp class]])
//    {
//        NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"发送媒体消息结果:%d", resp.errCode];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//    else if([resp isKindOfClass:[SendAuthResp class]])
//    {
//        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"Auth结果:%d", resp.errCode];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    
}

-(void) sendVideoContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"步步惊奇";
    message.description = @"只能说胡戈是中国广告界的一朵奇葩！！！这次真的很多人给跪了、、、";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = @"http://www.tudou.com/programs/view/6vx5h884JHY/?fr=1";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}


// 发视频到微信好友
-(void) sendVideoContent:(NSString *)content title:(NSString *)title thumbImage:(UIImage *)thumbImage videoUrl:(NSString *)videoUrl
{
//    [self sendVideoContent];
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"乐播-6秒视频";
    message.description = content;
    
//    if (![WXApi isWXAppInstalled]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还未安装微信" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
//    if (![WXApi isWXAppSupportApi]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的微信版本不支持分享" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }

    // 压缩视频缩略图 wx上传图片需小于32k
    LeBoImagePicker *picker = [[LeBoImagePicker alloc] init];
   NSData *data = [picker compressImage:thumbImage PixelCompress:YES MaxPixel:200 JPEGCompress:YES MaxSize_KB:32.0f];
    
    NSLog(@"%f",data.length/1024.0f);
    message.thumbData = data;
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = videoUrl;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

//切换 分享到对话或者是朋友圈
-(void) changeScene:(NSInteger)scene{
    _scene = scene;
}

@end
