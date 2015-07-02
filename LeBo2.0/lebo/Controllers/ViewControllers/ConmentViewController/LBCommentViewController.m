//
//  LBCommentViewController.m
//  lebo
//
//  Created by Zhuang Qiang on 3/28/13.
//  Copyright (c) 2013 lebo. All rights reserved.
//

#import "LBCommentViewController.h"
#import "LBCommentCell.h"
#import "LBFileClient.h"

#define kStatusBarHeight 20
#define kDefaultToolbarHeight 44
#define kKeyboardHeightPortrait 216
#define kKeyboardHeightLandscape 140

@interface LBCommentViewController ()

@end

@implementation LBCommentViewController
@synthesize leboID = _leboID;
@synthesize topicID = _topicID;
@synthesize toCommentUser = _toCommentUser;
@synthesize keyboardIsVisible = _keyboardIsVisible;
@synthesize inputToolbar = _inputToolbar;
@synthesize upperView = _upperView;
@synthesize replyLabel = _replyLabel;
@synthesize modelItem = _modelItem;
@synthesize commentTo = _commentTo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithLeboID:(id)item
{
    self = [super init];
    if(self)
    {
        self.modelItem = item;
        self.leboID = [item objectForKey:@"leboID"];
        [self setHidesBottomBarWhenPushed:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.enableFooter = NO;
    self.enableHeader = YES;
    [self.tableView setBackgroundColor:[UIColor colorWithRed:244/255.0f green:244/255.0 blue:244/255.0 alpha:1.0f]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithTitle:@"返回" image:@"general_back.png" target:self action:@selector(back)];
    [self.navigationItem setTitle:@"评论"];
    // 加载输入框与回复提示框
    [self loadUpperView];
    
    self.topicID = @"";
    self.toCommentUser = @"";
    [self checkUpperView];
}

- (void)back{
    [Global clearPlayStatus];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getLeboID:(BOOL)more
{
    NSString *commentID = @"";
    if (more) {
        if([self.model count] > 0 && [self.model isKindOfClass:[NSArray class]])
        {
            commentID = [self.model[[self.model count] -1] objectForKey:@"commentID"];
            
            if (!commentID) {
                commentID = @"";
            }
        }
    } else {
        commentID = @"";
    }
    
    return commentID;
}

- (Class)cellClass {
    return [LBCommentCell class];
}

- (API_GET_TYPE)modelApi
{
    return API_GET_COMMENT_LIST;
}

- (void)loadData:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
   
    LBFileClient *client = [LBFileClient sharedInstance];
  
    [client getCommentList:[NSArray arrayWithObjects:_leboID, @"20", [self getLeboID:more], nil] cachePolicy:NSURLRequestReloadIgnoringCacheData  delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestError:)];
}

- (void)didFinishLoad:(id)array
{
    [super didFinishLoad:array];
}

- (void)loadUpperView
{
//    [self.tableView setBackgroundColor:[UIColor blackColor]];
    
    [super reloadData];
    
     _keyboardIsVisible = NO;
    [self.tableView setHeight:self.tableView.height - 40];
    
    /* Calculate screen size */
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    /* Create toolbar */
//    CGRect w = CGRectMake(0, screenFrame.size.height-kDefaultToolbarHeight-44-20, screenFrame.size.width, kDefaultToolbarHeight+20);
    CGRect w = CGRectMake(0, screenFrame.size.height-kDefaultToolbarHeight - 44, screenFrame.size.width, kDefaultToolbarHeight);

    // 输入框
    self.inputToolbar = [[UIInputToolbar alloc] initWithFrame: w];
    _inputToolbar.delegate = self;
    _inputToolbar.textView.returnKeyType = UIReturnKeyDone;
//    _inputToolbar.textView.placeholder = @"Placeholder";
    //[_inputToolbar focus];
    
    // 回复框
    self.upperView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 26)];
    self.upperView.backgroundColor = [UIColor blackColor];
    self.upperView.alpha = 0.8f;
    
    // 回复框上的取消按钮
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = CGRectMake(320-40+10, 10, 20, 20);
    [btn setCenterY:self.upperView.centerY];
    [btn addTarget: self action: @selector(clickUpperView) forControlEvents: UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"comment_x.png"] forState:UIControlStateNormal];
    [self.upperView addSubview: btn];
    
    // 回复框上的回复人
    self.replyLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 10, self.view.frame.size.width, 20)];
    [self.replyLabel setCenterY:self.upperView.centerY];
    self.replyLabel.font = [UIFont systemFontOfSize:14.0f];
    _replyLabel.backgroundColor = [UIColor clearColor];
    _replyLabel.textColor = [UIColor whiteColor];
    [self.upperView addSubview: _replyLabel];
    
    [self.view addSubview: _upperView];
    [self.view addSubview: _inputToolbar];
}

