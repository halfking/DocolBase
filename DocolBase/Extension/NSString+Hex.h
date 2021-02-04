//
//  NSString(hex).h
//  VSBLETest
//
//  Created by XUTAO HUANG on 2018/6/10.
//  Copyright © 2018年 XUTAO HUANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(hex)
+ (instancetype)stringWithBytesWithSplit:(NSData *)data;
+ (instancetype)stringWithBytes:(NSData *)data;
+ (instancetype)stringWithBytes:(Byte[])bytes length:(int)length;
+ (instancetype)stringWithBytes:(Byte [])bytes length:(int)length withSplit:(BOOL)withSplit;

+ (NSData *)hexStringToBytes:(NSString *)hexString;
+ (int)hexStringToInt:(NSString *)hexString;
+ (int)byteToInt:(Byte)byte;
+ (int)byteToInts:(NSData *)data;
+ (float)byteToFloat:(NSData *)data;
+ (NSString *)stringFromDouble:(double)value numberCount:(int)numberCount;

@end
