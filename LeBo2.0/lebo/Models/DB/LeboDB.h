//
//  LeboDB.h
//
//  Created by Sam on 11-11-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBM.h"

@interface LeboDB : DBM {
    
}

+ (id)shareInstance;
- (BOOL)clearTable:(NSString *)table;

@end
