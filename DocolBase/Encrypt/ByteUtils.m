//
//  ByteUtils.m
//  VSBLETest
//
//  Created by XUTAO HUANG on 2018/6/10.
//  Copyright © 2018年 XUTAO HUANG. All rights reserved.
//

#import "ByteUtils.h"

@implementation ByteUtils
//    static Byte EMPTY_BYTES = new byte[]{};

//    static int BYTE_MAX = 0xff;

//    public static byte[] getNonEmptyByte(byte[] bytes) {
//        return bytes != null ? bytes : EMPTY_BYTES;
//    }
//
//    public static boolean isEmpty(byte[] bytes) {
//        return bytes == null || bytes.length == 0;
//    }
//
//    //16进制字符串转换byte[]
//    public static byte[] stringToBytes(String text) {
//        int len = text.length();
//        byte[] bytes = new byte[(len + 1) / 2];
//        for (int i = 0; i < len; i += 2) {
//            int size = Math.min(2, len - i);
//            String sub = text.substring(i, i + size);
//            bytes[i / 2] = (byte) Integer.parseInt(sub, 16);
//        }
//        return bytes;
//    }
//
//    //byte[]转换为16进制字符串
//    public static String byteToString(byte[] bytes) {
//        StringBuilder sb = new StringBuilder();
//
//        if (!isEmpty(bytes)) {
//            for (int i = 0; i < bytes.length; i++) {
//                sb.append(String.format(Locale.getDefault(), "%02X", bytes[i]));
//            }
//        }
//
//        return sb.toString();
//    }
//
//    //byte[]转换为16进制字符串
//    public static String byteToMacAddress(byte[] bytes) {
//        StringBuilder sb = new StringBuilder();
//        if (!isEmpty(bytes)) {
//            for (int i = 0; i < bytes.length; i++) {
//                sb.append(String.format(Locale.getDefault(), "%02X", bytes[i]) + ":");
//            }
//        }
//        String result = sb.toString();
//        result = result.substring(0, result.length() - 1);
//        return result;
//    }
//
//    public static byte[] trimLast(byte[] bytes) {
//        int i = bytes.length - 1;
//        for (; i >= 0; i--) {
//            if (bytes[i] != 0) {
//                break;
//            }
//        }
//        return Arrays.copyOfRange(bytes, 0, i + 1);
//    }
//
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
//
//    /**
//     * 将255之内的int类型的数据转换为byte
//     *
//     * @param n int数据
//     */
//    public static byte intToByte(int n) {
//        String hexStr = Integer.toHexString(n);
//        byte[] iByte = stringToBytes(hexStr);
//
//        return iByte[0];
//    }
//
//    public static int ubyteToInt(byte b) {
//        return (int) b & 0x00FF;
//    }
//
//    public static byte[] double2Byte(double data, int len) {
//        String str = String.format(Locale.getDefault(), "%" + len + "d", data);
//
//        return str.getBytes();
//    }
//
//
//    /**
//     * 将int类型的数据转换为byte数组 原理：将int数据中的四个byte取出，分别存储
//     *
//     * @param n   int数据
//     * @param len 长度，不能大于4
//     * @return 生成的byte数组
//     */
//    public static byte[] intToBytes(int n, int len) {
//        byte[] ret = new byte[len];
//        byte[] b = new byte[4];
//        for (int i = 0; i < 4; i++) {
//            b[i] = (byte) (n >> (24 - i * 8));
//        }
//        for (int i = 0; i < len; i++) {
//            ret[i] = b[4 - len + i];
//        }
//        return ret;
//    }
//
//    public static boolean byteEquals(byte[] lbytes, byte[] rbytes) {
//        if (lbytes == null && rbytes == null) {
//            return true;
//        }
//
//        if (lbytes == null || rbytes == null) {
//            return false;
//        }
//
//        int llen = lbytes.length;
//        int rlen = rbytes.length;
//
//        if (llen != rlen) {
//            return false;
//        }
//
//        for (int i = 0; i < llen; i++) {
//            if (lbytes[i] != rbytes[i]) {
//                return false;
//            }
//        }
//
//        return true;
//    }
//
//    public static byte[] fillBeforeBytes(byte[] bytes, int len, byte fill) {
//        byte[] result = bytes;
//        int oldLen = (bytes != null ? bytes.length : 0);
//
//        if (oldLen < len) {
//            result = new byte[len];
//
//            for (int i = len - 1, j = oldLen - 1; i >= 0; i--, j--) {
//                if (j >= 0) {
//                    result[i] = bytes[j];
//                } else {
//                    result[i] = fill;
//                }
//            }
//        }
//
//        return result;
//    }
//
//    public static byte[] fillAfterBytes(byte[] bytes, int len, byte fill) throws Exception {
//        byte[] result = null;
//        int oldLen = (bytes != null ? bytes.length : 0);
//
//        if (oldLen < len) {
//            result = new byte[len];
//
//            for (int i = 0, j = 0; i < len; i++, j++) {
//                if (j < oldLen) {
//                    result[i] = bytes[j];
//                } else {
//                    result[i] = fill;
//                }
//            }
//        } else if (oldLen > len) {
//            result = byteCut(bytes, 0, len);
//        } else {
//            result = bytes;
//        }
//
//        return result;
//    }

