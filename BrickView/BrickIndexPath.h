//
//  BrickIndexPath.h
//  BrickView
//
//  Created by Hirohisa Kawasaki on 2014/04/16.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

@import Foundation;
@import UIKit.UIGeometry;
@import CoreGraphics.CGGeometry;

@interface BrickIndexPath : NSObject

@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, readonly) NSUInteger column;
@property (nonatomic, readonly) CGRect frame;

+ (id)indexPathWithIndex:(NSUInteger)index column:(NSInteger)column frame:(CGRect)frame;
- (id)initWithIndex:(NSUInteger)index column:(NSInteger)column frame:(CGRect)frame;

@end
