//
//  DemoBrickViewCell.m
//  BrickView Example
//
//  Created by Hirohisa Kawasaki on 1/11/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

#import "DemoBrickViewCell.h"

@interface DemoBrickViewCell ()
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textLabelBottomConstraint;
@end

@implementation DemoBrickViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.layer.cornerRadius = 10.f;
}

- (void)setText:(NSString *)text detailText:(NSString *)detailText {
    self.textLabel.text = text;
    self.detailLabel.text = detailText;
    self.textLabelBottomConstraint.constant = detailText != nil ? 10 : 0;
}

- (void)prepareForReuse {
    self.textLabel.textColor = [UIColor blackColor];
    self.detailLabel.textColor = [UIColor blackColor];

    if (arc4random_uniform(3) == 0) {
        self.textLabel.textColor = [UIColor colorWithRed:33.f/255.f green:47.f/255.f blue:158.f/255.f alpha:1.f];
        self.detailLabel.textColor = [UIColor colorWithRed:33.f/255.f green:47.f/255.f blue:158.f/255.f alpha:1.f];
    }
}

@end