//+ (byte[]) cutBeforeBytes:(NSData *) bytes, byte cut) {
//        if (ByteUtils.isEmpty(bytes)) {
//            return bytes;
//        }
//
//        for (int i = 0; i < bytes.length; i++) {
//            if (bytes[i] != cut) {
//                return Arrays.copyOfRange(bytes, i, bytes.length);
//            }
//        }
//
//        return EMPTY_BYTES;
//    }
//
//    public static byte[] cutAfterBytes(byte[] bytes, byte cut) {
//        if (ByteUtils.isEmpty(bytes)) {
//            return bytes;
//        }
//
//        for (int i = bytes.length - 1; i >= 0; i--) {
//            if (bytes[i] != cut) {
//                return Arrays.copyOfRange(bytes, 0, i + 1);
//            }
//        }
//
//        return EMPTY_BYTES;
//    }

//+(Byte*) getBytes:(Byte *) bytes, int start, int end) {
//        if (bytes == null) {
//            return null;
//        }
//
//        if (start < 0 || start >= bytes.length) {
//            return null;
//        }
//
//        if (end < 0 || end >= bytes.length) {
//            return null;
//        }
//
//        if (start > end) {
//            return null;
//        }
//
//        byte[] newBytes = new byte[end - start + 1];
//
//        for (int i = start; i <= end; i++) {
//            newBytes[i - start] = bytes[i];
//        }
//
//        return newBytes;
//    }
//
//    public static boolean isAllFF(byte[] bytes) {
//        int len = (bytes != null ? bytes.length : 0);
//
//        for (int i = 0; i < len; i++) {
//            if (ubyteToInt(bytes[i]) != BYTE_MAX) {
//                return false;
//            }
//        }
//
//        return true;
//    }
//
//    public static void copy(byte[] lbytes, byte[] rbytes, int lstart, int rstart) {
//        if (lbytes != null && rbytes != null && lstart >= 0) {
//            for (int i = lstart, j = rstart; j < rbytes.length && i < lbytes.length; i++, j++) {
//                lbytes[i] = rbytes[j];
//            }
//        }
//    }
//
//    public static byte[] copyInverse(byte[] array) {
//        if (!isEmpty(array)) {
//            byte[] data = new byte[array.length];
//
//            for (int i = array.length - 1, j = 0; i >= 0; i--, j++) {
//                data[j] = array[i];
//            }
//
//            return data;
//        }
//        return array;
//    }
//
//    public static byte[] copyInverse(byte[] array, int start, int len) {
//        if (!isEmpty(array) && len > 0) {
//            byte[] data = new byte[len];
//
//            for (int i = start + len - 1, j = 0; i >= 0 && j < len; i--, j++) {
//                data[j] = array[i];
//            }
//
//            return data;
//        }
//        return array;
//    }
//
//    public static boolean equals(byte[] array1, byte[] array2) {
//        return equals(array1, array2, Math.min(array1.length, array2.length));
//    }
//
//    public static boolean equals(byte[] array1, byte[] array2, int len) {
//        if (array1 == array2) {
//            return true;
//        }
//        if (array1 == null || array2 == null || array1.length < len || array2.length < len) {
//            return false;
//        }
//        for (int i = 0; i < len; i++) {
//            if (array1[i] != array2[i]) {
//                return false;
//            }
//        }
//        return true;
//    }
//
//    /**
//     * 截取byte数组指定长度
//     *
//     * @param bytes
//     * @param offset
//     * @return
//     */
//    public static byte[] byteCut(byte[] bytes, int offset) throws Exception {
//        return byteCut(bytes, offset, bytes.length - offset);
//    }
//
    /**
     * 截取byte数组指定长度
     *
     * @param bytes 源字节串
     * @param offset 偏移量
     * @param len   长度
     * @return      字节串
     */
