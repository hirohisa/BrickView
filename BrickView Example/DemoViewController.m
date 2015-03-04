//
//  DemoViewController.m
//  BrickView Example
//
//  Created by Hirohisa Kawasaki on 4/17/13.
//  Copyright (c) 2013 Hirohisa Kawasaki. All rights reserved.
//

#import "DemoViewController.h"
#import <BrickView/BrickView.h>
#import "DemoBrickViewCell.h"

@interface NSArray (Sample)

+ (NSArray *)sampleArray;

@end

@implementation NSArray (Sample)

+ (NSArray *)sampleArray
{
    return @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",
             @"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
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
    [self setupBrickView];
    [self registerNibs];

    self.list = [[NSArray sampleArray] mutableCopy];
    [self.brickView reloadData];
}

- (void)setupBrickView
{
    self.brickView = [[BrickView alloc]initWithFrame:self.view.bounds];
    self.brickView.dataSource = self;
    self.brickView.delegate = self;
    self.brickView.padding = 10.;
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    headerLabel.text = @"HEADER";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    self.brickView.headerView = headerLabel;
    UILabel *footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    footerLabel.text = @"FOOTER";
    footerLabel.textAlignment = NSTextAlignmentCenter;
    self.brickView.footerView = footerLabel;
    [self.view addSubview:self.brickView];
}

- (void)registerNibs
{
    UINib *nib = [UINib nibWithNibName:@"DemoBrickViewCell" bundle:nil];
    [self.brickView registerNib:nib forCellReuseIdentifier:@"Cell"];
}

#pragma mark - accessor

- (CGFloat)brickView:(BrickView *)brickView heightForCellAtIndex:(NSInteger)index
{
    CGFloat height = 0.f;
    switch (index%3) {
        case 0: {
            height = 100.f;
        }
            break;
        case 1: {
            height = 50.f;
        }
            break;
        case 2: {
            height = 70.f;
        }
            break;
    }
    return height;
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

    cell.textLabel.text = [NSString stringWithFormat:@"%ld:%@", (long)index, self.list[index]];
    switch (index%3) {
        case 0: {
            cell.backgroundColor = [UIColor grayColor];
            cell.detailLabel.text = @"detail";
        }
            break;
        case 1: {
            cell.backgroundColor = [UIColor blueColor];
            cell.detailLabel.text = nil;
        }
            break;
        case 2: {
            cell.backgroundColor = [UIColor purpleColor];
            cell.detailLabel.text = nil;
        }
            break;
    }

	return cell;
}

#pragma mark -
- (void)brickView:(BrickView *)brickView didSelectCell:(BrickViewCell *)cell AtIndex:(NSInteger)index
{
    NSLog(@"did select index %ld", (long)index);
}

- (void)brickView:(BrickView *)brickView didLongPressCell:(BrickViewCell *)cell AtIndex:(NSInteger)index
{
    NSLog(@"did long-press index %ld", (long)index);
    [self.list removeObjectAtIndex:index];
    [brickView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat bottomEdge = scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame);
    if (bottomEdge >= floor(scrollView.contentSize.height)) {
        [self.list addObjectsFromArray:[NSArray sampleArray]];
        [self.brickView updateData];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"end dragging");
}
@end
