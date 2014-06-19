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


#if !__has_feature(objc_arc)
#error "This lib uses ARC!"
#endif


static NSString * _appKey = @"org.ricky.rtid.default";
static NSString * _RTID = nil;
static BOOL       _debug = NO;
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

+ (void)setDebug:(BOOL)yesOrNo
{
    _debug = yesOrNo;
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

+ (NSString*) uniqueString
{
	CFUUIDRef uuidObj = CFUUIDCreate(nil);
	NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	CFRelease(uuidObj);
	return uuidString;
}

+ (BOOL)storeID:(NSString *)rtid
     withAppkey:(NSString *)appkey
{
    NSAssert(appkey != nil, @"You must call setupAppKey first!");

    OSStatus status = -1;
    NSMutableDictionary *item = [NSMutableDictionary dictionaryWithCapacity:4];
    [item setObject:(__bridge id)(kSecClassGenericPassword)
             forKey:(__bridge id<NSCopying>)(kSecClass)];
    [item setObject:[NSBundle mainBundle].bundleIdentifier
             forKey:(__bridge id<NSCopying>)(kSecAttrService)];
    [item setObject:appkey
             forKey:(__bridge id<NSCopying>)(kSecAttrAccount)];
    status = SecItemDelete((__bridge CFDictionaryRef)(item));
#if DEBUG
    NSLog(@"Delete item with return code: %d", (int)status);
#endif
    [item setObject:[rtid dataUsingEncoding:NSUTF8StringEncoding]
             forKey:(__bridge id<NSCopying>)(kSecValueData)];
    CFTypeRef result = NULL;
    status = SecItemAdd((__bridge CFDictionaryRef)(item), &result);
#if DEBUG
    NSLog(@"Add item with return code: %d", (int)status);
#endif
    return status == errSecSuccess;
}

+ (NSString *)identifierWithAppkey:(NSString *)appkey
{
    NSAssert(appkey != nil, @"You must call setupAppKey first!");

    OSStatus status = -1;
    NSMutableDictionary *item = [NSMutableDictionary dictionaryWithCapacity:4];
    [item setObject:(__bridge id)(kSecClassGenericPassword)
             forKey:(__bridge id<NSCopying>)(kSecClass)];
    [item setObject:[NSBundle mainBundle].bundleIdentifier
             forKey:(__bridge id<NSCopying>)(kSecAttrService)];
    [item setObject:appkey
             forKey:(__bridge id<NSCopying>)(kSecAttrAccount)];
    [item setObject:@YES
             forKey:(__bridge id<NSCopying>)(kSecReturnData)];
    [item setObject:(__bridge id)(kSecMatchLimitOne)
             forKey:(__bridge id<NSCopying>)(kSecMatchLimit)];
    CFTypeRef result = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)(item), &result);
    if (status != errSecSuccess) {
        NSLog(@"Get ID Error with code: %d", (int)status);
        return nil;
    }

    return [[NSString alloc] initWithData:(__bridge NSData *)(result)
                                 encoding:NSUTF8StringEncoding];
}

+ (NSString *)identifier
{
    NSString *ID = [RTID identifierWithAppkey:_appKey];
    if (_debug || !ID) {
        switch (_type) {
            case RTIDTypeUUID:
                ID = [RTID uniqueString];
                break;
            case RTIDTypeMD5:
                ID = [RTID md5:[RTID uniqueString]];
                break;
            case RTIDTypeUDID:
                ID = [[RTID md5:[RTID uniqueString]] stringByAppendingString:[[[RTID uniqueString] substringToIndex:8] lowercaseString]];
                break;
            default:
                break;
        }
        NSInteger count = 0;
        while (![RTID storeID:ID
                   withAppkey:_appKey] && count++ < 3) {
            sleep(1);
        }
    }
    return ID;
}

@end

@implementation UIDevice (RTID)

- (NSString *)RTID
{
    if (!_RTID) {
        //_RTID = self.identifierForVendor.UUIDString;
        _RTID = [RTID identifier];
    }
    return _RTID;
}

@end
