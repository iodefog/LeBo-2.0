//
//  UIImage+Addition.m
//  Tudou
//
//  Created by zhang jiangshan on 12-11-19.
//  Copyright (c) 2012年 Lebo.com inc. All rights reserved.
//

#import "UIImage+Addition.h"
#import "Universal.h"

CGContextRef CreateRGBABitmapContext (CGImageRef newImage)
{
	CGContextRef context = NULL;
	CGColorSpaceRef colorSpace;
	void * data;
	size_t width=CGImageGetWidth(newImage);
	size_t height=CGImageGetHeight(newImage);
	int bitmapByteCount=4*width*height;
	int bitmapBytesPerRow =(width * 4);
	
	data=malloc(bitmapByteCount);
	if(data==NULL)
	{
		NSLog(@"data=NULL");
	}
	colorSpace=CGColorSpaceCreateDeviceRGB();
	if(colorSpace==NULL)
	{
        free (data);
        CGColorSpaceRelease(colorSpace);
		return NULL;
	}
	context=CGBitmapContextCreate(data,
								  width,
								  height,
								  8,
								  bitmapBytesPerRow,
								  colorSpace,
								  kCGImageAlphaPremultipliedLast);
    
	if (context == NULL)
	{
		free (data);
		fprintf (stderr, "Context not created!");
	}
	CGColorSpaceRelease(colorSpace);
	return context;
}

unsigned char *RequestImagePixelData(UIImage * inImage)
{
	CGImageRef newImage=[inImage CGImage];
	CGContextRef context=CreateRGBABitmapContext(newImage);
	if (context == NULL) return NULL;
	CGRect rect=CGRectMake(0, 0, inImage.size.width*inImage.scale, inImage.size.height*inImage.scale);
	CGContextDrawImage(context, rect, newImage);
	unsigned char * data=CGBitmapContextGetData(context);
	CGContextRelease(context);
	return data;
    
}
@implementation UIImage (Addtion)
- (UIImage *)resizableImageWithCap2x2{
    UIImage* newImage = nil;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0"))
        newImage = [self resizableImageWithCapInsets:UIEdgeInsetsMake(3.0f, 3.0f, 3.0f, 3.0f)];
    else
        newImage = [self stretchableImageWithLeftCapWidth:3.0f topCapHeight:3.0f];
    return newImage;
}
- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}


- (UIImage*)resizeImageWithNewSize:(CGSize)newSize
{
    float scale = [[UIScreen mainScreen] scale];
	CGFloat newWidth = newSize.width*scale;
	CGFloat newHeight = newSize.height*scale;
    // Resize image if needed.
    float width  = self.size.width*self.scale;
    float height = self.size.height*self.scale;
    // fail safe
    if (width == 0 || height == 0)
		return self;
    
    //float scale;
	
    if (width != newWidth || height != newHeight) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), YES, 0);
        [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
		
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        // Cleanup
        
        //UIImage *resized = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //NSData *jpeg = UIImageJPEGRepresentation(image, 0.8);
        return newImage;
    }
    return self;
}

- (UIImage *)getImageWithMaskColor:(UIColor *) color
{
    // Create the proper sized rect
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(self.CGImage), CGImageGetHeight(self.CGImage));
    
    // Create a new bitmap context
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(self.CGImage), kCGImageAlphaPremultipliedLast);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 0);
    CGContextFillRect(context, imageRect);
    
    // Use the passed in image as a clipping mask
    CGContextClipToMask(context, imageRect, self.CGImage);
    // Set the fill color to black: R:0 G:0 B:0 alpha:1
    CGColorRef cgColor = color.CGColor;
    const CGFloat * floats = CGColorGetComponents(cgColor);
    CGContextSetRGBFillColor(context, floats[0], floats[1], floats[2], floats[3]);
    // Fill with black
    CGContextFillRect(context, imageRect);
    
    // Generate a new image
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:self.scale orientation:self.imageOrientation];
    
    // Cleanup
    CGContextRelease(context);
    CGImageRelease(newCGImage);
    
    return newImage;
}

