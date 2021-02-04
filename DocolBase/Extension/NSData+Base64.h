//
//  NSData+CC.h
//  
//
//  Created by Michael Du on 13-4-15.
//  Copyright (c) 2013年 MichaelDu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CC)

- (NSData *)base64Decoded;
- (NSString *)base64Encoded;

+(NSData*)byteCut:(NSData *) bytes offset:(int) offset len:(int) len;
+(NSData*) fromLong:(long long) n len:(int)len;
+(NSData*) fromInt:(int) n len:(int)len;
+(NSData*) fromShort:(short) n len:(int)len;

+(Byte) mergeInt:(int) a b:(int) b;
+(int) byteArrayToInt:(Byte[]) b;
+(int) byteArrayToShort:(Byte[]) b;

@end
