//
//  LBTempClipView.m
//  lebo
//
//  Created by yong wang on 13-3-22.
//  Copyright (c) 2013年 lebo. All rights reserved.
//


#import "LBChannelListViewController.h"
#import "LBTempClipView.h"
#import "LBPersonalViewController.h"
#import "LBCommentViewController.h"
#import "LBPersonDetailViewController.h"
#import "LBFindViewController.h"
#import "LBTopListViewController.h"
#import "LBSinaViewController.h"
#import "LBPlayer.h"
#import "LBTableApiViewController.h"
#import "RenRenHelper.h"

#define sheetCellCount 5

@interface LBTempClipView ()<RenRenHelperDelegate>

@end

@implementation LBTempClipView
@synthesize playerVideoView = _playerVideoView;
@synthesize instructionLabel = _instructionLabel;
@synthesize timeLabel = _timeLabel;
@synthesize nameLabel = _nameLabel;
//@synthesize relayNameLabel = _relayNameLabel;
@synthesize avatarImage = _avatarImage;
@synthesize likedButton = _likedButton;
@synthesize commentButton =_commentButton;
@synthesize moreButton = _moreButton;
@synthesize imageViewBackground = _imageViewBackground;
@synthesize modelItem = _modelItem;
@synthesize leboDTO = _leboDTO;
@synthesize relayButton = _relayButton;
@synthesize recommendImageView = _recommendImageView;

#define PLAYVIEW_WIDTH 300.
#define PLAYVIEW_HEIGHT 300.
#define PLAYVIEW_HEAD 50.
#define PLAYVIEW_TAIL 40.

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createSubview];
    }
    return self;
}

+ (CGFloat)rowHeightForObject:(id)item
{
    float height = .0;
    
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        id comment = [item objectForKey:@"content"];
        
        if(comment)
        {
            NSString* instructionText = [comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if([instructionText length] > 0)
            {
                RTLabel *label = [[RTLabel alloc] initWithFrame: CGRectMake(10,10,280,10)];
                [label setText:instructionText];
                [label setFont:[UIFont systemFontOfSize:14]];
                [label setLineSpacing:5];
                
                height = 20  +  label.optimumSize.height + 5;
                
                NSRange rangeTo = [comment rangeOfString: @"#"];
                if(rangeTo.length > 0)
                {
                    height += 2;
                }
                
            }
            else{ height  = 5;}
        }
    }
    
    return PLAYVIEW_HEIGHT + PLAYVIEW_HEAD + PLAYVIEW_TAIL + height + 12;
}

