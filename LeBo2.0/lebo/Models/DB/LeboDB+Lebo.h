//
//  LeboDB+Lebo.h
//
//  Created by sam on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeboDB.h"

@class LeboDTO;

@interface LeboDB (Lebo)

- (BOOL)createTable_Lebo:(sqlite3*)db;
+ (BOOL)saveLebo:(LeboDTO *)dto;
+ (BOOL)getLebos:(NSMutableArray *)array;
+ (BOOL)clearLebos;

- (BOOL)clearLebos;
- (BOOL)getLebos:(NSMutableArray *)array;

@end
