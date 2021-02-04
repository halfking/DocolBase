//
//  NSData+AES256.h
//  VSBLETest
//
//  Created by XUTAO HUANG on 2018/6/15.
//  Copyright © 2018年 XUTAO HUANG. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData(AES256)

- (NSData *)aes256_encrypt:(NSString *)key;
- (NSData *)aes256_decrypt:(NSString *)key;

@end
