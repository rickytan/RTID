//
//  RTID.m
//  RTID
//
//  Created by ricky on 14-6-5.
//  Copyright (c) 2014年 ricky. All rights reserved.
//

#import "RTID.h"

#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>


static NSString * _appKey = nil;
static NSString * _RTID = nil;
static RTIDType   _type = RTIDTypeUUID;

@implementation RTID

+ (void)setupAppkey:(NSString *)appkey
{
    _appKey = [appkey copy];
}

+ (void)setIDType:(RTIDType)type
{
    _type = type;
}

#pragma mark - Private

+ (NSString *)md5:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

@end

@implementation UIDevice (RTID)

- (NSString *)RTID
{
    if (!_RTID) {
        _RTID = self.identifierForVendor.UUIDString;
    }
    return _RTID;
}

@end
