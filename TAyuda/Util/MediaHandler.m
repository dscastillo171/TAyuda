//
//  MediaHandler.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/17/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "MediaHandler.h"

@implementation MediaHandler

// Return an image's hash.
+ (NSString *)hashFromData:(NSData *)data{
    NSMutableString *string = nil;
    if(data){
        // Create byte array of unsigned chars.
        unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
        
        // Create 16 byte MD5 hash value, store in buffer
        CC_MD5(data.bytes, (int)data.length, md5Buffer);
        
        // Convert unsigned char buffer to NSString of hex values
        string = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
            [string appendFormat:@"%02x", md5Buffer[i]];
        }
    }
    return string;
}

// Return an image from the given relative path.
+ (void)imageFromRealtivePath:(NSString *)path completion:(void (^)(UIImage *image))completionHandle{
    // Parameter must be valid.
    if(!path){
        completionHandle(nil);
        return;
    }
    
    // Image Cache.
    static NSCache *imageCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[NSCache alloc] init];
    });
    
    // Fetch the image if it isn't cached.
    UIImage *result = [imageCache objectForKey:path];
    if(result){
        completionHandle(result);
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:path]];
            if(image){
                [imageCache setObject:image forKey:path];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandle(image);
                });
            }
        });
    }
}

// Saves an image to the disk.
+ (void)saveImageToDisk:(UIImage *)image forId:(NSString *)imageId imageFormatType:(ImageFormatType)imageFormatType wait:(BOOL)wait completion:(void (^)(BOOL completed, NSString *imagePath))completionHandled{
    void (^methodBlock)(void) = ^{
        if(image && completionHandled){
            NSString *imageName = nil;
            NSString *extension = imageFormatType == PNG? @"png": @"jpeg";
            if(image.scale == 2.0){
                imageName = [NSString stringWithFormat:@"%@@2x.%@", imageId, extension];
            } else{
                imageName = [NSString stringWithFormat:@"%@.%@", imageId, extension];
            }
            NSData *imageData;
            if(imageFormatType == PNG){
                imageData = UIImagePNGRepresentation(image);
            } else{
                imageData = UIImageJPEGRepresentation(image, imageFormatType == JPEG_High? HIGH_IMAGE_COMPRESSION: LOW_IMAGE_COMPRESSION);
            }
            
            NSString *imagePath = [DIR_IMAGES stringByAppendingPathComponent:imageName];
            if([imageData writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:imagePath] atomically:YES]){
                completionHandled(YES, imagePath);
            } else{
                completionHandled(NO, nil);
            }
        } else if(completionHandled){
            completionHandled(NO, nil);
        }
    };
    
    // Dispatch the call synchronously or asynchronously.
    if(wait){
        methodBlock();
    } else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), methodBlock);
    }
}

// Get the default color for the given position.
+ (UIColor *)colorForPosition:(NSInteger)position{
    UIColor *color;
    if(position == 0){
        color = [UIColor colorWithRed:238/255.0 green:229/255.0 blue:78/255.0 alpha:1.0];
    } else if(position == 1){
        color = [UIColor colorWithRed:164/255.0 green:217/255.0 blue:69/255.0 alpha:1.0];
    } else if(position == 2){
        color = [UIColor colorWithRed:0/255.0 green:191/255.0 blue:80/255.0 alpha:1.0];
    } else if(position == 3){
        color = [UIColor colorWithRed:0/255.0 green:146/255.0 blue:146/255.0 alpha:1.0];
    } else if(position == 4){
        color = [UIColor colorWithRed:68/255.0 green:183/255.0 blue:228/255.0 alpha:1.0];
    } else if(position == 5){
        color = [UIColor colorWithRed:58/255.0 green:100/255.0 blue:185/255.0 alpha:1.0];
    } else if(position == 6){
        color = [UIColor colorWithRed:148/255.0 green:66/255.0 blue:140/255.0 alpha:1.0];
    } else if(position == 7){
        color = [UIColor colorWithRed:255/255.0 green:50/255.0 blue:57/255.0 alpha:1.0];
    } else if(position == 8){
        color = [UIColor colorWithRed:255/255.0 green:85/255.0 blue:2/255.0 alpha:1.0];
    } else{
        color = [UIColor colorWithRed:255/255.0 green:190/255.0 blue:68/255.0 alpha:1.0];
    }
    return color;
}

