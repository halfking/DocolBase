//
//  NSData+Tea.m
//  VSBLETest
//
//  Created by XUTAO HUANG on 2018/6/15.
//  Copyright © 2018年 XUTAO HUANG. All rights reserved.
//

#import "NSData+Tea.h"
#import "NSString+Hex.h"

@implementation NSData(Tea)


void code(unsigned int*v, unsigned int*k) {
    unsigned int y = v[0], z = v[1], sum = 0, i; /*setup*/
    unsigned int delta = 0x9e3779b9; /*akeyscheduleconstant*/
    unsigned int k0 = k[0], k1 = k[1], k2 = k[2], k3 = k[3]; /*cachekey*/
    for (i = 0; i<16; i++) {
        /*basiccyclestart*/
        sum += delta;
        y += (z << 4) + k0 ^ z + sum ^ (z >> 5) + k1;
        z += (y << 4) + k2 ^ y + sum ^ (y >> 5) + k3;
    } /*endcycle*/
    v[0] = y;
    v[1] = z;
}

void decode(unsigned int*v, unsigned int*k) {
    unsigned int y = v[0], z = v[1], sum = 0, i; /*setup 0xC6EF3720*/
    unsigned int delta = 0x9e3779b9; /*akeyscheduleconstant*/
    unsigned int k0 = k[0], k1 = k[1], k2 = k[2], k3 = k[3]; /*cachekey*/
    
    sum = delta << 4;
    for (i = 0; i < 16; i++) {
        /*basiccyclestart*/
        z -= (y << 4) + k2 ^ y + sum ^ (y >> 5) + k3;
        y -= (z << 4) + k0 ^ z + sum ^ (z >> 5) + k1;
        sum -= delta;
    } /*endcycle*/
    v[0] = y;
    v[1] = z;
}
uint8_t calcCrc(uint8_t *pucBuf,unsigned short usLen)
{
    unsigned short ii = 0;
    uint8_t ucTmp = 0;
    for(ii = 0; ii < usLen; ii++)
    {
        ucTmp ^= pucBuf[ii];
    }
    return ucTmp;
}
+ (Byte)crc:(NSData *)data offset:(int)offset len:(int)length
{
    if(data==nil) return 0x00;
    uint8_t * temp = (uint8_t *)data.bytes;
    
    uint8_t ucTmp = calcCrc(temp+offset,(unsigned short) length);
    return (Byte)ucTmp;
}
- (NSData *)tea_encrypt:(NSString *)key
{
    int i;
    uint len = (uint)[self length];
    NSData * keyData = [NSString hexStringToBytes:key];
    uint * keys = (uint *)keyData.bytes;
    if ((len % 8) != 0)
    {
        return nil;
    }
    Byte encryptBytes[len];
    memcpy(encryptBytes, self.bytes,len);
 
    for (i = 0; i < len; i += 8)
    {
        code((unsigned int*)(encryptBytes+i), keys);
    }
    return [NSData dataWithBytes:encryptBytes length:len];
}
- (NSData *)tea_decrypt:(NSString *)key
{
    int i;
    uint len = (uint)[self length];
    
    NSData * keyData = [NSString hexStringToBytes:key];
    uint * keys = (uint *)keyData.bytes;
    if ((len % 8) != 0)
    {
        return nil;
    }
    Byte decryptBytes[len];
    memcpy(decryptBytes, self.bytes,len);
    
    for (i = 0; i < len; i += 8)
    {
        decode((unsigned int*)(decryptBytes +i), (unsigned int*)keys);
    }
    return [NSData dataWithBytes:decryptBytes length:len];
}
- (NSData *)tea_encryptN:(unsigned char *)keys
{
    int i;
    //对齐8字节
    uint len = (uint)[self length];
//    uint originLength = len;
    if ((len % 8) != 0)
    {
        len = (len /8 +1) * 8;
    }
   
    Byte encryptBytes[len];
    memcpy(encryptBytes, self.bytes,[self length]);
    
    //因为数据头已经加了长度，因此后面不需要置空了。
//    //多余的字节要置空
//    if(len > originLength)
//    {
//        memset((Byte *)encryptBytes + originLength,0x00,len - originLength);
//    }
//    NSLog(@"ready encrypt:%@",[NSString stringWithBytes:encryptBytes length:len]);
    for (i = 0; i < len; i += 8)
    {
        code((unsigned int*)(encryptBytes+i), (uint *)keys);
    }
    return [NSData dataWithBytes:encryptBytes length:len];
}
- (NSData *)tea_decryptN:(unsigned char *)keys
{
    int i;
    uint len = (uint)[self length];
    
    if ((len % 8) != 0)
    {
        return nil;
    }
    Byte decryptBytes[len];
    memcpy(decryptBytes, self.bytes,len);
    
    for (i = 0; i < len; i += 8)
    {
        decode((unsigned int*)(decryptBytes +i), (unsigned int*)keys);
    }
    return [NSData dataWithBytes:decryptBytes length:len];
}
@end
