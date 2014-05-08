//
//  LeaflyTests.m
//  LeaflyTests
//
//  Copyright (c) 2013 Leafly Holdings, Inc. All rights reserved.
//
//  Developed by:
//
//  47 Degrees
//  http://47deg.com
//  hello@47deg.com
//

#import <XCTest/XCTest.h>
#import "NSObject+FDRestkitMappings.h"

@interface APPRESTUtilsTests : XCTestCase

@end

@implementation APPRESTUtilsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUnderscoredPropertyName {
    NSString *prop = [self underscoredPropertyName:@"_id"];
    XCTAssertEqual(prop, @"id", @"Underscored Conversion");
}

@end

