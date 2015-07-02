//
//  LBAppDelegate.h
//  lebo
//
//  Created by yong wang on 13-3-21.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMainAppViewController.h"
#import "WXApi.h"

@interface LBAppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate , NSURLConnectionDataDelegate>
{
    LBMainAppViewController *mainController;
    enum WXScene _scene;
    NSMutableData *mImageData;   // 用来下载一张图而已
}

@property (strong, nonatomic) UIWindow *window; 
@property (strong, nonatomic) SinaWeibo *sinaweibo;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
 
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void) sendVideoContent:(NSString *)content title:(NSString *)title thumbImage:(UIImage *)thumbImage videoUrl:(NSString *)videoUrl;
-(void) changeScene:(NSInteger)scene;
+ (LBAppDelegate*)shareInstance;
- (id)returnMainVC;

@end
