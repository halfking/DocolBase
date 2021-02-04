//
//  NSString(hex).m
//  VSBLETest
//
//  Created by XUTAO HUANG on 2018/6/10.
//  Copyright © 2018年 XUTAO HUANG. All rights reserved.
//

#import "NSString+Hex.h"

@implementation NSString(hex)
+ (instancetype)stringWithBytesWithSplit:(NSData *)data
{
    return [self stringWithBytes:(Byte*)data.bytes length:(int)data.length withSplit:TRUE];
}
+ (instancetype)stringWithBytes:(NSData *)data
{
    return [self stringWithBytes:(Byte*)data.bytes length:(int)data.length withSplit:FALSE];
}
+ (instancetype)stringWithBytes:(Byte [])bytes length:(int)length
{
    return [self stringWithBytes:bytes length:length withSplit:TRUE];
}
+ (instancetype)stringWithBytes:(Byte [])bytes length:(int)length withSplit:(BOOL)withSplit
{
    if (!bytes || length == 0) {
        return @"";
    }
    // NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    /**
     将切割好的十六进制数塞入一个可变数组
     */
    NSMutableArray *dataArr = [NSMutableArray new];
    
    unsigned char *dataBytes = (unsigned char*)bytes;
    
    for (NSInteger i = 0; i < length; i++) {
        
        /**
         将byte数组切割成一个个字符串
         */
        NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
        // NSLog(@"%@",hexStr);
        /**
         因十六进制数据为 0X XXXX 以两字节为一位数,所以需要在切割出来的数据进行补零操作
         */
        
        if ([hexStr length] == 2) {
            // [string appendString:hexStr];
            [dataArr addObject:hexStr];
        } else {
            //[string appendFormat:@"0%@", hexStr];
            
            [dataArr addObject:[NSString stringWithFormat:@"0%@",hexStr]];
        }
        if(withSplit)
        {
            
            if(i%32==31)
            {
                [dataArr addObject:@"\r\t\t\t"];
            }
            else if(i%8==7)
            {
                [dataArr addObject:@" "];
            }
        }
    }
    // NSLog(@"-------->%@",dataArr);
    
    
    return [dataArr componentsJoinedByString:@""];
}

+ (NSData *)hexStringToBytes:(NSString *)hexString
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx < hexString.length;) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hexString substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
        idx ++;
        idx ++;
    }
    
    return data;
}

+(float)byteToFloat:(NSData *)data {
    Byte * bytes = (Byte *)[data bytes];
    float result = 0.0;
    NSInteger length = [data length];
    
    for (int i = 0; i < length; i++) {
        if (i == length - 1) {
            int tmp = [self byteToInt:bytes[i]];
            result += tmp;
        }else {
            int tmp = [self byteToInt:bytes[i]];
            result += tmp*pow(10, length - i - 2);
        }
    }
    
    return result;
}

+(int)byteToInts:(NSData *)data {
    Byte* bytes = (Byte*)data.bytes;
    int len = (int)data.length;
    int ret = 0;
    for (int i = 0;i<len;i++) {
        ret += ((bytes[i]&0xFF) << ((len-i -1)*8));
    }
    return ret;
//    return [self hexStringToInt:[self stringWithBytes:data]];
}

+(int)byteToInt:(Byte)byte {
    return byte &0xFF;
    
//    Byte tmp[1] = {byte};
//    NSData * data = [[NSData alloc]initWithBytes:tmp length:1];
//    
//    return [self hexStringToInt:[self stringWithBytes:data]];
}


+(int)hexStringToInt:(NSString *)hexString {
    int sum = 0;
    for (int i = 0; i < [hexString length]; i++) {
        char s = [hexString characterAtIndex:i];
        int tmp = [[NSNumber numberWithChar:s] intValue];
        
        if(s >= '0' && s <= '9')
            tmp = (tmp-48);   // 0 的Ascll - 48
        else if(s >= 'A' && s <= 'F')
            tmp = (tmp-55); // A 的Ascll - 65
        else
            tmp = (tmp-87); // a 的Ascll - 97
        
        sum += tmp*pow(16, [hexString length] - i - 1);
    }
    
    return sum;
}
+ (NSString *)stringFromDouble:(double)value numberCount:(int)numberCount
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setUsesSignificantDigits: YES];
    numberFormatter.maximumSignificantDigits = numberCount>0?numberCount:10;
    [numberFormatter setGroupingSeparator:@""];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [numberFormatter stringFromNumber:@(value)];
}
@end
