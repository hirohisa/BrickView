//
//  BrickViewTests.m
//  BrickViewTests
//
//  Created by Hirohisa Kawasaki on 2014/02/14.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BrickView.h"

@interface NSArray (BrickworkView)
- (NSInteger)compareLeastIndex;
- (NSInteger)compareGreatestIndex;
@end

@interface BrickViewTests : XCTestCase

@end

@implementation BrickViewTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCompareLeastIndex
{
    NSArray *array;
    NSInteger index;
    array = @[
              @(1), @(2), @(3)
              ];
    index = [array compareLeastIndex];
    XCTAssertTrue(0 == index,
                  @"compareLeastIndex:%ld", (long)index);

    array = @[];
    index = [array compareLeastIndex];
    XCTAssertTrue(0 == index,
                  @"compareLeastIndex:%ld", (long)index);
}

- (void)testCompareGreatestIndex
{
    NSArray *array;
    NSInteger index;
    array = @[
              @(1), @(2), @(3)
              ];
    index = [array compareGreatestIndex];
    XCTAssertTrue(2 == index,
                  @"compareGreatestIndex:%ld", (long)index);

    array = @[];
    index = [array compareGreatestIndex];
    array = @[];
    index = [array compareLeastIndex];
    XCTAssertTrue(0 == index,
                  @"compareGreatestIndex:%ld", (long)index);
}

@end
