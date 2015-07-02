//
//  NoticeViewController.m
//  LBDemo
//
//  Created by Li Hongli on 13-3-25.
//  Copyright (c) 2013年 Li Hongli. All rights reserved.
//

#import "LBNoticeViewController.h"
#import "LBFileClient.h"
#import "AccountHelper.h"
#import "AccountDTO.h"

@interface LBNoticeViewController ()

@end

@implementation LBNoticeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - viewLify cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self createUI];
}

- (void)createUI
{
    _partAccountDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"partAccountDTO"];

    NSLog(@"commentMode%@  fansMode%@  loveMode%@", [_partAccountDict objectForKey:@"commentMode"], [_partAccountDict objectForKey:@"fansMode"], [_partAccountDict objectForKey:@"loveMode"]);
    
    self.title = @"消息提醒";
    _switchArray= [[NSMutableArray alloc]init];
    _mTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _mTable.delegate = self;
    _mTable.dataSource = self;
//    _mTable.scrollEnabled = NO;
    [self.view addSubview:_mTable];
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithTitle:@"返回" image:@"general_back.png" target:self action:@selector(back)];
    
    _dataList = [[NSMutableArray alloc]initWithObjects:@"被评论",@"被喜欢",@"新粉丝", nil];
    [self layoutSubview:self.view.frame.size];
    
    _oneSwitch = [self createSwith:1000];
    _secondSwitch = [self createSwith:1001];
    _thirdSwitch = [self createSwith:1002];
}

- (void)viewWillUnload{
    _mTable = nil;
    _dataList = nil;
    [super viewWillUnload];
}

- (void)layoutSubview:(CGSize)size
{
    _mTable.frame = CGRectMake(0, 0 , 320, self.view.frame.size.height);
}

#pragma mark - tabelViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    cell.selectionStyle= UITableViewCellSelectionStyleNone;//点击颜色
    if (indexPath.row == 0) {
        [cell.contentView addSubview:_oneSwitch];
    }else if(indexPath.row == 1){
        [cell.contentView addSubview:_secondSwitch];
    }else if(indexPath.row == 2){
        [cell.contentView addSubview:_thirdSwitch];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.text = [_dataList objectAtIndex:indexPath.row];
    return cell;
}

- (UISwitch *)createSwith:(NSInteger)tag
{
    UISwitch *mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(210, 5, 30, 30)];
//    mySwitch.onTintColor = [UIColor colorWithRed:0 green:173/255.0 blue:196/255.0 alpha:1];
    mySwitch.tag = tag;
    
        if (tag == 1000) {
            [mySwitch setOn: ((NSString *)[_partAccountDict objectForKey:@"commentMode"]).boolValue];
        }else if (tag == 1001){
             [mySwitch setOn: ((NSString *)[_partAccountDict objectForKey:@"fansMode"]).boolValue];
        }else if (tag == 1002){
             [mySwitch setOn: ((NSString *)[_partAccountDict objectForKey:@"loveMode"]).boolValue];
        }
    
    return mySwitch;
}

- (void)back
{
    BOOL comment = ((NSString *)[_partAccountDict objectForKey:@"commentMode"]).boolValue ==  _oneSwitch.isOn;
    BOOL love =   ((NSString *)[_partAccountDict objectForKey:@"fansMode"]).boolValue == _secondSwitch.isOn;
    BOOL fans = ((NSString *)[_partAccountDict objectForKey:@"loveMode"]).boolValue == _thirdSwitch.isOn;
    
    if (!fans || !comment || !love) {
        [[LBFileClient sharedInstance] setNotice:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",_oneSwitch.isOn],[NSString stringWithFormat:@"%d",_secondSwitch.isOn], [NSString stringWithFormat:@"%d",_thirdSwitch.isOn],nil] cachePolicy:NSURLRequestReloadIgnoringCacheData delegate:nil selector:@selector(responseSuccess) selectorError:@selector(responseFail)];
        // 直接修改过accoutID
        NSMutableDictionary *mDict = [[NSMutableDictionary alloc] initWithDictionary:_partAccountDict];
        [mDict removeObjectForKey:@"commentMode"];
        [mDict removeObjectForKey:@"fansMode"];
        [mDict removeObjectForKey:@"loveMode"];
        [mDict setObject:[NSString stringWithFormat:@"%d",_oneSwitch.isOn] forKey:@"commentMode"];
        [mDict setObject:[NSString stringWithFormat:@"%d",_secondSwitch.isOn] forKey:@"fansMode"];
        [mDict setObject:[NSString stringWithFormat:@"%d",_thirdSwitch.isOn] forKey:@"loveMode"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"partAccountDTO"];
        [[NSUserDefaults standardUserDefaults] setObject:mDict forKey:@"partAccountDTO"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// 
- (void)responseSuccess{
    NSLog(@"");
}

- (void)responseFail{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