- (void)layoutSubviews
{
    //UITableView
	CGSize optimumSize = [self.instructionLabel optimumSize];
	CGRect frame = [self.instructionLabel frame];
	frame.size.height = (int)optimumSize.height;
    
	[self.instructionLabel setFrame:frame];
    
    UIView *view = [self viewWithTag:10];
    
    if(view)
    {
        float height = .0;
        NSString* instructionText = [_instructionLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if([_instructionLabel.text isEqualToString:@""] || [instructionText length] <= 0)
            height = _playerVideoView.bottom;
        else
            height = self.instructionLabel.bottom + 10;
        [[self viewWithTag:10] setTop:height];
    }
    
    [self setSubviewState];
}

- (void)getChannelRange:(NSString*)comment
{
    NSRange rangeFrom = [comment rangeOfString: @"#"];
    
    if (rangeFrom.length)
    {
        [_instructionLabel setText:[NSString stringWithFormat:@"%@%@",_instructionLabel.text,[comment substringToIndex:rangeFrom.location]]];
        
        //[message stringByReplacingCharactersInRange:rangeFrom withString:@""];
        NSString *rangeText = [comment substringFromIndex:rangeFrom.location + 1];
        NSRange rangeTo = [rangeText rangeOfString: @"#"];
        if(rangeTo.length)
        {
            [_instructionLabel setText:[NSString stringWithFormat:@"%@<a #='%@'><font face=Futura size=14 color='#3F89C6'>%@</font></a>",_instructionLabel.text,[NSString stringWithFormat:@"#%@",[rangeText substringWithRange:NSMakeRange(0, rangeTo.location+ 1)]],[NSString stringWithFormat:@"#%@",[rangeText substringWithRange:NSMakeRange(0, rangeTo.location + 1)]]]];
            
            [self getChannelRange:[rangeText substringFromIndex:rangeTo.location+ 1]];
        }
        else
        {
            [_instructionLabel setText:[NSString stringWithFormat:@"%@%@",_instructionLabel.text,[comment substringFromIndex:rangeFrom.location]]];
        }
    }
    else
    {
        [_instructionLabel setText:[NSString stringWithFormat:@"%@%@",_instructionLabel.text,comment]];
    }
    
}

- (void)setObject:(id)item
{
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        self.leboDTO = [[LeboDTO alloc] init];
        if([_leboDTO parse2:item])
        {
            self.modelItem = item;
            // 备份帖子
            [_avatarImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerUrl2], _leboDTO.AuthorPhotoURL]]];
            
            if (![_leboDTO.BroadcastDisplayName isEqualToString:@""] && [_leboDTO.BroadcastDisplayName isKindOfClass:[NSString class]])
            {
                [_nameLabel setText:[NSString stringWithFormat:@"%@  <font face=Futura size=12 color='#838383'>由</font></a><a #='%@'><font face=Futura size=12 color='#3F89C6'>%@</font></a><font face=Futura size=12 color='#838383'>转播</font></a>", _leboDTO.AuthorDisplayName, _leboDTO.BroadcastDisplayName, _leboDTO.BroadcastDisplayName]];
            } else {
                [_nameLabel setText:_leboDTO.AuthorDisplayName];
            }
            
            [_playCountLabel setText:[NSString stringWithFormat:@"%d 播放",_leboDTO.PlayCount]];
            [_instructionLabel setText:@""];
            [self getChannelRange:_leboDTO.Content];
            
            [_instructionLabel setHeight:0];
            [_likedButton setTitle:_leboDTO.LoveCount == 0?@" ":[NSString stringWithFormat:@"%d",_leboDTO.LoveCount] forState:UIControlStateNormal];
            [_likedButton setImageEdgeInsets:UIEdgeInsetsMake(0,_leboDTO.LoveCount > 0?-10:0,0,0)];
            [_likedButton setImage: [UIImage imageNamed:_leboDTO.Love == 1?@"btn_like_icon_select":@"btn_like_icon"] forState:UIControlStateNormal];
            _likedButton.tag = _leboDTO.Love;
            
            [_relayButton setTitle:_leboDTO.RelayCount == 0?@" ":[NSString stringWithFormat:@"%d",_leboDTO.RelayCount] forState:UIControlStateNormal];
            [_relayButton setImageEdgeInsets:UIEdgeInsetsMake(2,_leboDTO.RelayCount > 0?-10:0,0,0)];
            [_relayButton setImage: [UIImage imageNamed:_leboDTO.Relay == 1?@"btn_relay_icon_select":@"btn_relay_icon"] forState:UIControlStateNormal];
            _relayButton.tag = _leboDTO.Relay > 0?4:3;
            
            [_commentButton setTitle:_leboDTO.CommentCount == 0?@" ":[NSString stringWithFormat:@"%d",_leboDTO.CommentCount] forState:UIControlStateNormal];
            [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0,_leboDTO.CommentCount > 0?-10:0,0,0)];
            
            [_timeLabel setText:[TimeAndLocation time: _leboDTO.SubmitTime]];
            
            //0x1e5e1db0
            [_playerVideoView setImageId:_leboDTO.PhotoURL];
            [_playerVideoView setMovieId: _leboDTO.MovieURL];
            
            if(_leboDTO.isRecommend)
            {
                [_recommendImageView removeFromSuperview];
                [_playerVideoView.contentView addSubview:_recommendImageView];
            }
        }
    }
}

- (void)updateItem:(LeboDTO*)dto
{
    [_modelItem setObject:[NSString stringWithFormat:@"%d",dto.Love] forKey:@"love"];
    [_modelItem setObject:[NSString stringWithFormat:@"%d",dto.LoveCount] forKey:@"loveCount"];
    [_modelItem setObject:[NSString stringWithFormat:@"%d",dto.Relay] forKey:@"relay"];
    [_modelItem setObject:[NSString stringWithFormat:@"%d",dto.RelayCount] forKey:@"relayCount"];
}

