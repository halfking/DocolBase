//
//  NSString(image+base64).m
//  SmartLock
//
//  Created by XUTAO HUANG on 2018/8/22.
//  Copyright © 2018年 Richard Shen. All rights reserved.
//

#import "UIImage+Base64.h"

@implementation UIImage(base64)
+ (UIImage *) imageWithBase64:(NSString *)base64String
{
   NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64String
                                                           options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    UIImage *decodedImage = [UIImage imageWithData: decodeData];
    return decodedImage;
}
+ (UIImage *) imageWithURL: (NSString *) imgSrc
{
    NSURL *url = [NSURL URLWithString: imgSrc];
    NSData *data = [NSData dataWithContentsOfURL: url];
    UIImage *image = [UIImage imageWithData: data];
    
    return image;
}
+ (BOOL) alphaExist: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
+ (NSString *) base64WithImage: (UIImage *) image forceJpeg:(BOOL)forceJpeg
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if (!forceJpeg && [self alphaExist: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
    
}
@end
