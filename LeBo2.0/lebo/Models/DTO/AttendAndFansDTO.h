//
//  AttendAndFansDTO.h
//  lebo
//
//  Created by King on 13-4-1.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "DTOBase.h"

@interface AttendAndFansDTO : DTOBase {
	NSString *AccountID;
    NSString *DisplayName;
    NSString *AccountPhotoID;
    NSString *AccountPhotoUrl;
    NSInteger Gender;
    NSDate *LastLoginTime;
    NSString *is_visible;
    NSString *Sign;
    NSInteger Age;
    NSInteger Attended;
}

@property (nonatomic, readonly) NSString *AccountID;
@property (nonatomic, readonly) NSString *DisplayName;
@property (nonatomic, readonly) NSString *AccountPhotoID;
@property (nonatomic, readonly) NSString *AccountPhotoUrl;
@property (nonatomic, readonly) NSInteger Gender;
@property (nonatomic, readonly) NSDate *LastLoginTime;
@property (nonatomic, readonly) NSString *is_visible;
@property (nonatomic, readonly) NSString *Sign;
@property (nonatomic, assign) NSInteger Age;
@property (nonatomic, assign) NSInteger Attended;


@end