- (void)playVideo:(int)rowCell
{
    id selectPlayURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectPlay"];
    if(_playerVideoView == nil)
        return;
    if(_leboDTO.MovieURL && ![_leboDTO.MovieURL isEqualToString:selectPlayURL])
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"3GAutoPlay"] boolValue] || [Global checkNetWorkWifiOf3G] != 1)
        {
            [[NSUserDefaults standardUserDefaults] setObject:_leboDTO.MovieURL forKey:@"selectPlay"];
            [_playerVideoView play];
        }
    }
}

- (void)createSubview
{
    //[self setBackgroundColor:[UIColor redColor]];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
    UIImage *image = [UIImage imageNamed:@"clip_view_background.png"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    
    self.imageViewBackground =[[UIImageView alloc] initWithImage:image];
    [_imageViewBackground setFrame:CGRectMake(7, 0, 306, 100)];
    [_imageViewBackground setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ];
    [self addSubview:_imageViewBackground];
    
    UIView *tempHeadView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, PLAYVIEW_WIDTH, PLAYVIEW_HEAD)];
    [tempHeadView setBackgroundColor:[UIColor clearColor]];
    
    self.avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(7, 9, 35, 35)];
    //_avatarImage.centerY = tempHeadView.centerY;
    [_avatarImage setBackgroundColor:RGB(234, 234, 234)];
    [_avatarImage.layer setCornerRadius:2.];
    [_avatarImage setClipsToBounds:YES];
    [_avatarImage setUserInteractionEnabled:YES];
    [_avatarImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped:)]];
    [tempHeadView addSubview:_avatarImage];
    
    self.nameLabel = [[RTLabel alloc] initWithFrame:CGRectMake(_avatarImage.right + 10, 0, 300 - _avatarImage.right - 10 - 10 - 10, 20)];
    _nameLabel.top = _avatarImage.top;
    _nameLabel.delegate = self;
    _nameLabel.tag = 101;
    _nameLabel.userInteractionEnabled = YES;
    [_nameLabel setLineBreakMode:RTTextLineBreakModeClip];
    [_nameLabel setLineSpacing:1];
    [_nameLabel setTextColor:[UIColor colorWithRed:30./255. green:30./255. blue:30./255. alpha:1.0]];
    [_nameLabel setTextAlignment:UITextAlignmentLeft];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    
    [_nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped:)]];
    [tempHeadView addSubview:_nameLabel];
    
    /*
    self.relayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.right + 10, 0, 150, 20)];
    _relayNameLabel.bottom = _nameLabel.bottom;
    [_relayNameLabel setTextAlignment:UITextAlignmentLeft];
    [_relayNameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_relayNameLabel setBackgroundColor:[UIColor clearColor]];
    [_relayNameLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [_relayNameLabel setTextColor:[UIColor colorWithRed:30./255. green:30./255. blue:30./255. alpha:1.0]];
    _relayNameLabel.font=[UIFont systemFontOfSize:13];
    [tempHeadView addSubview:_relayNameLabel];
    */
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImage.right + 10, _avatarImage.bottom - 10, 150, 10)];
    [_timeLabel setTextAlignment:NSTextAlignmentLeft];
    [_timeLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [_timeLabel setBackgroundColor:[UIColor clearColor]];
    [_timeLabel setText:@""];
    [_timeLabel setTextColor:[UIColor colorWithRed:131./255. green:131./255. blue:131./255. alpha:1.0]];
    _timeLabel.font = [UIFont systemFontOfSize:10];
    [_timeLabel setAdjustsFontSizeToFitWidth:YES];
    [tempHeadView addSubview:_timeLabel];
    
    self.playCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempHeadView.width - 110, _timeLabel.top, 100, 10)];
    [_playCountLabel setTextAlignment:NSTextAlignmentRight];
    [_playCountLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [_playCountLabel setBackgroundColor:[UIColor clearColor]];
    [_playCountLabel setText:@""];
    [_playCountLabel setTextColor:[UIColor colorWithRed:131./255. green:131./255. blue:131./255. alpha:1.0]];
    _playCountLabel.font=[UIFont systemFontOfSize:10];
    [_playCountLabel setAdjustsFontSizeToFitWidth:YES];
    [tempHeadView addSubview:_playCountLabel];
    [self addSubview:tempHeadView];
    
    self.playerVideoView = [[LBMovieView alloc] initWithFrame:CGRectMake(tempHeadView.left, tempHeadView.bottom, PLAYVIEW_WIDTH, PLAYVIEW_HEIGHT)];
    _playerVideoView.backgroundColor = RGB(234, 234, 234);
    
    [self addSubview:_playerVideoView];
    
    self.instructionLabel = [[RTLabel alloc] initWithFrame:CGRectMake(_playerVideoView.left + 10, _playerVideoView.bottom + 10, _playerVideoView.width - 20, 10)];
    [_instructionLabel setBackgroundColor:[UIColor clearColor]];
    [_instructionLabel setTextColor:[UIColor colorWithRed:30./255. green:30./255. blue:30./255. alpha:1.0]];
    [_instructionLabel setText:@""];
    [_instructionLabel setFont:[UIFont systemFontOfSize:14]];
    [_instructionLabel setLineSpacing:5];
    [_instructionLabel setDelegate:self];
    _instructionLabel.tag = 102;
    [self addSubview:_instructionLabel];
    
    UIView *tempTailView = [[UIView alloc] initWithFrame:CGRectMake(_playerVideoView.left , _instructionLabel.bottom + 10, PLAYVIEW_WIDTH, PLAYVIEW_TAIL)];
    
    [tempTailView setUserInteractionEnabled:YES];
    [tempTailView setTag:10];
    [tempTailView setBackgroundColor:[UIColor clearColor]];
    
    self.likedButton = [self createButton:@selector(btnTapped:) title:@"" image:@"btn_like_icon" backGroundImage:@"btn_like_background" backGroundTapeImage:@"btn_like_background_tape"
                                    frame:CGRectMake(0, 0, 75, 40) tag:0];
    [tempTailView addSubview:_likedButton];
    
    self.commentButton = [self createButton:@selector(btnTapped:) title:@"" image:@"btn_comment_icon" backGroundImage:@"btn_comment_background" backGroundTapeImage:@"btn_comment_background_tape"
                                      frame:CGRectMake(150, 0, 75, 40) tag:2];
    [tempTailView addSubview:_commentButton];
    
    self.relayButton = [self createButton:@selector(btnTapped:) title:@"" image:@"btn_relay_icon" backGroundImage:@"btn_comment_background" backGroundTapeImage:@" btn_comment_background_tape"
                                    frame:CGRectMake(75, 0, 75, 40) tag:3];
    [tempTailView addSubview:_relayButton];
    
    self.moreButton = [self createButton:@selector(btnTapped:) title:@"" image:@"btn_more_icon" backGroundImage:@"btn_more_background" backGroundTapeImage:@"btn_more_background_tape"
                                   frame:CGRectMake(225, 0, 75, 40) tag:5];
    [tempTailView addSubview:_moreButton];
    
    [self addSubview:tempTailView];
    
    UIImage *recommendImage = [UIImage imageNamed:@"recommend"];
    self.recommendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_playerVideoView.right - recommendImage.size.width - 20, 10, recommendImage.size.width, recommendImage.size.height)];
    [_recommendImageView setImage:recommendImage];
    
    
}

