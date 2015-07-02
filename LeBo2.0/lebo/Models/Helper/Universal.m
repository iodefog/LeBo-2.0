//
//  Universal.m
//  Tudou
//
//  Created by zhang jiangshan on 12-11-19.
//  Copyright (c) 2012年 Youku.com inc.All rights reserved.
//

#import "Universal.h"
#import <mach/mach_time.h> 
#import "LBCache.h"
BOOL isPhone()
{
    return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ?  YES : NO);
}

BOOL isPad()
{
    return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?  YES : NO);
}

BOOL isPhone5()
{
    if(isPad())
        return NO;
    return screenSize().height > 480 ? YES : NO;
}

CGSize screenSize()
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
        return CGSizeMake(rect.size.width, rect.size.height-StatusBar_Height);
    else
        return CGSizeMake(rect.size.height, rect.size.width-StatusBar_Height);
}

UIImage *Image(NSString *name)
{
    //NSString * path = [NSString stringWithFormat:@"Resources.bundle/images/%@",name];
    return [UIImage imageNamed:name];
}

//UIImage * ImageFromDocument(NSString * path)
//{
//    return [[LBCache sharedInstance] cacheImageForPath:path];
//}

NSString *LocalizedString(NSString* key)
{
    return NSLocalizedString(key, key);
}

NSString* PathForBundleResource(NSString* relativePath) {
	NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
	return [resourcePath stringByAppendingPathComponent:relativePath];
}

NSString* PathForDocumentsResource(NSString* relativePath) {
	static NSString* documentsPath = nil;
	if (!documentsPath) {
		NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		documentsPath = [dirs objectAtIndex:0];
	}
	return [documentsPath stringByAppendingPathComponent:relativePath];
}

NSString* PathForCache(void)
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return cachesPath;
}

NSString * convertTimeWithSecondes(double seconds)
{
    int m = seconds/60;
    int s = (int)seconds%60;
    int h = m/60;
    m = m%60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",h,m,s];
}

CGFloat caculateTimeBlock (void (^block)(void)){
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) return -1.0;
    
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    return (CGFloat)nanos / NSEC_PER_SEC;
    
}
@implementation Universal


@end
