//
//  RTID.h
//  RTID
//
//  Created by ricky on 14-6-5.
//  Copyright (c) 2014年 ricky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, RTIDType) {
    RTIDTypeUUID                        = 0,    // Default
    RTIDTypeAlphabetAndDigitLength32    = 1,
    RTIDTypeAlphabetAndDigitLength48    = 2,
};

#if !__has_feature(objc_arc)
#error "This lib uses ARC!"
#endif

@interface RTID : NSObject

/* Use your own generated key here, DO NOT change it, or RTID will
     change !
 */
+ (void)setupAppkey:(NSString *)appkey;

/* Set only once before you first read the RTID. After the first
     read, this method has no effect any more !
 */
+ (void)setIDType:(RTIDType)type;

@end

@interface UIDevice (RTID)
@property (nonatomic, readonly, strong) NSString * RTID;
@end
