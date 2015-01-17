//
//  BrickView.h
//  BrickView
//
//  Created by Hirohisa Kawasaki on 13/04/17.
//  Copyright (c) 2013年 Hirohisa Kawasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrickIndexPath.h"
#import "BrickView+Logic.h"

@class BrickView, BrickViewCell;

@protocol BrickViewDelegate <UIScrollViewDelegate>

@required

- (CGFloat)brickView:(BrickView *)brickView heightForCellAtIndex:(NSInteger)index;

@optional

- (void)brickView:(BrickView *)brickView didSelectCell:(BrickViewCell *)cell AtIndex:(NSInteger)index;
- (void)brickView:(BrickView *)brickView didLongPressCell:(BrickViewCell *)cell AtIndex:(NSInteger)index;

@end

@protocol BrickViewDataSource <NSObject>

@required

- (NSInteger)numberOfCellsInBrickView:(BrickView *)brickView;
- (NSInteger)numberOfColumnsInBrickView:(BrickView *)brickView;
- (BrickViewCell *)brickView:(BrickView *)brickView cellAtIndex:(NSInteger)index;

@end

@interface BrickViewCell : UIView <NSCoding>

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)prepareForReuse; // if the cell is reusable (has a reuse identifier), this is called just before the cell is returned from the brick view method dequeueReusableCellWithIdentifier:.

@end

@interface BrickView : UIScrollView <NSCoding>

@property (nonatomic, assign) id<BrickViewDataSource> dataSource;
@property (nonatomic, assign) id<BrickViewDelegate> delegate;

@property (nonatomic) CGFloat padding; // default is 0.
@property (nonatomic) CGFloat earlyScope; // default is 0.

@property (nonatomic, readonly) CGFloat widthOfCell;

@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UIView *footerView;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)reloadData;
- (void)updateData;// don't clear visibleCells to updateData

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
@end
