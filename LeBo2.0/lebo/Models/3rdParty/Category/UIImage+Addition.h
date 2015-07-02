//
//  UIImage+Addition.h
//  Tudou
//
//  Created by zhang jiangshan on 12-11-19.
//  Copyright (c) 2012年 Lebo.com inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (Addtion)
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)resizeImageWithNewSize:(CGSize)newSize;
- (UIImage *)getImageWithMaskColor:(UIColor *)color;
- (UIImage *)getGrayImage;
- (BOOL)hasAlpha;

//包含iOS 5- – stretchableImageWithLeftCapWidth:topCapHeight:, ios5+ – resizableImageWithCapInsets:
- (UIImage *)resizableImageWithCap2x2;
@end


@interface UIImage (FX)

- (UIImage *)imageCroppedToRect:(CGRect)rect;
- (UIImage *)imageScaledToSize:(CGSize)size;
- (UIImage *)imageScaledToFitSize:(CGSize)size;
- (UIImage *)imageScaledToFillSize:(CGSize)size;
- (UIImage *)imageCroppedAndScaledToSize:(CGSize)size
                             contentMode:(UIViewContentMode)contentMode
                                padToFit:(BOOL)padToFit;

- (UIImage *)reflectedImageWithScale:(CGFloat)scale;
- (UIImage *)imageWithReflectionWithScale:(CGFloat)scale gap:(CGFloat)gap alpha:(CGFloat)alpha;
- (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur;
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;
- (UIImage *)imageWithAlpha:(CGFloat)alpha;
- (UIImage *)imageWithMask:(UIImage *)maskImage;

- (UIImage *)maskImageFromImageAlpha;


- (UIImage*) imageWith3x3GaussianBlur;
- (UIImage*) imageWith5x5GaussianBlur;

@end