- (UIImage *)getGrayImage
{
    unsigned char * imgPixel=RequestImagePixelData(self);
	CGImageRef imageRef=[self CGImage];
	GLuint w=CGImageGetWidth(imageRef);
	GLuint h=CGImageGetHeight(imageRef);
	int wOff = 0;
	int pixOff = 0;
	for(GLuint y = 0;y< h;y++)
	{
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++)
		{
			//int alpha = (unsigned char)imgPixel[pixOff];
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			int bw = (int)((red+green+blue)/3.0);
			
			imgPixel[pixOff] = bw;
			imgPixel[pixOff+1] = bw;
			imgPixel[pixOff+2] = bw;
			pixOff += 4;
		}
		wOff += w * 4;
	}
	CGDataProviderRef provider=CGDataProviderCreateWithData(NULL, imgPixel, w*h*4, NULL);
	CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitMapInfo=kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent=kCGRenderingIntentDefault;
	CGImageRef myImageRef=CGImageCreate(w, h, 8, 32, 4*w, colorSpace, bitMapInfo, provider, NULL, NO, renderingIntent);
	//UIImage * myImage= [UIImage imageWithCGImage:myImageRef];
    UIImage * myImage = [UIImage imageWithCGImage:myImageRef scale:self.scale orientation:self.imageOrientation];
	CFRelease(myImageRef);
	CGColorSpaceRelease(colorSpace);
	CGDataProviderRelease(provider);
	return myImage ;
}

- (BOOL)hasAlpha
{
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    BOOL imageHasAlphaInfo = (alphaInfo != kCGImageAlphaNone &&
                              alphaInfo != kCGImageAlphaNoneSkipFirst &&
                              alphaInfo != kCGImageAlphaNoneSkipLast);
    return imageHasAlphaInfo;
}
@end

//
//  UIImage+FX.m
//
//  Version 1.2.3
//
//  Created by Nick Lockwood on 31/10/2011.
//  Copyright (c) 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/FXImageView
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

@implementation UIImage (FX)

- (UIImage *)imageCroppedToRect:(CGRect)rect
{
    //create drawing context
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    
    //draw
    [self drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
    
    //capture resultant image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return image
	return image;
}

- (UIImage *)imageScaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(self.size, size))
    {
        return self;
    }
    
    //create drawing context
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return image
	return image;
}

- (UIImage *)imageScaledToFitSize:(CGSize)size
{
    //calculate rect
    CGFloat aspect = self.size.width / self.size.height;
    if (size.width / aspect <= size.height)
    {
        return [self imageScaledToSize:CGSizeMake(size.width, size.width / aspect)];
    }
    else
    {
        return [self imageScaledToSize:CGSizeMake(size.height * aspect, size.height)];
    }
}

- (UIImage *)imageScaledToFillSize:(CGSize)size
{
    if (CGSizeEqualToSize(self.size, size))
    {
        return self;
    }
    //calculate rect
    CGFloat aspect = self.size.width / self.size.height;
    if (size.width / aspect >= size.height)
    {
        return [self imageScaledToSize:CGSizeMake(size.width, size.width / aspect)];
    }
    else
    {
        return [self imageScaledToSize:CGSizeMake(size.height * aspect, size.height)];
    }
}

