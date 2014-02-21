//
//  DemoViewController.m
//  BrickView Example
//
//  Created by Hirohisa Kawasaki on 13/04/17.
//  Copyright (c) 2013年 Hirohisa Kawasaki. All rights reserved.
//

#import "DemoViewController.h"
#import "BrickView.h"

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
	BrickViewCell *cell = [brickView dequeueReusableCellWithIdentifier:CellIdentifier];

	if(!cell) {
        cell  = [[BrickViewCell alloc] initWithReuseIdentifier:CellIdentifier];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.tag = 1001;
        [cell addSubview:label];
	}

    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    label.frame = (CGRect) {
        .origin.x = 0.,
        .origin.y = 0.,
        .size.width = brickView.widthOfCell,
        .size.height = [brickView.delegate brickView:brickView heightForCellAtIndex:index]
    };
    label.text = self.list[index];
    label.textAlignment = NSTextAlignmentCenter;
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
- (void)brickView:(BrickView *)brickView didSelect:(BrickViewCell *)cell AtIndex:(int)index
{
    NSLog(@"did select index %d", index);
}

- (void)brickView:(BrickView *)brickView didLongPress:(BrickViewCell *)cell AtIndex:(NSInteger)index
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
