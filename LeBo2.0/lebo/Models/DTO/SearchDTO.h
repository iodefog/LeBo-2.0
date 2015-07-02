//
//  SearchDTO.h
//  lebo
//
//  Created by King on 13-4-19.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "DTOBase.h"

@interface SearchDTO : DTOBase
{
    NSString *AccountID;
    NSString *DisplayName;
    NSString *PhotoID;
    NSString *PhotoUrl;
    NSString *Sign;
    NSInteger Attended;
}

@property (nonatomic, readonly) NSString *AccountID;
@property (nonatomic, readonly) NSString *DisplayName;
@property (nonatomic, readonly) NSString *PhotoID;
@property (nonatomic, readonly) NSString *PhotoUrl;
@property (nonatomic, readonly) NSString *Sign;
@property (nonatomic, assign) NSInteger Attended;

@end
