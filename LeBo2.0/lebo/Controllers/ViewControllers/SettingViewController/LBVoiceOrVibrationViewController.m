//
//  LBVoiceOrVibrationViewController.m
//  lebo
//
//  Created by Li Hongli on 13-3-26.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBVoiceOrVibrationViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface LBVoiceOrVibrationViewController ()

@end

@implementation LBVoiceOrVibrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息提醒";
    _vibartionSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
    [_vibartionSwitch addTarget:self action:@selector(vibartioSwtichChanged:) forControlEvents:UIControlEventValueChanged];
    _voiceSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
    [_voiceSwitch addTarget:self action:@selector(voiceSwitchChanged:) forControlEvents:UIControlEventValueChanged];
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithTitle:@"返回" image:@"general_back.png" target:self action:@selector(back)];
    NSNumber *vibartion = [[NSUserDefaults standardUserDefaults] objectForKey:@"vidartion"];
    NSNumber *voice = [[NSUserDefaults standardUserDefaults] objectForKey:@"voice"];
    
    if (vibartion) {
       [_vibartionSwitch setOn:vibartion.boolValue]; 
    }else{
        [_vibartionSwitch setOn:YES];
    }
    if (voice) {
        [_voiceSwitch setOn:voice.boolValue];
    }else{
        [_voiceSwitch setOn:YES];
    }
    
    _mTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _mTable.delegate = self;
    _mTable.dataSource = self;
    _mTable.rowHeight = 44.0f;
    [self.view addSubview:_mTable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"cellName";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            _vibartionSwitch.frame = CGRectMake(cell.frame.size.width - 90, 10, 60, 34);
            [cell addSubview:_vibartionSwitch];
            cell.textLabel.text = @"振动";
        }else if (indexPath.row == 1){
            _voiceSwitch.frame = CGRectMake(cell.frame.size.width - 90, 10, 60, 34);
            [cell addSubview:_voiceSwitch];
            cell.textLabel.text = @"声音";
        }
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    return cell;
}

- (void)vibartioSwtichChanged:(UISwitch *)sender{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:sender.isOn] forKey:@"vidartion"];
    if (sender.isOn) {
      AudioServicesPlaySystemSound(1011);      //没信息声，有振动
    }
}

- (void)_voiceAndvibartionSwitchChanged:(UISwitch *)sender{
 [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:sender.isOn] forKey:@"voiceAndVidartion"];
    if (sender.isOn ){
        AudioServicesPlaySystemSound(1007);
    }
}

- (void)voiceSwitchChanged:(UISwitch *)sender{
  [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:sender.isOn] forKey:@"voice"];
    if (sender.isOn) {
        AudioServicesPlaySystemSound(1315);      //信息声，没振动
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