- (void)rtLabel:(id)rtLabel didSelectLinkWithText:(NSString*)text
{
    if (((RTLabel *)rtLabel).tag == 102) {
        LBChannelListViewController* channelList = [LBChannelListViewController sharedInstance];
        if(channelList)
        {
            if([text rangeOfString:channelList.channelTitle].length)
            {
                return;
            }
        }
        
        [self pauseVideoClear];
        LBChannelListViewController *channelListViewController = [[LBChannelListViewController alloc] initVithChannelTitle:text];
        [selected_navigation_controller() pushViewController:channelListViewController animated:YES];
    } else
    {
        LBPersonDetailViewController *personalViewController = [[LBPersonDetailViewController alloc] initWithAccountID:_leboDTO.BroadcastAuthor];
        [selected_navigation_controller() pushViewController:personalViewController animated:YES];
    }
}

- (void)deleteCell
{
    [self pauseVideoClear];
    id model = nil;
    id viewController = (((UINavigationController *)((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController).visibleViewController);
    if([viewController isKindOfClass:[LBTableApiViewController class]])
    {
        model = ((LBTableApiViewController*)viewController).model;
    }
    else if([viewController isKindOfClass:[LBFindViewController class]])
    {
        viewController = (LBTopListViewController*)[((LBFindViewController*)viewController) getControllerArray];
        model = ((LBTableApiViewController*)viewController).model;
    }
    else if([viewController isKindOfClass:[LBPersonalViewController class]])
    {
        id controller1 = (LBPersonDetailViewController*)[((LBPersonalViewController*)viewController) getControllerArray];
        [controller1 sendCurrentAccountInfo:YES];
        
        viewController = [((LBPersonDetailViewController*)[((LBPersonalViewController*)viewController) getControllerArray]) getControllerArray];
        
        model = ((LBTableApiViewController*)viewController).model;
    }
    
    if(model && [model isKindOfClass:[NSArray class]])
    {
        [model removeObject:_modelItem];
        [((LBTableApiViewController*)viewController).tableView reloadData];
    }
}

- (void)setSubviewState
{
    NSUserDefaults *defaults = [[NSUserDefaults standardUserDefaults] objectForKey:@"SinaWeiboAuthData"];
    if(defaults)
    {
        [_avatarImage setUserInteractionEnabled:YES];
        [_commentButton setUserInteractionEnabled:YES];
        [_moreButton setUserInteractionEnabled:YES];
        [_likedButton setUserInteractionEnabled:YES];
        [_instructionLabel setUserInteractionEnabled:YES];
        [_relayButton setUserInteractionEnabled:YES];
    }
    else
    {
        [_avatarImage setUserInteractionEnabled:NO];
        [_commentButton setUserInteractionEnabled:NO];
        [_moreButton setUserInteractionEnabled:NO];
        [_likedButton setUserInteractionEnabled:NO];
        [_instructionLabel setUserInteractionEnabled:NO];
        [_relayButton setUserInteractionEnabled:NO];
    }
}

- (UIButton*)createButton:(SEL)selector title:(NSString*)title image:(NSString*)image backGroundImage:(NSString*)backGroundImage backGroundTapeImage:(NSString*)backGroundTapeImage frame:(CGRect)frame tag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTag:tag];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//    if(image && tag < 2)
//    {
//        [button setImageEdgeInsets:UIEdgeInsetsMake(0,-10,0,0)];
//    }
    [button setBackgroundImage:[UIImage imageNamed:backGroundImage] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:backGroundTapeImage] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithRed:94./255. green:94./255. blue:94./255. alpha:1.] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    //    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    //    [button.titleLabel setShadowColor:[UIColor blackColor]];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)btnTapped:(UIButton*)sender
{
    switch (sender.tag) {
        case 0:
            [self setLikedButtonState:sender like:YES];
            break;
        case 1:
            [self setLikedButtonState:sender like:NO];
            break;
        case 2:
            [self showCommentViewController];
            break;
        case 3:
            [self setRelayButtonState:sender relay:YES];
            break;
        case 4:
            [self setRelayButtonState:sender relay:NO];
            break;
        case 5:
            [self showMoreSheet];
            break;
    }
}

