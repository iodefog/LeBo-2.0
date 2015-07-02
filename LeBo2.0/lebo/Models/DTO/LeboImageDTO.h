//
//  LeboImageDTO.h
//  LeBo
//
//  Created by Qiang Zhuang on 12/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeboDTO.h"

@interface LeboImageDTO : LeboDTO {
    NSString *UploadID;
}

@property (nonatomic, readonly) NSString *UploadID;

@end
