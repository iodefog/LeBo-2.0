//
//  LBPlayer.h
//  cameraDemo
//
//  Created by 乐播 on 13-3-4.
//  Copyright (c) 2013年 乐播. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "LBLayoutLayer.h"
@interface LBPlayer : AVPlayer
{
    NSURL * _url;
    AVPlayerLayer * _playerLayer;
}
@property(nonatomic,readonly) NSURL * url;
@property(nonatomic,readonly) LBLayoutLayer * layer;

+ (id)sharedPlayer;

- (id)initWithURL:(NSURL *)url;

- (void)setURL:(NSURL *)url;

- (void)stop;
@end
