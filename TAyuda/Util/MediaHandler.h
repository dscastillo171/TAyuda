//
//  MediaHandler.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/17/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

// Image compression.
#define HIGH_IMAGE_COMPRESSION 0.5
#define LOW_IMAGE_COMPRESSION 1.0

// Images folder.
#define DIR_IMAGES @"Documents/Images/"

@interface MediaHandler : NSObject

// Return an image's hash.
+ (NSString *)hashFromData:(NSData *)data;

// Save, image formats.
typedef enum{
    JPEG_Standard, // Medium compression, jpeg.
    JPEG_High, // High compression, jpeg.
    PNG, // png.
} ImageFormatType;

// Return an image from the given relative path.
+ (void)imageFromRealtivePath:(NSString *)path completion:(void (^)(UIImage *image))completionHandle;

// Save the given image to disk.
+ (void)saveImageToDisk:(UIImage *)image forId:(NSString *)imageId imageFormatType:(ImageFormatType)imageFormatType wait:(BOOL)wait completion:(void (^)(BOOL completed, NSString *imagePath))completionHandled;

// Get the default color for the given position.
+ (UIColor *)colorForPosition:(NSInteger)position;

// Tint the image with the given color.
+ (UIImage *)tintImage:(UIImage *)image withColor:(UIColor *)color;

// Process a single image. Crops it.
+ (UIImage *)processSingleImage:(UIImage *)image maxSize:(CGFloat)maximunWidth;

// Get a random color.
+ (UIColor *)randomColor;

// Return an image tinted with the given color.
+ (UIImage *)image:(UIImage *)image tintedWithColor:(UIColor *)color;

@end