+(NSData*)byteCut:(NSData *) bytes offset:(int) offset len:(int) len
{
    NSData * data = [bytes subdataWithRange:NSMakeRange(offset, len)];
    return data;
}
//
//    /**
//     * 合并 两个byte数据
//     *
//     * @param b1
//     * @param b2
//     * @return
//     */
//    public static byte[] byteMerger(byte[] b1, byte[] b2) throws Exception {
//        byte[] b = new byte[b1.length + b2.length];
//
//        System.arraycopy(b1, 0, b, 0, b1.length);
//        System.arraycopy(b2, 0, b, b1.length, b2.length);
//
//        return b;
//    }
//
//    /**
//     * 合并 两个byte数据
//     *
//     * @param b1
//     * @param b2
//     * @return
//     */
//    public static byte[] byteMerger(byte[] b1, byte b2) throws Exception {
//        byte[] b = new byte[b1.length + 1];
//
//        System.arraycopy(b1, 0, b, 0, b1.length);
//        b[b1.length] = b2;
//
//        return b;
//    }
//
//    /**
//     * 合并 两个byte数据
//     *
//     * @param b1
//     * @param b2
//     * @return
//     */
//    public static byte[] byteMerger(byte b1, byte[] b2) throws Exception {
//        byte[] b = new byte[b2.length + 1];
//        b[0] = b1;
//
//        System.arraycopy(b2, 0, b, 1, b2.length);
//
//        return b;
//    }
//
//    /**
//     * 合并 两个byte数据
//     *
//     * @param b1
//     * @param b2
//     * @return
//     */
//    public static byte[] byteMerger(byte b1, byte b2) throws Exception {
//        byte[] b = new byte[2];
//
//        b[0] = b1;
//        b[1] = b2;
//
//        return b;
//    }
//
//    /**
//     * @功能: 10进制串转为BCD码
//     * @参数: 10进制串
//     * @结果: BCD码
//     */
//    public static byte[] str2Bcd(String asc) {
//        try {
//            int len = asc.length();
//            int mod = len % 2;
//            if (mod != 0) {
//                asc = "0" + asc;
//                len = asc.length();
//            }
//
//            if (len >= 2) {
//                len = len / 2;
//            }
//            byte bbt[] = new byte[len];
//            byte abt[] = asc.getBytes();
//            int j, k;
//            for (int p = 0; p < asc.length() / 2; p++) {
//                if ((abt[2 * p] >= '0') && (abt[2 * p] <= '9')) {
//                    j = abt[2 * p] - '0';
//                } else if ((abt[2 * p] >= 'a') && (abt[2 * p] <= 'z')) {
//                    j = abt[2 * p] - 'a' + 0x0a;
//                } else {
//                    j = abt[2 * p] - 'A' + 0x0a;
//                }
//
//                if ((abt[2 * p + 1] >= '0') && (abt[2 * p + 1] <= '9')) {
//                    k = abt[2 * p + 1] - '0';
//                } else if ((abt[2 * p + 1] >= 'a') && (abt[2 * p + 1] <= 'z')) {
//                    k = abt[2 * p + 1] - 'a' + 0x0a;
//                } else {
//                    k = abt[2 * p + 1] - 'A' + 0x0a;
//                }
//                int a = (j << 4) + k;
//                byte b = (byte) a;
//                bbt[p] = b;
//            }
//            return bbt;
//        } catch (Exception e) {
//            e.printStackTrace();
//            return new byte[6];
//        }
//    }
//
//    /**
//     * 把12位数字转换成6位BCD码
//     */
//    public static byte[] int2BCD2(String str, int len) {
//        if (str.length() < len) {
//            int cha = len - str.length();
//            for (int i = 0; i < cha; i++) {
//                str = "0" + str;
//            }
//        } else if (str.length() > len) {
//            str = str.substring(0, len);
//        }
//
//        return str2Bcd(str);
//    }
//
//    /**
//     * 把字符串转换成相应位数,前补0
//     */
//    public static String str2Len(String str, int len) {
//        if (str.length() > len) {
//            str = str.substring(0, len);
//        } else if (str.length() < len) {
//            str = String.format(Locale.getDefault(), "%0" + len + "d", str);
//        }
//
//        return str;
//    }
//

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
    
//    
//    /**
//     * 将byte拆分出两个数字（小于15）
//     *
//     * @param c 需要拆分的字节
//     * @return 拆分后的两个字节
//     */
//+(Byte*) splitByte:(Byte) c
//{
//    Byte * bytes =  alloca(2 * sizeof(Byte));
//    bytes[0] = c>>4;
//    bytes[1] = (c << 4 & 0xff) >> 4;
//    return bytes;
//  }

    
+(int) byteArrayToInt:(Byte[]) b
{
//    NSLog(@"bytes:%d %d %d %d",b[0],b[1],b[2],b[3]);
    
//    int a = (b[0]&0xFF) <<24;
//    int c  = (b[1]&0xFF) << 16;
//    int d = (b[2] &0xFF) <<8;
//    int e = b[3]&0xFF;
    int f = ((b[0]& 0xFF) <<24) + ((b[1] &0xFF) <<16) + ((b[2]&0xFF)<<8) +(b[3]&0xFF);
//    NSLog(@"v1:%d v2:%d",a+c+d+e,f);
    return f;//a+c+d+e;
    
//    return ((b[0]& 0xFF) <<24) + ((b[1] &0xFF) <<16) + ((b[2]&0xFF)<<8) +(b[3]&0xFF);
//        return b[3] & 0xFF +
//        ((b[2] & 0xFF) << 8) +
//        ((b[1] & 0xFF) << 16) +
//        ((b[0] & 0xFF) << 24);
}
    
+(int) byteArrayToShort:(Byte[]) b {
    return ((b[0]& 0xFF) <<8) + (b[1] &0xFF);
//        return b[1] & 0xFF +
//        ((b[0] & 0xFF) << 8);
}

@end
