//
//  BrickView+Logic.h
//  BrickView
//
//  Created by Hirohisa Kawasaki on 4/16/14.
//  Copyright (c) 2014 Hirohisa Kawasaki. All rights reserved.
//

#import "BrickView.h"
#import "BrickIndexPath.h"

@interface NSArray (BrickView)

- (NSInteger)compareLeastIndex;
- (NSInteger)compareGreatestIndex;

- (BrickIndexPath *)lastBrickIndexPath;

- (NSArray *)filteredArrayUsingBrickIndexPathContainsRect:(CGRect)rect;

@end
