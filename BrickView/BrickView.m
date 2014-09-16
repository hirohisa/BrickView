//
//  BrickView.m
//  BrickView
//
//  Created by Hirohisa Kawasaki on 13/04/17.
//  Copyright (c) 2013年 Hirohisa Kawasaki. All rights reserved.
//

#import "BrickView.h"
#import "BrickIndexPath.h"
#import "BrickView+Logic.h"


@protocol BrickViewCellDelegate <NSObject>

- (void)didLongPressCell:(BrickViewCell *)cell;
- (void)didSelectCell:(BrickViewCell *)cell;

@end

@interface BrickViewCell ()

@property (nonatomic, assign) id<BrickViewCellDelegate> delegate;
@property (nonatomic) NSInteger brickIndex;
@property (nonatomic) NSString *reuseIdentifier;
@property (nonatomic) BOOL touching;

@end

@implementation BrickViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    if(self) {
        self.reuseIdentifier = reuseIdentifier;
        [self brick_initialize];
	}
	return self;
}

#pragma mark -

- (void)brick_initialize
{
    self.brickIndex = NSNotFound;
    UILongPressGestureRecognizer *longPressGesture =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longPressGesture];
}

- (void)handleLongPress:(UIGestureRecognizer *)gesture
{
    if (self.touching) {
        [self.delegate didLongPressCell:self];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.touching = YES;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    self.touching = NO;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (self.touching) {
        self.touching = NO;
        [self.delegate didSelectCell:self];
    }
}

@end


@interface BrickView () <UIScrollViewDelegate, BrickViewCellDelegate> {
    @package
    __unsafe_unretained id _delegate;
}

@property (nonatomic, readonly) NSInteger numberOfColumns;
@property (nonatomic) NSInteger numberOfCells;
@property (nonatomic, strong) NSMutableArray *brickIndexPaths;
@property (nonatomic, strong) NSMutableArray *visibleCells;
@property (nonatomic, strong) NSMutableDictionary *reusableCells;
@end

@implementation BrickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self brick_configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self brick_configure];
    }
    return self;
}

- (void)dealloc
{
    self->_delegate = nil;
}

- (void)brick_configure
{
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.clipsToBounds = NO;
    self.alwaysBounceVertical = YES;
    [super setDelegate:self];
    _reusableCells = [@{} mutableCopy];
}

#pragma mark -

- (void)reloadData
{
    for (id cell in self.visibleCells) {
        [self recycleCellIntoReusableQueue:cell];
        [cell removeFromSuperview];
    }
    self.visibleCells = [@[] mutableCopy];
    [self updateData];
}

- (void)updateData
{
    [self brick_initialize];
}

#pragma mark - setter/getter

- (void)setDataSource:(id<BrickViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self brick_initialize];
}

- (void)setDelegate:(id<BrickViewDelegate>)delegate
{
    self->_delegate = delegate;
    if (delegate) {
        [self brick_initialize];
    }
}

- (id<BrickViewDelegate>)delegate
{
    return self->_delegate;
}

- (void)setHeaderView:(UIView *)headerView
{
    _headerView = headerView;
    [self brick_initialize];
}

- (void)setFooterView:(UIView *)footerView
{
    _footerView = footerView;
    [self brick_initialize];
}

- (NSInteger)numberOfColumns
{
    return [self.dataSource numberOfColumnsInBrickView:self];
}

-(CGFloat)widthOfCell
{
    CGFloat width = CGRectGetWidth(self.bounds);
    width -= self.padding * (self.numberOfColumns+1);
    return width/(self.numberOfColumns);
}

#pragma mark - BrickViewCellDelegate

- (void)didLongPressCell:(BrickViewCell *)cell
{
    if ([self.delegate respondsToSelector:@selector(brickView:didLongPressCell:AtIndex:)]) {
        [self.delegate brickView:self didLongPressCell:cell AtIndex:cell.brickIndex];
    }
}

- (void)didSelectCell:(BrickViewCell *)cell
{
    if ([self.delegate respondsToSelector:@selector(brickView:didSelectCell:AtIndex:)]) {
        [self.delegate brickView:self didSelectCell:cell AtIndex:cell.brickIndex];
    }
}

#pragma mark - reusable

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    if (identifier &&
        self.reusableCells[identifier]) {
        id cell = [self.reusableCells[identifier] lastObject];
        [self.reusableCells[identifier] removeLastObject];
        return cell;
    }

    return nil;
}

- (void)recycleCellIntoReusableQueue:(BrickViewCell *)cell
{
    if (!self.reusableCells[cell.reuseIdentifier]) {
        self.reusableCells[cell.reuseIdentifier] = [@[] mutableCopy];
    }

    [self.reusableCells[cell.reuseIdentifier] addObject:cell];
}