// Get a random color.
+ (UIColor *)randomColor{
    return [MediaHandler colorForPosition:arc4random() % 10];
}

// Tint the image with the given color.
+ (UIImage *)tintImage:(UIImage *)image withColor:(UIColor *)color{
    // Create the core image context once.
    static CIContext *context;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{
        context = [CIContext contextWithOptions:nil];
    });
    
    // Darken the image.
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIColor *darkReference = [[CIColor alloc] initWithColor:[UIColor colorWithWhite:189/255.0 alpha:1.0]];
    CIFilter *darkFilter = [CIFilter filterWithName:@"CIWhitePointAdjust" keysAndValues:@"inputImage", inputImage, @"inputColor", darkReference, nil];
    inputImage = [darkFilter outputImage];
    
    // Tint the image.
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:@"inputImage", inputImage, @"inputColor", [[CIColor alloc] initWithColor:color], @"inputIntensity", @1.0, nil];
    inputImage = [colorFilter outputImage];
    
    // Create the resulting image.
    CGImageRef resultRef = [context createCGImage:inputImage fromRect:[inputImage extent]];
    UIImage *result = [UIImage imageWithCGImage:resultRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(resultRef);
    
    return result;
}

// Process a single image. Crops it.
+ (UIImage *)processSingleImage:(UIImage *)image maxSize:(CGFloat)maximunWidth{
    if(image && maximunWidth){
        // Crop the image.
        CGRect cropBounds;
        CGFloat scale;
        CGFloat resultingSize;
        if(image.size.width >= image.size.height){
            scale = maximunWidth / image.size.height;
            cropBounds = CGRectMake((image.size.width - image.size.height) / -2, 0, image.size.width, image.size.height);
            resultingSize = image.size.height;
        } else{
            scale = maximunWidth / image.size.width;
            cropBounds = CGRectMake(0, (image.size.height - image.size.width) / -2, image.size.width, image.size.height);
            resultingSize = image.size.width;
        }
        
        // Scale if needed.
        if(scale < 1.0){
            cropBounds.origin.x *= scale;
            cropBounds.origin.y *= scale;
            cropBounds.size.width *= scale;
            cropBounds.size.height *= scale;
            resultingSize = maximunWidth;
        }
        
        // Round up.
        cropBounds = CGRectIntegral(cropBounds);
        
        // Draw the resulting image.
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(resultingSize, resultingSize), NO, 0.0);
        [image drawInRect:cropBounds];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return image;
}

// Return an image tinted with the given color.
+ (UIImage *)image:(UIImage *)image tintedWithColor:(UIColor *)color{
    // Tinted images cache.
    static NSCache *tintedImagesCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tintedImagesCache = [[NSCache alloc] init];
    });
    NSString *hash = [NSString stringWithFormat:@"%lu-%lu", (unsigned long)image.hash, (unsigned long)color.hash];
    
    UIImage *result = [tintedImagesCache objectForKey:hash];
    if(!result){
        // Initialize the context.
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, image.size.width * image.scale, image.size.height * image.scale, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
        CGContextClipToMask(context, CGRectMake(0, 0, image.size.width * image.scale, image.size.height * image.scale), image.CGImage);
        
        // Fill with color.
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, image.size.width * image.scale, image.size.height * image.scale));
        
        // Extract the image.
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
        CGImageRelease(imageRef);
        
        // Add it to the cache.
        if(result){
            [tintedImagesCache setObject:result forKey:hash];
        }
    }
    
    return result;
}

@end