- (void)viewWillAppear:(BOOL)animated
{
//	[super viewWillAppear:animated];
	/* Listen for keyboard */

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	/* No longer listen for keyboard */
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    /* Move the toolbar to above the keyboard */
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.25];
	CGRect frame = self.inputToolbar.frame;
    frame.origin.y = self.view.height - keyboardBounds.size.height - frame.size.height;
    NSLog(@"%f %f", self.view.height, keyboardBounds.size.height);
	self.inputToolbar.frame = frame;
    [self expandingToolbar: _inputToolbar];
	[UIView commitAnimations];
    
    _keyboardIsVisible = YES;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [_inputToolbar.textView resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    /* Move the toolbar back to bottom of the screen */
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect frame = self.inputToolbar.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
	self.inputToolbar.frame = frame;
    [self expandingToolbar: _inputToolbar];
	[UIView commitAnimations];
    _keyboardIsVisible = NO;
}

#pragma mark - Delegate for UIInputBar

// 发送评论
-(void)inputButtonPressed:(NSString *)inputText
{
    /* Called when toolbar button is pressed */
    NSLog(@"Pressed button with text: '%@'", inputText);
    LBFileClient *client = [LBFileClient sharedInstance];
    if (![_toCommentUser isEqualToString: @""]) {
        if ([_topicID isEqualToString: @""])
            return;
        [client addCommentOfComment:[NSArray arrayWithObjects: _leboID, _topicID, inputText, nil] cachePolicy:NSURLRequestReloadIgnoringCacheData  delegate:self selector:@selector(addCommentOfCommentRequestDidFinishLoad:) selectorError:@selector(addCommentOfCommentRequestError:)];
    } else {
        [client addCommentOfLebo:[NSArray arrayWithObjects: _leboID, inputText, nil] cachePolicy:NSURLRequestReloadIgnoringCacheData  delegate:self selector:@selector(addCommentRequestDidFinishLoad:) selectorError:@selector(addCommentRequestError:)];    
    }
    
    text = inputText;
    
    progress = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progress.yOffset = -110;
    progress.labelText = @"正在评论...";
    [progress show:YES];
}

-(void)expandingToolbar:(UIInputToolbar *)toolbar
{
    CGRect r = toolbar.frame;
    self.upperView.frame = CGRectMake(r.origin.x,
                                      r.origin.y - self.upperView.frame.size.height,
                                      self.upperView.frame.size.width,
                                      self.upperView.frame.size.height);
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBCommentCell *cell = (LBCommentCell *) [self tableView: tableView cellForRowAtIndexPath: indexPath];
    if (cell != nil) {
        self.topicID = cell.commentView.commentID;
        self.toCommentUser = cell.commentView.commentUser;
        self.commentTo = cell.commentView.commentTo;
        
//        self.topicID = [NSString stringWithFormat: @"debug: %d", indexPath.row];
        [self checkUpperView];
        [_inputToolbar focus];
    }
}

#pragma mark - Event

- (void)checkUpperView
{
    if ([_topicID isEqualToString: @""]) {
        // 直接恢复帖子
        self.upperView.hidden = YES;
    } else {
        self.replyLabel.text = [NSString stringWithFormat:@"回复:%@",_toCommentUser];
        // 回复帖子的评论
        self.upperView.hidden = NO;
    }
}

- (void)clickUpperView
{
    self.topicID = @"";
    self.toCommentUser = @"";
    [self checkUpperView];
}

#pragma mark - Request about adding comment

