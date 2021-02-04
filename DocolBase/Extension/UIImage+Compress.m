//
//  UIImage(Compress).m
//  VCLockKit
//
//  Created by XUTAO HUANG on 2020/3/14.
//

#import "UIImage+Compress.h"

@implementation UIImage(Compress)
- (UIImage *)scaleToSize:(CGSize)size{
    
//    NSData* data = UIImagePNGRepresentation(self);
//    if(!data) return nil;
//
//    int maxPixelSize = MAX(size.width, size.height);
//    CFDataRef my_cfdata = CFBridgingRetain(data);
//    CGImageSourceRef imageSource = CGImageSourceCreateWithData(my_cfdata, nil);
//    if(!imageSource) return nil;
//
//      myKeys[0] = kCGImageSourceCreateThumbnailWithTransform;
//     myValues[0] = (CFTypeRef)kCFBooleanTrue;
//     myKeys[1] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
//     myValues[1] = (CFTypeRef)kCFBooleanTrue;
//     myKeys[2] = kCGImageSourceThumbnailMaxPixelSize;
//     myValues[2] = (CFTypeRef)thumbnailSize;
//
//     myOptions = CFDictionaryCreate(NULL, (const void **) myKeys,
//                        (const void **) myValues, 2,
//                        &kCFTypeDictionaryKeyCallBacks,
//                        & kCFTypeDictionaryValueCallBacks);
//
//    let options: [NSString: Any] = [
//        kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
//        kCGImageSourceCreateThumbnailFromImageAlways: true
//    ]
//
//    let resizedImage = CGImageSourceCreateImageAtIndex(imageSource, 0, options as CFDictionary).flatMap{
//        UIImage(cgImage: $0)
//    }
//    return resizedImage
//设置成为当前正在使用的context
UIGraphicsBeginImageContext(size);
//绘制改变大小的图片
[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
//从当前context中创建一个改变大小后的图片
UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//使当前的context出堆栈
UIGraphicsEndImageContext();

// 返回新的改变大小后的图片
return scaledImage;
}
- (NSData *)compressWithMaxLength:(NSUInteger)maxLength{
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}
-(NSData *)compressBySizeWithMaxLength:(NSUInteger)maxLength{
    UIImage *resultImage = self;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return data;
}
- (UIImage *)cropByRect:(CGRect)rect
{
    //CGRect rect = CGRectMake(0, 0, 768, 1024);//创建矩形框
    UIGraphicsBeginImageContext(rect.size);//根据size大小创建一个基于位图的图形上下文
    CGContextRef currentContext = UIGraphicsGetCurrentContext();//获取当前quartz 2d绘图环境
    CGContextClipToRect( currentContext, rect);//设置当前绘图环境到矩形框
    
    CGContextDrawImage(currentContext, rect, self.CGImage);//绘图
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();//获得图片
    UIGraphicsEndImageContext();//从当前堆栈中删除quartz 2d绘图环境
    return cropped;
}
- (UIImage *)cropByRectCenter:(CGSize)centerSize
{
    CGSize imageSize = self.size;
    CGRect rect = CGRectMake((imageSize.width - centerSize.width)/2,
                             (imageSize.height-centerSize.height)/2,
                             centerSize.width,
                             centerSize.height);
    UIGraphicsBeginImageContext(rect.size);//根据size大小创建一个基于位图的图形上下文
    CGContextRef currentContext = UIGraphicsGetCurrentContext();//获取当前quartz 2d绘图环境
    CGContextClipToRect( currentContext, rect);//设置当前绘图环境到矩形框
    
    CGContextDrawImage(currentContext, rect, self.CGImage);//绘图
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();//获得图片
    UIGraphicsEndImageContext();//从当前堆栈中删除quartz 2d绘图环境
    return cropped;
}
- (UIImage *)cropByRectRate:(CGFloat)rate
{
     CGSize imageSize = self.size;
    CGSize cropSize = CGSizeMake(imageSize.width * rate, imageSize.height * rate);
    return [self cropByRectCenter:cropSize];
}
+ (NSData*) compressImage:(UIImage*)originImage PixelCompress:(BOOL)pc MaxPixel:(CGFloat)maxPixel JPEGCompress:(BOOL)jc MaxSize_KB: (CGFloat)maxKB
{
    /*
     压缩策略： 支持最多921600个像素点
        像素压缩：（调整像素点个数）
            当图片长宽比小于3:1 or 1:3时，图片长和宽最多为maxPixel像素；
            当图片长宽比在3:1 和 1:3之间时，会保证图片像素压缩到921600像素以内；
        JPEG压缩：（调整每个像素点的存储体积）
            默认压缩比0.99;
            如果压缩后的数据仍大于IMAGE_MAX_BYTES，那么将调整压缩比将图片压缩至IMAGE_MAX_BYTES以下。
     策略调整：
        不进行像素压缩，或者增大maxPixel，像素损失越小。
        使用无损压缩，或者增大IMAGE_MAX_BYTES.
     注意：
        jepg压缩比为0.99时，图像体积就能压缩到原来的0.40倍了。
     */
    UIImage * scopedImage = nil;
    NSData * data = nil;
    //CGFloat maxbytes = maxKB * 1024;
 
    if (originImage == nil) {
        return nil;
    }
    
    if ( pc == YES ) {    //像素压缩
        // 像素数最多为maxPixel*maxPixel个
        CGFloat photoRatio = originImage.size.height / originImage.size.width;
        if ( photoRatio < 0.3333f )
        {                           //解决宽长图的问题
            CGFloat FinalWidth = sqrt ( maxPixel*maxPixel/photoRatio );
            scopedImage = [UIImage convertImage:originImage scope:MAX(FinalWidth, maxPixel)];
        }
        else if ( photoRatio <= 3.0f )
        {                           //解决高长图问题
            scopedImage = [UIImage convertImage:originImage scope: maxPixel];
        }
        else
        {                           //一般图片
            CGFloat FinalHeight = sqrt ( maxPixel*maxPixel*photoRatio );
            scopedImage = [UIImage convertImage:originImage scope:MAX(FinalHeight, maxPixel)];
        }
    }
    else {          //不进行像素压缩
        scopedImage = originImage;
    }
    
//    [scopedImage retain];
    
    if ( jc == YES ) {     //JPEG压缩
        data = UIImageJPEGRepresentation(scopedImage, 0.8);
        NSLog(@"data compress with ratio (0.9) : %lu KB", data.length/1024);
    }
    else {
        data = UIImageJPEGRepresentation(scopedImage, 1.0);
        NSLog(@"data compress : %lu KB", data.length/1024);
    }
    
//    [scopedImage release];
    
    return data;
}
+ (UIImage *)convertImage:(UIImage *)origImage scope:(CGFloat)scope
{
    UIImage *image = nil;
    CGSize size = origImage.size;
    if (size.width < scope && size.height < scope) {
        // do nothing
        image = origImage;
    } else {
        CGFloat length = size.width;
        if (size.width < size.height) {
            length = size.height;
        }
        CGFloat f = scope/length;
        NSInteger nw = size.width * f;
        NSInteger nh = size.height * f;
        if (nw > scope) {
            nw = scope;
        }
        if (nh > scope) {
            nh = scope;
        }
 
        CGSize newSize = CGSizeMake(nw, nh);
//        CGSize newSize = CGSizeMake(size.width*f, size.height*f);
        
        //
        UIGraphicsBeginImageContext(newSize);
        //UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
        // Tell the old image to draw in this new context, with the desired
        // new size
        [origImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        // Get the new image from the context
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}
@end
