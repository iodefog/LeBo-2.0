//
//  LBUploadChannelController.m
//  lebo
//
//  Created by 乐播 on 13-3-26.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBUploadChannelController.h"
#import "LBChannelSelectedCell.h"
@interface LBUploadChannelController ()
{
    __weak UITextField * _textField;
    __weak UITableView * _table;
}
@end

@implementation LBUploadChannelController

- (API_GET_TYPE)modelApi
{
    return API_GET_CHANNEL_LIST;
}

- (Class)cellClass
{
    return [LBChannelSelectedCell class];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	UITextField * temp = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    temp.delegate = self;
    temp.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    temp.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:temp];
    _textField = temp;

    
    self.tableView.frame = CGRectMake(0, temp.bottom, self.view.width, self.view.height-temp.height);
    UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
    [gestureRecognizer setDelegate:self];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    CALayer * line = [[CALayer alloc] init];
    line.backgroundColor = [UIColor blackColor].CGColor;
    line.frame = CGRectMake(0, _textField.bottom, self.view.width, 1);
    [self.view.layer addSublayer:line];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _textField.text = @"#";
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_textField resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void)didCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)getFinalString
{
    NSString * temp = _textField.text;
    if(![temp length])
        return @"";
    
    if(![temp hasPrefix:@"#"])
        temp = [NSString stringWithFormat:@"#%@",temp];
    if(![temp hasSuffix:@"#"])
        temp = [NSString stringWithFormat:@"%@#",temp];
    return temp;
}

- (void)didFinish
{
    NSString * modifyText = [self getFinalString];
    [self.delegate didFinishEdit:modifyText];
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * temp = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(temp.length == 0)
    {
        [self didCancel];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self didCancel];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldEndEditing");
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self didFinish];
    return YES;
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView * touchView = [touch view];
    if([touchView isDescendantOfView:self.tableView])
    {
        if([_textField isFirstResponder])
            [_textField resignFirstResponder];
    }
    return NO;
}

#pragma mark UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"推荐频道";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBChannelSelectedCell * cell = (LBChannelSelectedCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSString * channel = cell.textLabel.text;
    _textField.text = channel;
    [self didFinish];
}
@end
