//
//  LBUploadManagerController.m
//  lebo
//
//  Created by 乐播 on 13-3-27.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBUploadManagerController.h"
#import "LBUploadCell.h"
#import "LBUploadTaskManager.h"
#import "InfoButton.h"
#import "LBMovieView.h"
#import "LBUploadEditController.h"
@interface LBUploadManagerController ()
{
    __weak UITableView * _tableView;
    LBUploadTaskManager * _manager;
    UIView * _section1_header;
    UIView * _section2_header;
}
@end

@implementation LBUploadManagerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title = @"上传";
        _manager = [LBUploadTaskManager sharedInstance];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managerDidChanged:) name:LBUploadTaskManagerDidChangeInfo object:_manager];
        self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithTitle:@"返回" image:@"general_back.png" target:self action:@selector(back)];
    }
    return self;
}

- (void)back
{
    [Global clearPlayStatus];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _section1_header = [self createHeaderWithString:@"草稿"];
    _section2_header = [self createHeaderWithString:@"上传失败"];
    
	UITableView * table  = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:table];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = [LBUploadCell height];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = table;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
    [LBMovieView pauseAll];
    [[LBUploadTaskManager sharedInstance].uploadingView setStyle:LBUploadViewStyleUploadCell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _section1_header = nil;
    _section2_header = nil;
}

- (void)refreshData
{
    [_manager refreshAllTask];
}

- (UIView *)createHeaderWithString:(NSString *)str
{
    UIImageView * header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 19)];
    UIImage * bg = Image(@"upload_bg_header.png");
    bg = [bg stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    header.image = bg;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, header.height)];
    [header addSubview:label];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    label.backgroundColor = [UIColor clearColor];
    label.text = str;
    label.font = [UIFont getNormalFont];
    label.textColor = [UIColor darkGrayColor];
    return header;
}
#pragma mark NSNotification

- (void)managerDidChanged:(NSNotification *)sender
{
    NSDictionary * info = sender.userInfo;
    id obj = info[LBUploadTaskChangedInfo];
    
    [_tableView beginUpdates];
    if(obj == _manager.uploadTask)
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    else if(obj == _manager.draftTask)
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    else if(obj == _manager.failedTask)
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    else
        NSLog(@"managerDidChanged error");
    [_tableView endUpdates];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [[_manager uploadTask] count];
            break;
        case 1:
            return [[_manager draftTask] count];
            break;
        case 2:
            return [[_manager failedTask] count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 0;
            break;
        case 1:
            return 19;
            break;
        case 2:
            return 19;
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return nil;
            break;
        case 1:
            return _section1_header;
            break;
        case 2:
            return _section2_header;
            break;
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    LBUploadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil){
        cell = [[LBUploadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.button addTarget:self action:@selector(didClickCellBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    id obj = nil;
    switch (indexPath.section) {
        case 0:
            obj = [_manager uploadTask][indexPath.row];
            break;
        case 1:
            obj = [_manager draftTask][indexPath.row];
            break;
        case 2:
            obj = [_manager failedTask][indexPath.row];
            break;
        default:
            break;
    }
    [cell setObject:obj];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(LBUploadCell *)cell refresh];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return nil;
    else
        return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBUploadCell * cell = (LBUploadCell *)[tableView cellForRowAtIndexPath:indexPath];
    LBUploadEditController * controller = [[LBUploadEditController alloc] initWithTask:cell.object];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        LBUploadCell * cell = (LBUploadCell *)[tableView cellForRowAtIndexPath:indexPath];
        [_manager removeTasks:cell.object];
    }
}
 
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)didClickCellBtn:(InfoButton *)sender
{
    LBUploadCell * cell = sender.userInfo;
    LBUploadTask * task = cell.object;
    [_manager startTask:task];
}
@end
