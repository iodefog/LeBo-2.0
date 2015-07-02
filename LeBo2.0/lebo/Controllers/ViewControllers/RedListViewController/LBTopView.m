
//
//  LBTopView.m
//  lebo
//
//  Created by King on 13-4-18.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBTopView.h"
#import "Global.h"
#import "TopDTO.h"
#import "LBPersonDetailViewController.h"

@implementation LBTopView
@synthesize avatarImage = _avatarImage;
@synthesize nameLabel = _nameLabel;
@synthesize numberLabel = _numberLabel;
@synthesize signLabel = _signLabel;
@synthesize attendBtn = _attendBtn;
@synthesize modelItem = _modelItem;
@synthesize topLabel = _topLabel;
@synthesize lineImageView = _lineImageView;

static CGFloat rotHeight = 80.;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self createUI];
    }
    return self;
}

+ (CGFloat)rowHeightForObject:(id)item
{
    return 52.;
    int instrutionHeight = 0.;
    if(item && [item isKindOfClass:[NSDictionary class]])
    {
        TopDTO *msg = [[TopDTO alloc] init];
        if([msg parse2:item])
        {
            if(msg.Sign && msg.Sign .length > 0)
            {
                RTLabel *rtLabel = [[RTLabel alloc] initWithFrame:CGRectMake(
                                    0, 0, 280, 14.)];
                [rtLabel setText: msg.Sign];
                [rtLabel setFont:[UIFont systemFontOfSize:14]];
                [rtLabel setLineSpacing: 5];
                CGSize optimumSize = [rtLabel optimumSize];
                instrutionHeight = optimumSize.height;
            }
            else
            {
                return rotHeight + 12;
            }
        }
    }
    
    return rotHeight + 20 + instrutionHeight;
}

- (void)createUI
{   
    [self setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    self.avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 6, 40, 40)];
    [_avatarImage.layer setCornerRadius:2.0];
    _avatarImage.clipsToBounds = YES;
    [_avatarImage setBackgroundColor:RGB(234, 234, 234)];
    [self addSubview:_avatarImage];
    
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, 25, 18)];
    [_topLabel setTextAlignment:UITextAlignmentCenter];
    [_topLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_topLabel];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImage.right + 10 , _avatarImage.top + 1, 100, 16)];
    [_nameLabel setTextAlignment:UITextAlignmentLeft];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    [_nameLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_nameLabel];
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImage.right + 10, _avatarImage.bottom - 16, 150, 14)];
    [_numberLabel setTextAlignment:UITextAlignmentLeft];
    [_numberLabel setTextColor:[UIColor colorWithRed:94. green:94. blue:94.]];
    [_numberLabel setBackgroundColor:[UIColor clearColor]];
    [_numberLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:_numberLabel];
    /*
    self.signLabel = [[RTLabel alloc] initWithFrame:CGRectMake(_avatarImage.right + 10, _avatarImage.bottom + 10, 220, 200.)];
    [_signLabel setBackgroundColor:[UIColor clearColor]];
    [_signLabel setTextColor:[UIColor colorWithRed:30./255. green:30./255. blue:30./255. alpha:1.0]];
    [_signLabel setText:@""];
    [_signLabel setFont:[UIFont systemFontOfSize:14.]];
    [_signLabel setLineSpacing:5];
    [self addSubview:_signLabel];
    */
    
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 2)];
    [_lineImageView setImage:[[UIImage imageNamed:@"sperateLine"] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
    [self addSubview:_lineImageView];
    
    self.attendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _attendBtn.frame = CGRectMake(260, 16, 50, 31);
    _attendBtn.centerY =_avatarImage.centerY;
    [_attendBtn setBackgroundColor:[UIColor clearColor]];
    [_attendBtn addTarget:self action:@selector(attend:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_attendBtn];
    
    [self setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
}

- (void)attend:(UIButton *)btn
{
    if (dto.Attended == 0) {
        dto.Attended = 1;
        [client follow:dto.AccountID cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(followDidFinished:) selectorError:@selector(followDidFailed:)];
        [_attendBtn setImage:[UIImage imageNamed:@"cell_did_add"] forState:UIControlStateNormal];
        [_attendBtn setBackgroundImage:[[UIImage imageNamed:@"btn_followed_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateNormal];
    } else {
        dto.Attended = 0;
        [client unFollow:dto.AccountID cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:self selector:@selector(unFollowDidFinished:) selectorError:@selector(unFollowDidFailed:)];
        [_attendBtn setImage:[UIImage imageNamed:@"cell_add"] forState:UIControlStateNormal];
        [_attendBtn setBackgroundImage:[[UIImage imageNamed:@"invite"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 8, 14, 8)] forState:UIControlStateNormal];
    }
    [self.modelItem setObject:[NSString stringWithFormat:@"%d",dto.Attended] forKey:@"attended"];;
}

- (void)setObject:(id)item topViewIndex:(uint)topViewIndex row:(int)row
{
    if (item && [item isKindOfClass:[NSDictionary class]])
    {
        dto = [[TopDTO alloc] init];
        if(![dto parse2:item]){
            return;
        }
        self.modelItem = item;
        [_topLabel setText:[NSString stringWithFormat:@"%d", row+1]];
        
        if (row < 3) {
            _topLabel.textColor = RGB(255, 0, 0);
            _topLabel.font = [UIFont systemFontOfSize:18.0];
        } else {
            [_topLabel setTextColor:RGB(133, 133, 133)];
            [_topLabel setFont:[UIFont systemFontOfSize:12.0]];
        }
        
        [_avatarImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Global getServerBaseUrl], dto.PhotoUrl]]];
        [_nameLabel setText:dto.DisplayName];
        //[_signLabel setText:dto.Sign];
        if (topViewIndex == 1)
        {
            [_numberLabel setText:[NSString stringWithFormat:@"粉丝: %d", dto.FansCount]];
        }
        else if (topViewIndex == 2)
        {
            [_numberLabel setText:[NSString stringWithFormat:@"收到喜欢: %d", dto.TotalLoveCount]];
        }
        else
        {
            [_numberLabel setText:[NSString stringWithFormat:@"总播放: %d", dto.TotalPlayCount]];
        }
        
        if (dto.Attended) {
            [_attendBtn setImage:[UIImage imageNamed:@"cell_did_add"] forState:UIControlStateNormal];
            [_attendBtn setBackgroundImage:[[UIImage imageNamed:@"btn_followed_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 8, 14, 8)] forState:UIControlStateNormal];
            [_attendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        } else {
            [_attendBtn setImage:[UIImage imageNamed:@"cell_add"] forState:UIControlStateNormal];
            [_attendBtn setBackgroundImage:[[UIImage imageNamed:@"invite"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateNormal];
            [_attendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        if ([dto.AccountID isEqualToString:[[AccountHelper getAccount] AccountID]]) {
            _attendBtn.hidden = YES;
        } else
            _attendBtn.hidden = NO;
    }
}

- (void)followDidFinished:(NSData*)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",[json_string JSONValue]);
}

- (void)unfollowDidFinished:(NSData*)data
{
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",[json_string JSONValue]);
}

- (void)followDidFailed:(NSData*)data
{

}

- (void)unfollowDidFailed:(NSData*)data
{

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    } else {
        return YES;
    }
    return YES;
}

- (void)tapGesture:(UITapGestureRecognizer*)gesture
{
    LBPersonDetailViewController *personalViewController = [[LBPersonDetailViewController alloc] initWithAccountID:dto.AccountID];
    [selected_navigation_controller() pushViewController:personalViewController animated:YES];
}

@end
