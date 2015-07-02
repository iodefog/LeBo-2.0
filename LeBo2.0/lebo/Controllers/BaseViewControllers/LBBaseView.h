//
//  LBBaseView.h
//  lebo
//
//  Created by King on 13-3-29.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBFileClient.h"
#import "LeboDTO.h"

@interface LBBaseView : UIView
{
    LBFileClient *client;
    uint nType;
}

@property (nonatomic, retain) LeboDTO *selectDto;
@property (nonatomic, retain) MBProgressHUD *progressHUD;

- (void)reportVideo:(LeboDTO *)dto;
- (void)delVideo:(LeboDTO *)dto;
- (void)avatarTapped:(LeboDTO *)dto;
- (void)likedTapped:(LeboDTO *)dto;
- (void)updateItem:(LeboDTO*)dto;
- (void)deleteCell;
- (void)pauseVideoClear;
- (void)relayVideo:(LeboDTO *)leboID;
@end
