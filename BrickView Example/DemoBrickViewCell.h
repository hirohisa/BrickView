//
//  DemoBrickViewCell.h
//  BrickView Example
//
//  Created by Hirohisa Kawasaki on 2015/01/11.
//  Copyright (c) 2015年 Hirohisa Kawasaki. All rights reserved.
//

#import <BrickView/BrickView.h>

@interface DemoBrickViewCell : BrickViewCell

@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;

@end
