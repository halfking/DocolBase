//
//  ByteUtils.h
//  VSBLETest
//
//  Created by XUTAO HUANG on 2018/6/10.
//  Copyright © 2018年 XUTAO HUANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ByteUtils : NSObject
+(NSData*)byteCut:(NSData *) bytes offset:(int) offset len:(int) len;
+(Byte) mergeInt:(int) a b:(int) b;
+(int) byteArrayToInt:(Byte[]) b;
+(int) byteArrayToShort:(Byte[]) b;
+(NSData*) fromLong:(long long) n len:(int)len;
+(NSData*) fromInt:(int) n len:(int)len;
+(NSData*) fromShort:(short) n len:(int)len;
@end
