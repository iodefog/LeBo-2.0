//
//  LeboImageDTO.m
//  LeBo
//
//  Created by Qiang Zhuang on 12/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeboImageDTO.h"

@implementation LeboImageDTO
@synthesize UploadID;

- (NSString *)toParam
{
    NSMutableString *param = [NSMutableString string];
    [param appendFormat:@"&user=%@", [AuthorID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return param;
}

- (BOOL)parse2:(NSDictionary *)result 
{
    if ([super parse2: result] == NO) {
        return NO;
    }
    
    UploadID = [[self getStrValue:[result objectForKey:@"uploadID"]] copy];
    
    return YES;
}

@end