- (void)pauseVideoClear
{
    [LBMovieView pauseAll];
    [Global clearPlayStatus];
}

- (void)showCommentViewController
{
    [self pauseVideoClear];
    LBCommentViewController *viewController = [[LBCommentViewController alloc] initWithLeboID:_modelItem];//51420
    [selected_navigation_controller() pushViewController:viewController animated:YES];
}

- (void)setRelayButtonState:(UIButton *)sender relay:(BOOL)relay
{
    int nValue = 0;
    if(relay)
    {
        nValue = [sender.titleLabel.text intValue];
        [sender setTitle:[NSString stringWithFormat:@"%d",nValue + 1] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"btn_relay_icon_select"] forState:UIControlStateNormal];
        [sender setImageEdgeInsets:UIEdgeInsetsMake(0,-10,0,0)];
        [sender setTag:4];
    }
    else
    {
        nValue = [sender.titleLabel.text intValue] - 1;
        
        [sender setTitle:nValue == 0?@" ":[NSString stringWithFormat:@"%d", nValue] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"btn_relay_icon"] forState:UIControlStateNormal];
        [sender setImageEdgeInsets:UIEdgeInsetsMake(0,nValue > 0? -10:0,0,0)];
        [sender setTag:3];
    }
    
    [self relayVideo:_leboDTO];
}

