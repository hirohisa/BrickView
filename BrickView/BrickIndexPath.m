//
//  BrickIndexPath.m
//  BrickView
//
//  Created by Hirohisa Kawasaki on 2014/04/16.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import "BrickIndexPath.h"

@implementation BrickIndexPath

+ (id)indexPathWithIndex:(NSUInteger)index
                  column:(NSInteger)column
                  height:(float)height;
{
    return [[self alloc]initWithIndex:index column:column height:height];
}

- (id)initWithIndex:(NSUInteger)index
             column:(NSInteger)column
             height:(float)height
{
    self = [super init];
    if (self) {
        _index  = index;
        _column = column;
        _height = height;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<BrickIndexPath index:%ld, column:%ld, height:%.1f>",
            (unsigned long)self.index,
            (unsigned long)self.column,
            self.height];
}

@end
