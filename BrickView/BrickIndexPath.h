//
//  BrickIndexPath.h
//  BrickView
//
//  Created by Hirohisa Kawasaki on 2014/04/16.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrickIndexPath : NSObject

@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, readonly) NSUInteger column;
@property (nonatomic, readonly) float height;

+ (id)indexPathWithIndex:(NSUInteger)index
                  column:(NSInteger)column
                  height:(float)height;

@end
