//
//  BrickIndexPath.m
//  BrickView
//
//  Created by Hirohisa Kawasaki on 4/16/14.
//  Copyright (c) 2014 Hirohisa Kawasaki. All rights reserved.
//

#import "BrickIndexPath.h"

@implementation BrickIndexPath

+ (id)indexPathWithIndex:(NSUInteger)index column:(NSInteger)column frame:(CGRect)frame {
    return [[self alloc]initWithIndex:index column:column frame:frame];
}

- (id)initWithIndex:(NSUInteger)index column:(NSInteger)column frame:(CGRect)frame {
    self = [super init];
    if (self) {
        _index  = index;
        _column = column;
        _frame  = frame;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<BrickIndexPath index:%ld, column:%ld %@>",
            (unsigned long)self.index,
            (unsigned long)self.column,
            NSStringFromCGRect(self.frame)];
}

@end