#pragma mark -

- (BOOL)brick_validateToInitialize
{
    return self.dataSource && self.delegate;
}

- (void)brick_initialize
{
    if (![self brick_validateToInitialize]) {
        return;
    }

    self.numberOfCells = [self.dataSource numberOfCellsInBrickView:self];
    self.brickIndexPaths = [@[] mutableCopy];
    for (int i=0; i<[self.dataSource numberOfColumnsInBrickView:self]; i++) {
        [self.brickIndexPaths addObject:[@[] mutableCopy]];
    }

    [self adjustContent];
    [self renderCells];
}

#pragma mark - logic

- (void)adjustContent
{
    CGFloat offsetHeight = self.padding;

    // header
    if (self.headerView) {
        self.headerView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.headerView.bounds)/2+self.padding);
        [self addSubview:self.headerView];

        offsetHeight += CGRectGetHeight(self.headerView.bounds)+self.padding;
    }

    // last heights
    NSMutableArray *lastHeights = [@[] mutableCopy];
    for (int i=0; i<[self.dataSource numberOfColumnsInBrickView:self]; i++) {
        [lastHeights addObject:@(offsetHeight)];
    }

    // height indexes
    NSUInteger column;
    CGRect frame;
    for (int index = 0; index< self.numberOfCells; index++) {
        column = [lastHeights compareLeastIndex];

        frame = (CGRect) {
            .origin.x       = column*self.widthOfCell + self.padding*(column+1),
            .origin.y       = [lastHeights[column] floatValue],
            .size.width     = self.widthOfCell,
            .size.height    = [self.delegate brickView:self heightForCellAtIndex:index],
        };

        BrickIndexPath *indexPath = [BrickIndexPath indexPathWithIndex:index
                                                                column:column
                                                                 frame:frame];
        [self.brickIndexPaths[column] addObject:indexPath];

        CGFloat height = CGRectGetMaxY(frame) + self.padding;
        [lastHeights setObject:@(height) atIndexedSubscript:column];
    }

    CGFloat contentHeight = 0.f;
    if ([lastHeights count] > 0) {
        contentHeight = [lastHeights[[lastHeights compareGreatestIndex]] floatValue];
    }

    // footer
    if (self.footerView) {
        self.footerView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, contentHeight+CGRectGetHeight(self.footerView.bounds)/2);
        [self addSubview:self.footerView];

        contentHeight += CGRectGetHeight(self.footerView.bounds)+self.padding;
    }

    self.contentSize = CGSizeMake(self.frame.size.width, contentHeight);
}

- (void)renderCells
{
    CGRect rect = (CGRect) {
        .origin = self.contentOffset,
        .size   = self.frame.size
    };

    NSMutableArray *indexPaths = [[self.brickIndexPaths filteredArrayUsingBrickIndexPathContainsRect:rect] mutableCopy];

    NSMutableArray *cells = [@[] mutableCopy];

    // remove not visibled cells
    for (BrickViewCell *cell in self.visibleCells) {
        BOOL include = NO;
        NSInteger index = 0;

        for (int i=0; i<[indexPaths count]; i++) {
            BrickIndexPath *indexPath = indexPaths[i];
            if (indexPath.index == cell.brickIndex) {
                include = YES;
                index = i;
            }
        }

        if (!include) {
            [self recycleCellIntoReusableQueue:cell];
            [cell removeFromSuperview];
        } else {
            [cells addObject:cell];
            [indexPaths removeObjectAtIndex:index];
        }
    }

    // add cells to visibled
    for (BrickViewCell *cell in [self getCellsWithIndexPaths:indexPaths]) {
        cell.delegate = self;
        [self addSubview:cell];
        [cells addObject:cell];
    }

    self.visibleCells = [cells mutableCopy];
}

- (NSArray *)getCellsWithIndexPaths:(NSArray *)indexPaths
{
    NSMutableArray *cells = [@[] mutableCopy];
    for (BrickIndexPath *indexPath in indexPaths) {
        [cells addObject:[self cellAtIndexPath:indexPath]];
    }
    return [cells copy];
}

- (BrickViewCell *)cellAtIndexPath:(BrickIndexPath *)indexPath
{
    BrickViewCell *cell = [self.dataSource brickView:self cellAtIndex:indexPath.index];
    cell.brickIndex = indexPath.index;
    cell.frame = indexPath.frame;
    [cell setNeedsLayout];

    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self renderCells];
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.delegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.delegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.delegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.delegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.delegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.delegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.delegate scrollViewDidScrollToTop:scrollView];
    }
}

@end
