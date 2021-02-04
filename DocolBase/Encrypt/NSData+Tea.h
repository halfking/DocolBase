//
//  NSData+Tea.h
//  VSBLETest
//
//  Created by XUTAO HUANG on 2018/6/15.
//  Copyright © 2018年 XUTAO HUANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(Tea)
+ (Byte)crc:(NSData *)data offset:(int)offset len:(int)length;
- (NSData *)tea_encrypt:(NSString *)key;
- (NSData *)tea_decrypt:(NSString *)key;
- (NSData *)tea_encryptN:(unsigned char *)key;
- (NSData *)tea_decryptN:(unsigned char *)key;

@end
