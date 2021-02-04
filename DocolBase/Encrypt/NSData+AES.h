//
//  NSData+AES.h
//  VSBLETest
//
//  Created by XUTAO HUANG on 2018/6/15.
//  Copyright © 2018年 XUTAO HUANG. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSData (AES)
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;
//- (NSString *)base64Encoding;
//+ (id)dataWithBase64EncodedString:(NSString *)string;
@end