- (void)setLikedButtonState:(UIButton *)sender like:(BOOL)like
{
    int nValue = 0;
    if(like)
    {
        nValue = [sender.titleLabel.text intValue];
        [sender setTitle:[NSString stringWithFormat:@"%d",nValue + 1] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"btn_like_icon_select"] forState:UIControlStateNormal];
        [sender setImageEdgeInsets:UIEdgeInsetsMake(0,-10,0,0)];
        [sender setTag:1];
    }
    else
    {
        nValue = [sender.titleLabel.text intValue] - 1;
        
        [sender setTitle:nValue == 0?@" ":[NSString stringWithFormat:@"%d", nValue] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"btn_like_icon"] forState:UIControlStateNormal];
        [sender setImageEdgeInsets:UIEdgeInsetsMake(0,nValue > 0? -10:0,0,0)];
        [sender setTag:0];
    }
    
    [self likedTapped:_leboDTO];
}

- (void)showMoreSheet
{
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accountID = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    
    UIActionSheet *action = nil;
    if ([accountID isEqualToString:_leboDTO.AuthorID]){
        action =  [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享视频", @"删除",nil];
        action.tag = 100;
    }
    else
    {
        action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享视频", @"举报", nil];
        action.tag = 101;
    }
    
    action.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [action showInView: self];
}

// isSceneSession == YES  为微信对话 isSceneSession == NO 为微信朋友圈
- (void)sendVideoContent:(LeboDTO *)dto
{
    LBAppDelegate *lbDelegate = (LBAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (lbDelegate && [lbDelegate respondsToSelector:@selector(sendVideoContent:title:thumbImage:videoUrl:)])
    {
        if (isSceneSession) {
            [lbDelegate changeScene:WXSceneSession];
        }else{
            [lbDelegate changeScene:WXSceneTimeline];
        }
        
        NSString *movieUrl = [NSString stringWithFormat:@"%@/?cmd=GEOWEIBOD.playFlash+%@",[Global getServerBaseUrl], self.leboDTO.MovieID];
        //        NSString *movieUrl = [NSString stringWithFormat:@"%@%@",[Global getServerBaseUrl], dto.MovieURL];
        [lbDelegate sendVideoContent:self.leboDTO.Content title:self.leboDTO.Content thumbImage:_playerVideoView.mImage videoUrl:movieUrl];
    }
}

- (void)regToLeboService:(LeboDTO *)dto{
 
}


- (void)responseSuccess:(id)result{
    NSLog(@"result  %@",result);
}

- (void)responseFail:(NSError *)error{
    NSLog(@"error  %@",error);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {
        if (buttonIndex == 0) {
            [self showAWSheet];
            //             [self shareVideo:_leboDTO];
        } else if(buttonIndex == 1) {
            [super delVideo:_leboDTO];
        }
    }else if (actionSheet.tag == 101) {
        if (buttonIndex == 0) {
            [self showAWSheet];
            //            [self shareVideo:_leboDTO];
        } else if (buttonIndex == 1) {
            [super reportVideo:_leboDTO];
        }
    }
}

- (void)avatarTapped:(UITapGestureRecognizer *)tapGesture
{
    [super avatarTapped:_leboDTO];
    //[[TKAlertCenter defaultCenter] postAlertWithMessage:@"分享成功"];
}

#pragma mark - 分享暂时没有数据连接
- (void)shareVideo:(LeboDTO *)dto
{
    [self pauseVideoClear];
    LBSinaViewController *sinaShare = [[LBSinaViewController alloc]init];
    sinaShare.isShareToSina = YES;
    sinaShare.movieTitle = dto.Content;
    sinaShare.movieUrl = [NSString stringWithFormat:@"%@/?cmd=GEOWEIBOD.playFlash+%@",[Global getServerBaseUrl], dto.MovieID];
    sinaShare.movieID = dto.MovieID;
    sinaShare.thumbImage = _playerVideoView.mImage;
    sinaShare.authorName = dto.AuthorDisplayName;
    [selected_navigation_controller() pushViewController:sinaShare animated:YES];
    NSLog(@"shareVideo");
}

- (void)sinaUpdateSuccess:(id)result{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"分享成功"];
}

- (void)sinaUpdateFail:(NSError *)error{
    NSLog(@"error  %@",error);
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"分享失败"];
}

