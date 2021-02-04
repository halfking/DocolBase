//
//  NSDataGZipAdditions.h
//  HotelCloud
//
//  Created by XUTAO HUANG on 12-12-31.
//  Copyright (c) 2012年 Suixing. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (GZip)

+ (id) compressedDataWithBytes: (const void*) bytes length: (unsigned) length;
+ (id) compressedDataWithData: (NSData*) data;

+ (id) dataWithCompressedBytes: (const void*) bytes length: (unsigned) length;
+ (id) dataWithCompressedData: (NSData*) compressedData;

@end
