//
//  RUtils.h
//  RiverLib
//
//  Created by Richard Shen on 2017/7/18.
//  Copyright © 2017年 River. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUtils : NSObject

//设备IP地址
+ (NSString *)deviceIPAdress;

//设备名称，iPhone6、iPhone7 Plus
+ (NSString*)deviceModelName;

//设备屏幕尺寸, 320x480
+ (NSString*)deviceScreenSize;

//设备UUID
//+ (NSString *)deviceUUID;
+ (NSString *)UUID;
//设备版本号
+ (NSString *)deviceVersion;
+ (NSString *)getBleVersion;
+ (BOOL) isPwdSimple:(NSString*)pwd;
@end