#pragma mark - AWActionSheetDelegateAndMethod
- (void)showAWSheet{
    AWActionSheet *sheet = [[AWActionSheet alloc] initwithIconSheetDelegate:self ItemCount:[self numberOfItemsInActionSheet]];
    [sheet showInView:self];
    
    // 直接告诉服务器要播放那个视频
    [[LBFileClient sharedInstance] shareFileName:self.leboDTO.MovieID cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(movieIDResponseSuccess:) selectorError:@selector(movieIDResponseFail:)];

}

-(int)numberOfItemsInActionSheet
{
    if (![WXApi isWXAppInstalled] && ![WXApi isWXAppSupportApi])
        return sheetCellCount - 2;
    return sheetCellCount;
}

-(AWActionSheetCell *)cellForActionAtIndex:(NSInteger)index
{
    // 当isButton == YES ,cell.iconButton 需添加图片
    // 当isButton == NO，  cell.iconView  需添加图片
    AWActionSheetCell* cell = [[AWActionSheetCell alloc] initIsButton:YES];
    
    if (![WXApi isWXAppInstalled] && ![WXApi isWXAppSupportApi])
    {
        switch (index) {
            case 0:{
                [[cell iconButton] setImage:[UIImage imageNamed:@"sns_icon_sina.png"] forState:UIControlStateNormal];
                [[cell titleLabel] setText:@"新浪微博"];
                break;
            }
            case 1:{
                [[cell iconButton] setImage:[UIImage imageNamed:@"sns_icon_renren.png"] forState:UIControlStateNormal];
                [[cell titleLabel] setText:@"人人网"];
                break;
            }
            case 2:{
                [[cell iconButton] setImage:[UIImage imageNamed:@"sns_icon_copy.png"]  forState:UIControlStateNormal];
                [[cell titleLabel] setText:@"复制链接"];
                break;
            }
            case 3:{
                [[cell iconButton] setImage:[UIImage imageNamed:@"sns_icon_note.png"]  forState:UIControlStateNormal];
                [[cell titleLabel] setText:@"短信分享"];
                break;
            }
            default:{
                [[cell iconView] setBackgroundColor:
                 [UIColor colorWithRed:rand()%255/255.0f
                                 green:rand()%255/255.0f
                                  blue:rand()%255/255.0f
                                 alpha:1]];
                [[cell titleLabel] setText:[NSString stringWithFormat:@"item %d",index]];
                
                break;
            }
        }

    }
    else
    {
        switch (index) {
            case 0:{
                [[cell iconButton] setImage:[UIImage imageNamed:@"sns_icon_sina.png"] forState:UIControlStateNormal];
                [[cell titleLabel] setText:@"新浪微博"];
                break;
            }
            case 1:{
                [[cell iconButton] setImage:[UIImage imageNamed:@"sns_icon_weixin.png"] forState:UIControlStateNormal];
                [[cell titleLabel] setText:@"微信好友"];
                break;
            }
            case 2:{
                [[cell iconButton] setImage:[UIImage imageNamed:@"sns_icon_weixin_friends.png"] forState:UIControlStateNormal];
                [[cell titleLabel] setText:@"微信朋友圈"];
                break;
            }
            case 3:{
                [[cell iconButton] setImage:[UIImage imageNamed:@"sns_icon_renren.png"] forState:UIControlStateNormal];
                [[cell titleLabel] setText:@"人人网"];
                break;
            }
            case 4:{
                [[cell iconButton] setImage:[UIImage imageNamed:@"sns_icon_copy.png"]  forState:UIControlStateNormal];
                [[cell titleLabel] setText:@"复制链接"];
                break;
            }
            case 5:{
                [[cell iconButton] setImage:[UIImage imageNamed:@"sns_icon_note.png"]  forState:UIControlStateNormal];
                [[cell titleLabel] setText:@"短信分享"];
                break;
            }
            default:{
                [[cell iconView] setBackgroundColor:
                 [UIColor colorWithRed:rand()%255/255.0f
                                 green:rand()%255/255.0f
                                  blue:rand()%255/255.0f
                                 alpha:1]];
                [[cell titleLabel] setText:[NSString stringWithFormat:@"item %d",index]];
                
                break;
            }
        }
    }
    cell.index = index;
    return cell;
}

