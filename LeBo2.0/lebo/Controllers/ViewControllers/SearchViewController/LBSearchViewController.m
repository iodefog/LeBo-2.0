//
//  LBSearchViewController.m
//  lebo
//
//  Created by yong wang on 13-4-18.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "LBSearchViewController.h"
#import "LBSearchCell.h"

@interface LBSearchViewController ()

@end

@implementation LBSearchViewController
@synthesize searchString = _searchString;
@synthesize searchWho = _searchWho;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setHeight:self.tableView.height - 92];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.model = nil;
    [self.errorView removeFromSuperview];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class cls = [self cellClass];
    NSString *identifier = [NSString stringWithFormat:@"%d", _searchWho];
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[cls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ([cell respondsToSelector:@selector(setObject: topViewIndex:)]) {
        if([self.model count] > indexPath.row)
        {
            id item = [self.model objectAtIndex:indexPath.row];
            [cell setObject:item topViewIndex:_searchWho];
        }
    }
    
    return cell;
}

- (Class)cellClass {
    return [LBSearchCell class];
}

- (API_GET_TYPE)modelApi
{
    if (self.searchWho) {
        return API_GET_SEARCH_USER;
    } else  {
        return API_GET_SEARCH_CHANNEL;
    };
}

- (NSString *)getKey
{
    return self.searchString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
