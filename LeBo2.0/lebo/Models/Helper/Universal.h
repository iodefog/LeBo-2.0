//
//  Universal.h
//  Tudou
//
//  Created by zhang jiangshan on 12-11-19.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import <Foundation/Foundation.h>


BOOL isPhone();
BOOL isPad();
BOOL isPhone5();

CGSize screenSize();
UIImage *Image(NSString *name);
NSString *LocalizedString(NSString* key);

NSString* PathForBundleResource(NSString* relativePath);
NSString* PathForDocumentsResource(NSString* relativePath);
NSString* PathForCache();

NSString * convertTimeWithSecondes(double seconds);


CGFloat caculateTimeBlock (void (^block)(void));
@interface Universal : NSObject

@end
