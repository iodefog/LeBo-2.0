//
//  TableViewDelegate.h
//  mcare-core
//
//  Created by sam on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TableViewDelegate

- (void)clearCacheData:(UITableView *)tableView;
- (BOOL)isPreLoadCell:(UITableView *)tableView;
- (UITableViewCell *)getTableViewCell:(NSIndexPath *)indexPath;

@end
