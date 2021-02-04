//
//  NSString(image+base64).h
//  SmartLock
//
//  Created by XUTAO HUANG on 2018/8/22.
//  Copyright © 2018年 Richard Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(base64)
+ (UIImage *) imageWithBase64:(NSString *)base64String;
+ (UIImage *) imageWithURL: (NSString *) imgSrc;
+ (BOOL) alphaExist: (UIImage *) image;
+ (NSString *) base64WithImage: (UIImage *) image forceJpeg:(BOOL)forceJpeg;
@end
