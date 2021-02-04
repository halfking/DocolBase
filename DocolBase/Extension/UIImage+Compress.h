//
//  UIImage(Compress).h
//  VCLockKit
//
//  Created by XUTAO HUANG on 2020/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage(Compress)
- (UIImage *)scaleToSize:(CGSize)size;
- (NSData *)compressBySizeWithMaxLength:(NSUInteger)maxLength;
- (UIImage *)cropByRect:(CGRect)rect;
- (UIImage *)cropByRectCenter:(CGSize)centerSize;
- (UIImage *)cropByRectRate:(CGFloat)rate;

- (NSData *)compressWithMaxLength:(NSUInteger)maxLength;

/*
 *    @brief    压缩图片 @Fire
 *
 *    @param     originImage     原始图片
 *    @param     pc     是否进行像素压缩
 *    @param     maxPixel     压缩后长和宽的最大像素；pc=NO时，此参数无效。
 *    @param     jc     是否进行JPEG压缩
 *    @param     maxKB     图片最大体积，以KB为单位；jc=NO时，此参数无效。
 *
 *    @return    返回图片的NSData
 */
+ (NSData*) compressImage:(UIImage*)originImage PixelCompress:(BOOL)pc MaxPixel:(CGFloat)maxPixel JPEGCompress:(BOOL)jc MaxSize_KB:(CGFloat)maxKB;
+ (UIImage *)convertImage:(UIImage *)origImage scope:(CGFloat)scope;
@end

NS_ASSUME_NONNULL_END
