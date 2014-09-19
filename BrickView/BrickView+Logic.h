//
//  BrickView+Logic.h
//  BrickView
//
//  Created by Hirohisa Kawasaki on 2014/04/16.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import "BrickView.h"
#import "BrickIndexPath.h"

@interface NSArray (BrickView)

- (NSInteger)compareLeastIndex;
- (NSInteger)compareGreatestIndex;

- (BrickIndexPath *)lastBrickIndexPath;

- (NSArray *)filteredArrayUsingBrickIndexPathContainsRect:(CGRect)rect;

@end