-(void)DidTapOnItemAtIndex:(NSInteger)index
{
    NSLog(@"tap on %d",index);
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        switch (index) {
            case 0:{
                [self performSelector:@selector(shareVideo:) withObject:_leboDTO afterDelay:0.0f];
                break;
            }
            case 1:{
                   isSceneSession = YES;
                [self performSelector:@selector(sendVideoContent:) withObject:_leboDTO afterDelay:0.0f];
                break;
            }
            case 2:{
                isSceneSession = NO;
                [self performSelector:@selector(sendVideoContent:) withObject:_leboDTO afterDelay:0.0f];
                break;
            }
            case 3:
            {
                [self performSelector:@selector(shareVideoToRenren:) withObject:_leboDTO afterDelay:0.0f];
                break;
            }
            case 4:{
                NSString * movieUrl = [NSString stringWithFormat:@"%@/?cmd=GEOWEIBOD.playFlash+%@",[Global getServerBaseUrl], self.leboDTO.MovieID];
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setString:movieUrl];
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"拷贝成功"];
                // 通知乐播服务器
                break;
            }
            case 5:{
                
                break;
            }
            default:
                break;
        }
    }
    else
    {
        switch (index) {
            case 0:{
                [self performSelector:@selector(shareVideo:) withObject:_leboDTO afterDelay:0.0f];
                break;
            }
            case 1:
            {
                [self performSelector:@selector(shareVideoToRenren:) withObject:_leboDTO afterDelay:0.0f];
                break;
            }
            case 2:{
                NSString * movieUrl = [NSString stringWithFormat:@"%@/?cmd=GEOWEIBOD.playFlash+%@",[Global getServerBaseUrl], self.leboDTO.MovieID];
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setString:movieUrl];
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"拷贝成功"];
                // 通知乐播服务器
                break;
            }
            case 3:{
                
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - LeBoDelegate
- (void)movieIDResponseSuccess:(id)result{
    NSLog(@"movieIDresult %@",result);
}

- (void)movieIDResponseFail:(NSError *)error{
    NSLog(@"movieIDerror %@",error);
}

#pragma mark - RenrenDelegate Method
// 复用新浪分享VC
- (void)initShareToSinaVC{
    LBSinaViewController *shareToRenRen = [[LBSinaViewController alloc] init];
    shareToRenRen.isShareToRenRen = YES;
    shareToRenRen.movieID = self.leboDTO.MovieID;
    shareToRenRen.movieUrl = [NSString stringWithFormat:@"%@/?cmd=GEOWEIBOD.playFlash+%@",[Global getServerBaseUrl], self.leboDTO.MovieID];
    shareToRenRen.movieTitle = self.leboDTO.Content;
    if (self.leboDTO.MovieID) {
        [selected_navigation_controller() pushViewController:shareToRenRen animated:YES];
    }
}

// 人人登陆
- (void)shareVideoToRenren:(LeboDTO *)dto{
    if([RenRenHelper isSessionValidTarget:self isLogin:YES]){
        [self initShareToSinaVC];
    }else{
        [LBMovieView pauseAll];
        [Global clearPlayStatus];
    }
}

// 登陆成功回调
- (void)renRenLoginSuccess:(id)result{
    [self initShareToSinaVC];
}

// 登陆失败回调
- (void)renRenLoginFail:(NSError *)error{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"登陆失败"];
}

- (void)renrenHelper:(Renren *)renren requestFailWithError:(ROError *)error
{
}

- (void)renrenHelper:(Renren *)renren requestDidReturnResponse:(ROResponse *)response
{
}

@end
