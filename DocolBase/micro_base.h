//
//  base.h
//  VSBLETest
//
//  Created by XUTAO HUANG on 2018/5/31.
//  Copyright © 2018年 XUTAO HUANG. All rights reserved.
//

#ifndef veritrans_base_h
#define veritrans_base_h

#ifndef ARC_FUN
    #define ARC_FUN
    #if __has_feature(objc_arc) && __clang_major__ >= 3
        #define PP_ARC_ENABLED 1
    #endif // __has_feature(objc_arc)

    #if PP_ARC_ENABLED
        #ifndef PP_RETAIN
            #define PP_RETAIN(xx) (xx)
        #endif
        #ifndef PP_RELEASE
            #define PP_RELEASE(xx)  xx = nil
        #endif
        #ifndef PP_AUTORELEASE
            #define PP_AUTORELEASE(xx)  (xx)
        #endif
        #ifndef PP_SUPERDEALLOC
            #define PP_SUPERDEALLOC
        #endif
        #ifndef PP_BEGINPOOL
            #define PP_BEGINPOOL(xx)
        #endif
        #ifndef PP_ENDPOOL
            #define PP_ENDPOOL(xx)
        #endif
        #ifndef PP_STRONG
            #define PP_STRONG strong
        #endif
        #ifndef PP_WEAK
            #if __has_feature(objc_arc_weak)
                #define PP_WEAK weak
            #elif __has_feature(objc_arc)
                #define PP_WEAK unsafe_unretained
            #endif
        #endif
    #endif
    #else
        #ifndef PP_RETAIN
            #define PP_RETAIN(xx)           [xx retain]
        #endif
        #ifndef PP_RELEASE
            #define PP_RELEASE(xx)          [xx release], xx = nil
        #endif
        #ifndef PP_AUTORELEASE
            #define PP_AUTORELEASE(xx)      [xx autorelease]
        #endif
        #ifndef PP_SUPERDEALLOC
            #define PP_SUPERDEALLOC [super dealloc]
        #endif
        #ifndef PP_BEGINPOOL
            #define PP_BEGINPOOL(xx) NSAutoreleasePool *xx = [[NSAutoreleasePool alloc] init];
        #endif
        #ifndef PP_ENDPOOL
            #define PP_ENDPOOL(xx) if(xx) { [xx drain];xx=nil;}
        #endif
        #ifndef PP_STRONG
            #define PP_STRONG retain
        #endif
        #ifndef PP_WEAK
            #define PP_WEAK assign
        #endif
    #endif
#endif

//////MWPhotoBrowser
#define SYSTEM_VERSION_EQUAL_TO(v)                      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)         ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#define IS_IPAD    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define DEFAULT_DATE_TIME_FORMAT (@"yyyy-MM-dd HH:mm:ss")


#ifndef SYNTHESIZE_SINGLETON_FOR_CLASS_NEW
#if PP_ARC_ENABLED
#define SYNTHESIZE_SINGLETON_FOR_CLASS_NEW(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
if(shared##classname == nil) \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\



#else

#define SYNTHESIZE_SINGLETON_FOR_CLASS_NEW(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
if(shared##classname == nil) \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\
- (id)retain \
{ \
return self; \
} \
\
- (NSUInteger)retainCount \
{ \
return NSUIntegerMax; \
} \
\
- (oneway void)release \
{ \
} \
\
- (id)autorelease \
{ \
return self; \
}\

#endif


#define PARSEDATAARRAY(NEWLIST,ORGLIST,TYPE) \
\
NSMutableArray * NEWLIST = [NSMutableArray new]; \
\
if([ORGLIST isKindOfClass:[NSNull class]]) \
\
{\
ORGLIST = nil;\
\
}\
\
else if([ORGLIST isKindOfClass:[NSString class]])\
\
{\
ORGLIST = [(NSString*)ORGLIST JSONValueEx];\
\
}\
\
for (NSDictionary * dic in ORGLIST) { \
\
TYPE * item = nil; \
\
if([dic isKindOfClass:[NSDictionary class]]) \
\
{\
item = [[TYPE alloc]initWithDictionary:dic];\
\
} \
\
else if([dic isKindOfClass:[NSString class]]) \
\
{ \
\
item = [[TYPE alloc]initWithJSON:(NSString*)dic]; \
\
} \
\
else if([dic isKindOfClass:[TYPE class]]) \
\
{ \
item = PP_RETAIN((TYPE *)dic); \
\
} \
\
if(item) \
\
{ \
\
[NEWLIST addObject:item];\
\
PP_RELEASE(item);\
\
} \
\
} \
\


#define PARSEDATA(DICNAME,ITEMNAME,TYPE) \
\
TYPE * ITEMNAME = nil; \
\
if([DICNAME isKindOfClass:[NSDictionary class]]) \
\
{\
ITEMNAME = [[TYPE alloc]initWithDictionary:DICNAME];\
\
} \
\
else if([DICNAME isKindOfClass:[NSString class]]) \
\
{ \
\
ITEMNAME = [[TYPE alloc]initWithJSON:(NSString*)DICNAME]; \
\
} \
\
else if([DICNAME isKindOfClass:[TYPE class]]) \
\
{ \
ITEMNAME = PP_RETAIN((TYPE *)DICNAME); \
\
} \
\



#endif /* base_h */
