//
//  DemoViewController.m
//  BrickView Example
//
//  Created by Hirohisa Kawasaki on 13/04/17.
//  Copyright (c) 2013年 Hirohisa Kawasaki. All rights reserved.
//

#import "DemoViewController.h"
#import "BrickView.h"

@interface DemoBrickViewCell : BrickViewCell

@property (nonatomic, readonly) UILabel *textLabel;

@end

@implementation DemoBrickViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _textLabel = [[UILabel alloc] init];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = (CGRect) {
        .origin.x = 0.,
        .origin.y = 0.,
        .size.width = CGRectGetWidth(self.frame),
        .size.height = CGRectGetHeight(self.frame)
    };
}

@end

@interface DemoViewController () <BrickViewDataSource, BrickViewDelegate>
@property (nonatomic, strong) BrickView *brickView;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.brickView = [[BrickView alloc]initWithFrame:self.view.bounds];

    self.list = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",
                  @"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"].mutableCopy;
    self.brickView.padding = 10.;
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50)];
    headerLabel.text = @"HEADER";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    self.brickView.headerView = headerLabel;
    UILabel *footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50)];
    footerLabel.text = @"FOOTER";
    footerLabel.textAlignment = NSTextAlignmentCenter;
    self.brickView.footerView = footerLabel;
    [self.view addSubview:self.brickView];
    self.brickView.dataSource = self;
    self.brickView.delegate = self;
}

#pragma mark - accessor

- (CGFloat)brickView:(BrickView *)brickView heightForCellAtIndex:(NSInteger)index
{
    switch (index%3) {
        case 0: {
            return 100.;
        }
            break;
        case 1: {
            return 50.;
        }
            break;
        case 2: {
            return 70.;
        }
            break;
    }
    return 100.;
}

- (NSInteger)numberOfColumnsInBrickView:(BrickView *)brickView
{
    return 3;
}


- (NSInteger)numberOfCellsInBrickView:(BrickView *)brickView
{
    return [self.list count];
}

- (BrickViewCell *)brickView:(BrickView *)brickView cellAtIndex:(NSInteger)index
{
    static NSString *CellIdentifier = @"Cell";
	DemoBrickViewCell *cell = [brickView dequeueReusableCellWithIdentifier:CellIdentifier];

	if(!cell) {
        cell  = [[DemoBrickViewCell alloc] initWithReuseIdentifier:CellIdentifier];
	}
    cell.textLabel.text = [NSString stringWithFormat:@"%d:%@",
                           index,
                           self.list[index]];
    switch (index%3) {
        case 0: {
            cell.backgroundColor = [UIColor grayColor];
        }
            break;
        case 1: {
            cell.backgroundColor = [UIColor blueColor];
        }
            break;
        case 2: {
            cell.backgroundColor = [UIColor purpleColor];
        }
            break;
    }

	return cell;
}

#pragma mark -
- (void)brickView:(BrickView *)brickView didSelectCell:(BrickViewCell *)cell AtIndex:(NSInteger)index
{
    NSLog(@"did select index %d", index);
}

- (void)brickView:(BrickView *)brickView didLongPressCell:(BrickViewCell *)cell AtIndex:(NSInteger)index
{
    NSLog(@"did long-press index %d", index);
    [self.list removeObjectAtIndex:index];
    [brickView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat bottomEdge = scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame);
    if (bottomEdge >= floor(scrollView.contentSize.height)) {
        [self.list addObjectsFromArray:@[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",
                                         @"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"]];
        [self.brickView updateData];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"end dragging");
}
@end
