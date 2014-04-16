//
//  BrickView+Logic.m
//  BrickView
//
//  Created by Hirohisa Kawasaki on 2014/04/16.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import "BrickView+Logic.h"

@implementation NSArray (BrickView)

- (NSInteger)compareLeastIndex
{
    id criteria = nil;
    NSInteger index = 0;
    for (NSInteger i=0; i<[self count]; i++) {
        if (!criteria) criteria = self[i];

        if (floor([self[i] floatValue]) < floor([criteria floatValue])) {
            criteria = self[i];
            index = i;
        }
    }
    return index;
}

- (NSInteger)compareGreatestIndex
{
    id criteria = nil;
    NSInteger index = 0;
    for (NSInteger i=0; i<[self count]; i++) {
        if (!criteria) criteria = self[i];

        if (floor([self[i] floatValue]) > floor([criteria floatValue])) {
            criteria = self[i];
            index = i;
        }
    }
    return index;
}

@end