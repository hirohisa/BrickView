//
//  DemoBrickViewCell.m
//  BrickView Example
//
//  Created by Hirohisa Kawasaki on 1/11/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

#import "DemoBrickViewCell.h"

@implementation DemoBrickViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
}

@end