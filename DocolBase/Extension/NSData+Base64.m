//
//  NSData+CC.m
//  
//
//  Created by Michael Du on 13-4-15.
//  Copyright (c) 2013年 MichaelDu. All rights reserved.
//

#import "NSData+Base64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (CC)

static char encodingTable[64] = {
        'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
        'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
        'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
        'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/' };


- (NSData *)base64Decoded
{
	const unsigned char	*bytes = [self bytes];
	NSMutableData *result = [NSMutableData dataWithCapacity:[self length]];
	
	unsigned long ixtext = 0;
	unsigned long lentext = [self length];
	unsigned char ch = 0;
	unsigned char inbuf[4] = {0, 0, 0, 0};
	unsigned char outbuf[3] = {0, 0, 0};
	short i = 0, ixinbuf = 0;
	BOOL flignore = NO;
	BOOL flendtext = NO;
	
	while( YES )
	{
		if( ixtext >= lentext ) break;
		ch = bytes[ixtext++];
		flignore = NO;
		
		if( ( ch >= 'A' ) && ( ch <= 'Z' ) ) ch = ch - 'A';
		else if( ( ch >= 'a' ) && ( ch <= 'z' ) ) ch = ch - 'a' + 26;
		else if( ( ch >= '0' ) && ( ch <= '9' ) ) ch = ch - '0' + 52;
		else if( ch == '+' ) ch = 62;
		else if( ch == '=' ) flendtext = YES;
		else if( ch == '/' ) ch = 63;
		else flignore = YES;
		
		if( ! flignore )
		{
			short ctcharsinbuf = 3;
			BOOL flbreak = NO;
			
			if( flendtext )
			{
				if( ! ixinbuf ) break;
				if( ( ixinbuf == 1 ) || ( ixinbuf == 2 ) ) ctcharsinbuf = 1;
				else ctcharsinbuf = 2;
				ixinbuf = 3;
				flbreak = YES;
			}
			
			inbuf [ixinbuf++] = ch;
			
			if( ixinbuf == 4 )
			{
				ixinbuf = 0;
				outbuf [0] = ( inbuf[0] << 2 ) | ( ( inbuf[1] & 0x30) >> 4 );
				outbuf [1] = ( ( inbuf[1] & 0x0F ) << 4 ) | ( ( inbuf[2] & 0x3C ) >> 2 );
				outbuf [2] = ( ( inbuf[2] & 0x03 ) << 6 ) | ( inbuf[3] & 0x3F );
				
				for( i = 0; i < ctcharsinbuf; i++ )
					[result appendBytes:&outbuf[i] length:1];
			}
			
			if( flbreak )  break;
		}
	}
	
	return [NSData dataWithData:result];
}

- (NSString *)base64Encoded
{
	const unsigned char	*bytes = [self bytes];
	NSMutableString *result = [NSMutableString stringWithCapacity:[self length]];
	unsigned long ixtext = 0;
	unsigned long lentext = [self length];
	long ctremaining = 0;
	unsigned char inbuf[3], outbuf[4];
	unsigned short i = 0;
	unsigned short charsonline = 0, ctcopy = 0;
	unsigned long ix = 0;
	
	while( YES )
	{
		ctremaining = lentext - ixtext;
		if( ctremaining <= 0 ) break;
		
		for( i = 0; i < 3; i++ ) {
			ix = ixtext + i;
			if( ix < lentext ) inbuf[i] = bytes[ix];
			else inbuf [i] = 0;
		}
		
		outbuf [0] = (inbuf [0] & 0xFC) >> 2;
		outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
		outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
		outbuf [3] = inbuf [2] & 0x3F;
		ctcopy = 4;
		
		switch( ctremaining )
		{
			case 1:
				ctcopy = 2;
				break;
			case 2:
				ctcopy = 3;
				break;
		}
		
		for( i = 0; i < ctcopy; i++ )
			[result appendFormat:@"%c", encodingTable[outbuf[i]]];
		
		for( i = ctcopy; i < 4; i++ )
			[result appendString:@"="];
		
		ixtext += 3;
		charsonline += 4;
	}
	
	return [NSString stringWithString:result];
}

+(NSData*) fromShort:(short) n len:(int)len
{
    Byte bytes[2];
    bytes[0] = (Byte)(((n&0xFF00)>>8)&0xFF);
    bytes[1] = (Byte)(n & 0xFF);
    if(len>1)
        return [NSData dataWithBytes:bytes length:2];
    else
        return [NSData dataWithBytes:bytes+1 length:1];
}

+(NSData*) fromInt:(int) n len:(int)len
{
    Byte bytes[4];
    bytes[0] = (Byte)(((n&0xFF000000)>>24)&0xFF);
    bytes[1] = (Byte)(((n&0xFF0000)>>16)&0xFF);
    bytes[2] = (Byte)(((n&0xFF00)>>8)&0xFF);
    bytes[3] = (Byte)(n & 0xFF);
    if(len>=4 || len <=0)
        return [NSData dataWithBytes:bytes length:4];
    else
        return [NSData dataWithBytes:bytes+(4-len) length:len];
}
+(NSData*) fromLong:(long long) n len:(int)len
{
    Byte bytes[8];
    bytes[0] = (Byte)(((n&0xFF00000000000000)>>60)&0xFF);
    bytes[1] = (Byte)(((n&0xFF000000000000)>>48)&0xFF);
    bytes[2] = (Byte)(((n&0xFF0000000000)>>40)&0xFF);
    bytes[3] = (Byte)(((n&0xFF00000000)>>32)& 0xFF);
    bytes[4] = (Byte)(((n&0xFF000000)>>24)&0xFF);
    bytes[5] = (Byte)(((n&0xFF0000)>>16)&0xFF);
    bytes[6] = (Byte)(((n&0xFF00)>>8)&0xFF);
    bytes[7] = (Byte)(n & 0xFF);
    if(len>=8 || len <=0)
        return [NSData dataWithBytes:bytes length:8];
    else
        return [NSData dataWithBytes:bytes+(8-len) length:len];
}

+(NSData*)byteCut:(NSData *) bytes offset:(int) offset len:(int) len
{
    NSData * data = [bytes subdataWithRange:NSMakeRange(offset, len)];
    return data;
}


    /**
     * 合并两个int到一个byte
     * int要求小于15，否则将丢失数据
     *
     * @param a 前半段字节
     * @param b 后半段字节
     * @return 两者组合的字节
     */
+(Byte) mergeInt:(int) a b:(int) b
{
        return (Byte) (a << 4 | b);
}
    
+(int) byteArrayToInt:(Byte[]) b
{
    int f = ((b[0]& 0xFF) <<24) + ((b[1] &0xFF) <<16) + ((b[2]&0xFF)<<8) +(b[3]&0xFF);
    return f;//a+c+d+e;
}
    
+(int) byteArrayToShort:(Byte[]) b {
    return ((b[0]& 0xFF) <<8) + (b[1] &0xFF);
}
@end
