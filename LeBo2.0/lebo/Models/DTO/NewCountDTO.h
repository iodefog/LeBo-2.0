//
//  NewCountDTO.h
//  lebo
//
//  Created by King on 13-4-1.
//  Copyright (c) 2013年 lebo. All rights reserved.
//

#import "DTOBase.h"

@interface NewCountDTO : DTOBase {

    NSString *NewFansCount;
    NSString *NewNoticeCount;
}

@property (nonatomic, copy) NSString *NewFansCount;
@property (nonatomic, copy) NSString *NewNoticeCount;

@end
