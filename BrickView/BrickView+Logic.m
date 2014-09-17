//
//  BrickView+Logic.m
//  BrickView
//
//  Created by Hirohisa Kawasaki on 2014/04/16.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import "BrickView+Logic.h"
#import "BrickIndexPath.h"

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

- (BrickIndexPath *)lastBrickIndexPath
{
    BrickIndexPath *lastIndexPath;
    for (NSArray *array in self) {
        BrickIndexPath *indexPath = [array lastObject];
        if (!lastIndexPath ||
            lastIndexPath.index < indexPath.index) {
            lastIndexPath = indexPath;
        }
    }

    return lastIndexPath;
}

- (NSArray *)filteredArrayUsingBrickIndexPathContainsRect:(CGRect)rect
{
    NSMutableArray *indexPaths = [@[] mutableCopy];

    for (int column=0; column<[self count]; column++) {
        NSArray *list = self[column];
        for (int i=0; i<[list count]; i++) {
            BrickIndexPath *indexPath = list[i];
            if (CGRectIntersectsRect(indexPath.frame, rect)) {
                [indexPaths addObject:indexPath];
            }
        }
    }

    return [indexPaths copy];
}

@end