- (UIImage *)imageCroppedAndScaledToSize:(CGSize)size
                             contentMode:(UIViewContentMode)contentMode
                                padToFit:(BOOL)padToFit;
{
    //calculate rect
    CGRect rect = CGRectZero;
    switch (contentMode)
    {
        case UIViewContentModeScaleAspectFit:
        {
            CGFloat aspect = self.size.width / self.size.height;
            if (size.width / aspect <= size.height)
            {
                rect = CGRectMake(0.0f, (size.height - size.width / aspect) / 2.0f, size.width, size.width / aspect);
            }
            else
            {
                rect = CGRectMake((size.width - size.height * aspect) / 2.0f, 0.0f, size.height * aspect, size.height);
            }
            break;
        }
        case UIViewContentModeScaleAspectFill:
        {
            CGFloat aspect = self.size.width / self.size.height;
            if (size.width / aspect >= size.height)
            {
                rect = CGRectMake(0.0f, (size.height - size.width / aspect) / 2.0f, size.width, size.width / aspect);
            }
            else
            {
                rect = CGRectMake((size.width - size.height * aspect) / 2.0f, 0.0f, size.height * aspect, size.height);
            }
            break;
        }
        case UIViewContentModeCenter:
        {
            rect = CGRectMake((size.width - self.size.width) / 2.0f, (size.height - self.size.height) / 2.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeTop:
        {
            rect = CGRectMake((size.width - self.size.width) / 2.0f, 0.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeBottom:
        {
            rect = CGRectMake((size.width - self.size.width) / 2.0f, size.height - self.size.height, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeLeft:
        {
            rect = CGRectMake(0.0f, (size.height - self.size.height) / 2.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeRight:
        {
            rect = CGRectMake(size.width - self.size.width, (size.height - self.size.height) / 2.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeTopLeft:
        {
            rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeTopRight:
        {
            rect = CGRectMake(size.width - self.size.width, 0.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeBottomLeft:
        {
            rect = CGRectMake(0.0f, size.height - self.size.height, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeBottomRight:
        {
            rect = CGRectMake(size.width - self.size.width, size.height - self.size.height, self.size.width, self.size.height);
            break;
        }
        default:
        {
            rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
            break;
        }
    }
    
    if (!padToFit)
    {
        //remove padding
        if (rect.size.width < size.width)
        {
            size.width = rect.size.width;
            rect.origin.x = 0.0f;
        }
        if (rect.size.height < size.height)
        {
            size.height = rect.size.height;
            rect.origin.y = 0.0f;
        }
    }
    
    //avoid redundant drawing
    if (CGSizeEqualToSize(self.size, size))
    {
        return self;
    }
    
    //create drawing context
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [self drawInRect:rect];
    
    //capture resultant image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return image
	return image;
}

+ (CGImageRef)gradientMask
{
    static CGImageRef sharedMask = NULL;
    if (sharedMask == NULL)
    {
        //create gradient mask
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 256), YES, 0.0);
        CGContextRef gradientContext = UIGraphicsGetCurrentContext();
        CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
        CGPoint gradientStartPoint = CGPointMake(0, 0);
        CGPoint gradientEndPoint = CGPointMake(0, 256);
        CGContextDrawLinearGradient(gradientContext, gradient, gradientStartPoint,
                                    gradientEndPoint, kCGGradientDrawsAfterEndLocation);
        sharedMask = CGBitmapContextCreateImage(gradientContext);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        UIGraphicsEndImageContext();
    }
    return sharedMask;
}

- (UIImage *)reflectedImageWithScale:(CGFloat)scale
{
	//get reflection dimensions
	CGFloat height = ceil(self.size.height * scale);
	CGSize size = CGSizeMake(self.size.width, height);
	CGRect bounds = CGRectMake(0.0f, 0.0f, size.width, size.height);
	
	//create drawing context
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//clip to gradient
	CGContextClipToMask(context, bounds, [[self class] gradientMask]);
	
	//draw reflected image
	CGContextScaleCTM(context, 1.0f, -1.0f);
	CGContextTranslateCTM(context, 0.0f, -self.size.height);
	[self drawInRect:CGRectMake(0.0f, 0.0f, self.size.width, self.size.height)];
	
	//capture resultant image
	UIImage *reflection = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return reflection image
	return reflection;
}

- (UIImage *)imageWithReflectionWithScale:(CGFloat)scale gap:(CGFloat)gap alpha:(CGFloat)alpha
{
    //get reflected image
    UIImage *reflection = [self reflectedImageWithScale:scale];
    CGFloat reflectionOffset = reflection.size.height + gap;
    
    //create drawing context
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width, self.size.height + reflectionOffset * 2.0f), NO, 0.0f);
    
    //draw reflection
    [reflection drawAtPoint:CGPointMake(0.0f, reflectionOffset + self.size.height + gap) blendMode:kCGBlendModeNormal alpha:alpha];
    
    //draw image
    [self drawAtPoint:CGPointMake(0.0f, reflectionOffset)];
    
    //capture resultant image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return image
	return image;
}

- (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur
{
    //get size
    CGSize border = CGSizeMake(fabsf(offset.width) + blur, fabsf(offset.height) + blur);
    CGSize size = CGSizeMake(self.size.width + border.width * 2.0f, self.size.height + border.height * 2.0f);
    
    //create drawing context
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //set up shadow
    CGContextSetShadowWithColor(context, offset, blur, color.CGColor);
    
    //draw with shadow
    [self drawAtPoint:CGPointMake(border.width, border.height)];
    
    //capture resultant image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return image
	return image;
}

- (UIImage *)imageWithCornerRadius:(CGFloat)radius
{
    //create drawing context
	UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //clip image
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, radius);
    CGContextAddLineToPoint(context, 0.0f, self.size.height - radius);
    CGContextAddArc(context, radius, self.size.height - radius, radius, M_PI, M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, self.size.width - radius, self.size.height);
    CGContextAddArc(context, self.size.width - radius, self.size.height - radius, radius, M_PI / 2.0f, 0.0f, 1);
    CGContextAddLineToPoint(context, self.size.width, radius);
    CGContextAddArc(context, self.size.width - radius, radius, radius, 0.0f, -M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, radius, 0.0f);
    CGContextAddArc(context, radius, radius, radius, -M_PI / 2.0f, M_PI, 1);
    CGContextClip(context);
    
    //draw image
    [self drawAtPoint:CGPointZero];
    
    //capture resultant image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return image
	return image;
}

- (UIImage *)imageWithAlpha:(CGFloat)alpha
{
    //create drawing context
	UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    //draw with alpha
    [self drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:alpha];
    
    //capture resultant image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return image
	return image;
}

- (UIImage *)imageWithMask:(UIImage *)maskImage;
{
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //apply mask
    CGContextClipToMask(context, CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), maskImage.CGImage);
    
    //draw image
    [self drawAtPoint:CGPointZero];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

- (UIImage *)maskImageFromImageAlpha
{
    //get dimensions
    NSInteger width = CGImageGetWidth(self.CGImage);
    NSInteger height = CGImageGetHeight(self.CGImage);
    
    //create alpha image
    NSInteger bytesPerRow = ((width + 3) / 4) * 4;
    void *data = calloc(bytesPerRow * height, sizeof(unsigned char *));
    CGContextRef context = CGBitmapContextCreate(data, width, height, 8, bytesPerRow, NULL, kCGImageAlphaOnly);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), self.CGImage);
    
    //invert alpha pixels
    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            NSInteger index = y * bytesPerRow + x;
            ((unsigned char *)data)[index] = 255 - ((unsigned char *)data)[index];
        }
    }
    
    //create mask image
    CGImageRef maskRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *mask = [UIImage imageWithCGImage:maskRef];
    CGImageRelease(maskRef);
    free(data);
    
    //return image
	return mask;
}


- (UIImage*) imageWith3x3GaussianBlur {
    
    const CGFloat filter[3][3] = {
        {1.0f/16.0f, 2.0f/16.0f, 1.0f/16.0f},
        {2.0f/16.0f, 4.0f/16.0f, 2.0f/16.0f},
        {1.0f/16.0f, 2.0f/16.0f, 1.0f/16.0f}
    };
    
    CGImageRef imgRef = [self CGImage];
    
    size_t width = CGImageGetWidth(imgRef);
    size_t height = CGImageGetHeight(imgRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = 4;
    size_t bytesPerRow = bytesPerPixel * width;
    size_t totalBytes = bytesPerRow * height;
    
    //Allocate Image space
    uint8_t* rawData = malloc(totalBytes);
    
    //Create Bitmap of same size
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    //Draw our image to the context
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    
    for ( int y = 0; y < height; y++ ) {
        
        for ( int x = 0; x < width; x++ ) {
            
            uint8_t* pixel = rawData + (bytesPerRow * y) + (x * bytesPerPixel);
            
            CGFloat sumRed = 0;
            CGFloat sumGreen = 0;
            CGFloat sumBlue = 0;
            
            for ( int j = 0; j < 3; j++ ) {
                
                for ( int i = 0; i < 3; i++ ) {
                    
                    if ( (y + j - 1) >= height || (y + j - 1) < 0 ) {
                        //Use zero values at edge of image
                        continue;
                    }
                    
                    if ( (x + i - 1) >= width || (x + i - 1) < 0 ) {
                        //Use Zero values at edge of image
                        continue;
                    }
                    
                    uint8_t* kernelPixel = rawData + (bytesPerRow * (y + j - 1)) + ((x + i - 1) * bytesPerPixel);
                    
                    sumRed += kernelPixel[0] * filter[j][i];
                    sumGreen += kernelPixel[1] * filter[j][i];
                    sumBlue += kernelPixel[2] * filter[j][i];
                    
                }
                
            }
            
            pixel[0] = roundf(sumRed);
            pixel[1] = roundf(sumGreen);
            pixel[2] = roundf(sumBlue);
            
        }
        
    }
    
    
    //Create Image
    CGImageRef newImg = CGBitmapContextCreateImage(context);
    
    //Release Created Data Structs
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    free(rawData);
    
    //Create UIImage struct around image
    UIImage* image = [UIImage imageWithCGImage:newImg];
    
    //Release our hold on the image
    CGImageRelease(newImg);
    
    //return new image!
    return image;
    
}

- (UIImage*) imageWith5x5GaussianBlur {
    
    const CGFloat filter[5][5] = {
        {1.0f/256.0f, 4.0f/256.0f, 6.0f/256.0f, 4.0f/256.0f, 1.0f/256.f},
        {4.0f/256.0f, 16.0f/256.0f, 24.0f/256.0f, 16.0f/256.0f, 4.0f/256.f},
        {6.0f/256.0f, 24.0f/256.0f, 36.0f/256.0f, 24.0f/256.0f, 6.0f/256.f},
        {4.0f/256.0f, 16.0f/256.0f, 24.0f/256.0f, 16.0f/256.0f, 4.0f/256.f},
        {1.0f/256.0f, 4.0f/256.0f, 6.0f/256.0f, 4.0f/256.0f, 1.0f/256.f}
    };
    
    CGImageRef imgRef = [self CGImage];
    
    size_t width = CGImageGetWidth(imgRef);
    size_t height = CGImageGetHeight(imgRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = 4;
    size_t bytesPerRow = bytesPerPixel * width;
    size_t totalBytes = bytesPerRow * height;
    
    //Allocate Image space
    uint8_t* rawData = malloc(totalBytes);
    
    //Create Bitmap of same size
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    //Draw our image to the context
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    
    for ( int y = 0; y < height; y++ ) {
        
        for ( int x = 0; x < width; x++ ) {
            
            uint8_t* pixel = rawData + (bytesPerRow * y) + (x * bytesPerPixel);
            
            CGFloat sumRed = 0;
            CGFloat sumGreen = 0;
            CGFloat sumBlue = 0;
            
            for ( int j = 0; j < 5; j++ ) {
                
                for ( int i = 0; i < 5; i++ ) {
                    
                    if ( (y + j - 2) >= height || (y + j - 2) < 0 ) {
                        //Use zero values at edge of image
                        continue;
                    }
                    
                    if ( (x + i - 2) >= width || (x + i - 2) < 0 ) {
                        //Use Zero values at edge of image
                        continue;
                    }
                    
                    uint8_t* kernelPixel = rawData + (bytesPerRow * (y + j - 2)) + ((x + i - 2) * bytesPerPixel);
                    
                    sumRed += kernelPixel[0] * filter[j][i];
                    sumGreen += kernelPixel[1] * filter[j][i];
                    sumBlue += kernelPixel[2] * filter[j][i];
                    
                }
                
            }
            
            pixel[0] = roundf(sumRed);
            pixel[1] = roundf(sumGreen);
            pixel[2] = roundf(sumBlue);
            
        }
        
    }
    
    
    //Create Image
    CGImageRef newImg = CGBitmapContextCreateImage(context);
    
    //Release Created Data Structs
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    free(rawData);
    
    //Create UIImage struct around image
    UIImage* image = [UIImage imageWithCGImage:newImg];
    
    //Release our hold on the image
    CGImageRelease(newImg);
    
    //return new image!
    return image;
    
}

@end
/*
@implementation UIImage (Save)
//将图片保存到本地
+ (void)saveImageToLocal:(UIImage*)image Keys:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    [preferences setObject:UIImagePNGRepresentation(image) forKey:key];
}

//本地是否有相关图片
+ (BOOL)localHaveImage:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    NSData* imageData = [preferences objectForKey:key];
    if (imageData) {
        return YES;
    }
    return NO;
}

//从本地获取图片
+ (UIImage*)getImageFromLocal:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    NSData* imageData = [preferences objectForKey:key];
    UIImage* image;
    if (imageData) {
        image = [UIImage imageWithData:imageData];
    }
    else {
        NSLog(@"未从本地获得图片");
    }
    return image;
}

@end
*/