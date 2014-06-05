//
//  RTIDTests.m
//  RTIDTests
//
//  Created by ricky on 14-6-5.
//  Copyright (c) 2014年 ricky. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RTID.h"

@interface RTIDTests : XCTestCase

@end

@implementation RTIDTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [RTID setupAppkey:@"abcd"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSLog(@"%@", [UIDevice currentDevice].RTID);
}

@end