- (void)addCommentRequestDidFinishLoad:(NSData*)data
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
                if(_modelItem)
                [self.modelItem setObject:[NSString stringWithFormat:@"%d",[[_modelItem objectForKey:@"commentCount"] intValue] + 1] forKey:@"commentCount"];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:[[AccountHelper getAccount] DisplayName] forKey:@"commentAuthorDisplayName"];
                [dict setObject:[[AccountHelper getAccount] AccountID] forKey:@"commentAuthorID"];
                [dict setObject:[[AccountHelper getAccount] PhotoID] forKey:@"commentAuthorPhotoID"];
                [dict setObject:[[AccountHelper getAccount] PhotoUrl] forKey:@"commentAuthorPhotoUrl"];
                [dict setObject:_topicID forKey:@"commentID"];
                [dict setObject:[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]] forKey:@"commentSubmitTime"];
                [dict setObject:text forKey:@"content"];
                
                if(self.model == nil || [self.model count] == 0)
                {
                    self.model = [[NSMutableArray alloc] init];
                    [self.model addObject: dict];
                }
                else
                {
                    [self.model insertObject:dict atIndex:0];
                }
                [self.errorView removeFromSuperview];
                [_tableView reloadData];
                progress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                progress.mode = MBProgressHUDModeCustomView;
                progress.labelText = @"评论成功";
                
                [self performSelector:@selector(removeProgressSuccess) withObject:nil afterDelay:1.0f];            }
            if([responseObject isKindOfClass:[NSString class]] && [responseObject isEqualToString:@"FAIL"])
            {
                NSLog(@"fail");
                progress.labelText = @"评论失败";
            [self performSelector:@selector(removeProgressFail) withObject:nil afterDelay:1.0f];            }
        }
    }
    else {
        [self addCommentRequestError:nil];
    }
}

- (void)addCommentRequestError:(NSError *)data{
    NSLog(@"ERROR");
   progress.labelText = @"评论失败";
    [self performSelector:@selector(removeProgressFail) withObject:nil afterDelay:1.0f];
}

- (void)addCommentOfCommentRequestDidFinishLoad:(NSData*)data {
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", [json_string JSONValue]);
   
    if(json_string.length > 0)
    {
        id responseObject = [[json_string JSONValue] objectForKey:@"error"];
        if(responseObject)
        {
            if([responseObject isKindOfClass:[NSString class]] && [responseObject isEqualToString:@"OK"])
            {
                NSLog(@"success");
                [self.modelItem setObject:[NSString stringWithFormat:@"%d",[[_modelItem objectForKey:@"commentCount"] intValue] + 1] forKey:@"commentCount"];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:[[AccountHelper getAccount] DisplayName] forKey:@"commentAuthorDisplayName"];
                [dict setObject:_commentTo forKey:@"commentTo"];
                [dict setObject:_leboID forKey:@"commentAuthorID"];
                [dict setObject:[[AccountHelper getAccount] PhotoID] forKey:@"commentAuthorPhotoID"];
                [dict setObject:[[AccountHelper getAccount] PhotoUrl] forKey:@"commentAuthorPhotoUrl"];
                [dict setObject:_topicID forKey:@"commentID"];
                [dict setObject:[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]] forKey:@"commentSubmitTime"];
                [dict setObject:text forKey:@"content"];
                [self.model insertObject:dict atIndex:0];
                [_tableView reloadData];
                progress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                progress.mode = MBProgressHUDModeCustomView;
                progress.labelText = @"评论成功";
                [self performSelector:@selector(removeProgressSuccess) withObject:nil afterDelay:1.0f];
            }
            if([responseObject isKindOfClass:[NSString class]] && [responseObject isEqualToString:@"FAIL"])
            {
                NSLog(@"fail");
                progress.labelText = @"评论失败";
                 [self performSelector:@selector(removeProgressFail) withObject:nil afterDelay:1.0f];
            }
        }
    } else {
        [self addCommentRequestError:nil];
    }
}

- (void)addCommentOfCommentRequestError:(NSError *)data{
    NSLog(@"ERROR");
    progress.labelText = @"评论失败";
    [self performSelector:@selector(removeProgressFail) withObject:nil afterDelay:1.0f];
}

- (void)removeProgressSuccess{
    [self.inputToolbar.textView resignFirstResponder];
    [self.inputToolbar.textView clearText];
    self.topicID = @"";
    self.toCommentUser = @"";
    [self checkUpperView];
    
    [progress show:NO];
    [progress removeFromSuperview];
}

- (void)removeProgressFail{
    [progress show:NO];
    [progress removeFromSuperview];
}

@end
