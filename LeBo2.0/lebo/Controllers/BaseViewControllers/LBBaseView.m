//
//  LBBaseView.m
//  lebo
//
//  Created by King on 13-3-29.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBBaseView.h"
#import "LBFileClient.h"
#import "LBPersonDetailViewController.h"

@implementation LBBaseView
@synthesize selectDto = _selectDto;
@synthesize progressHUD = _progressHUD;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        client = [LBFileClient sharedInstance];
    }
    return self;
}

- (void)likedTapped:(LeboDTO *)dto
{
    nType = 2;
    self.selectDto = dto;
    [client loveTopic:dto.LeboID cachePolicy:NSURLRequestReloadRevalidatingCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
}

- (void)delVideo:(LeboDTO *)dto
{
    nType = 0;
    self.selectDto = dto;
    [client deleteTopic:dto.LeboID cachePolicy:NSURLRequestReloadRevalidatingCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
    _progressHUD.labelText = @"正在删除...";
    [_progressHUD show:YES];
    
}

- (void)reportVideo:(LeboDTO *)dto
{
    nType = 1;
    self.selectDto = dto;
    [client reportAccount:[NSArray arrayWithObjects:dto.AuthorID, dto.LeboID, nil] cachePolicy:NSURLRequestReloadRevalidatingCacheData delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
    NSLog(@"reportVideo");
}

- (void)pauseVideoClear
{
    //override
}

- (BOOL)isCurUserPage:(LeboDTO *)dto
{
    if(dto == nil || [dto.AuthorID isEqualToString:@""])
    {
        return NO;
    }
    
    id curAccount = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    if(curAccount && [curAccount isKindOfClass:[NSString class]])
    {
        if([curAccount isEqualToString:dto.AuthorID])
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)avatarTapped:(LeboDTO *)dto
{
    LBPersonDetailViewController* detailView = [LBPersonDetailViewController sharedInstance];
    if(detailView)
    {
        if([dto.AuthorID isEqualToString:detailView.currentAccount])
        {
            return;
        }
    }

    [self pauseVideoClear];
    LBPersonDetailViewController *personalViewController = [[LBPersonDetailViewController alloc] initWithAccountID:dto.AuthorID];
    [selected_navigation_controller() pushViewController:personalViewController animated:YES];
    NSLog(@"avatarTapped");
}

- (void)relayVideo:(LeboDTO *)dto
{
    nType = 3;
    self.selectDto = dto;
    
    [[LBFileClient sharedInstance] broadcastTopic:dto.LeboID cachePolicy:NSURLRequestReloadIgnoringCacheData  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
}

//
//- (void)broadcastDidFinishLoad:(NSData *)data
//{
//    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", [json_string JSONValue]);
//    if(json_string.length > 0)
//    {
//        id responseObject = [[json_string JSONValue] objectForKey:@"error"];
//        if(responseObject)
//        {
//            if([responseObject isKindOfClass:[NSString class]] && [responseObject isEqualToString:@"OK"])
//            {
//                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"转载成功"];
//            }
//        }
//    }
//}
//
//- (void)broadcastError:(NSData *)data
//{
//    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", [json_string JSONValue]);
//}

#pragma mark -
- (void)requestDidFinishLoad:(NSData*)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", [json_string JSONValue]);
    
    if(json_string.length > 0)
    {
        id responseObject = [[json_string JSONValue] objectForKey:@"error"];
        if(responseObject)
        {
            if([responseObject isKindOfClass:[NSString class]] && [responseObject isEqualToString:@"OK"])
            {
                id array = [[json_string JSONValue] objectForKey:@"result"];
                if(nType == 0)
                {
                    _progressHUD.labelText = @"删除成功";
                    [self deleteCell];
                 
                    [self performSelector:@selector(disMissProgressHud:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5];
                }
                else if (nType == 1)
                {
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"举报成功"];
                }
                else if(nType == 2)
                {
                    [self.selectDto setLoveCount:[[array objectForKey:@"loveCount"] intValue]];
                    [self.selectDto setLove:[[array objectForKey:@"love"] intValue]];
                    [self updateItem:self.selectDto];
                }
                else if(nType == 3)
                {
                    [self.selectDto setRelayCount:[[array objectForKey:@"relayCount"] intValue]];
                    [self.selectDto setRelay:[[array objectForKey:@"relay"] intValue]];
                    [self updateItem:self.selectDto];
//                    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"转载成功"];
                }
                NSLog(@"success");
            }
        }
    }
    else {
        [self requestError:nil];
    }
}

- (void)disMissProgressHud:(BOOL)hide
{
    [_progressHUD setHidden:YES];
}

- (void)deleteCell
{
    //override
}

- (void)requestError:(NSError *)data{
    if(nType == 0)
    {
        _progressHUD.labelText = @"删除失败";
        [self performSelector:@selector(disMissProgressHud:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.5];
    }
    else if(nType == 3)
    {
        _progressHUD.labelText = @"转载失败";
        [self performSelector:@selector(disMissProgressHud:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.5];
    }
}

- (void)updateItem:(LeboDTO*)dto
{
    NSLog(@"override");
}

@end
