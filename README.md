BrickView [![Build Status](https://travis-ci.org/hirohisa/BrickView.png?branch=master)](https://travis-ci.org/hirohisa/BrickView) 
==================
BrickView is a simple dynamic grid layout view for iOS like Pinterest.
usage of BrickView is like UITableViewDelegate and UITableViewDatasource.

This package has all the documentation and demos to get you started.

![screenshot](https://raw.github.com/hirohisa/BrickView/master/BrickView Example/screenshot1.png)
![screenshot](https://raw.github.com/hirohisa/BrickView/master/BrickView Example/screenshot2.png)

Installation
----------

There are two ways to use this in your project:

- Copy `BrickView/*.{h.m}` into your project

- Install with CocoaPods to write Podfile
```ruby
platform :ios
pod 'BrickView',  '~> 0.1.1'
```

Usage
----------

### Set Delegate, DataSource

BrickView uses a simple methodology. It defines a delegate and a data source, its client implement.
BrickViewDelegate and BrickViewDataSource are like UITableViewDelegate and UITableViewDatasource. BrickViewDelegate has `UIScrollViewDelegate`'s protocol.


### Reload

Reset cells and redisplays visible cells.

```objc
- (void)reloadData;
```

### Update

If BrickView doesnt reset visible cells and displays new cells, uses `updateData`.

```objc
- (void)updateData;
```


Example
----------

- import `BrickView.h`
- implement `BrickViewDataSource` and `BrickViewDelegate`'s methods

### UIViewController

```objc


#import "BrickView.h"

@interface ExampleViewController ()

<BrickViewDataSource, BrickViewDelegate>

@end

@implementation ExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    BrickView *brickView = [[BrickView alloc]initWithFrame:self.view.bounds];
    brickView.dataSource = self;
    brickView.delegate = self;
}

- (CGFloat)brickView:(BrickView *)brickView heightForCellAtIndex:(NSInteger)index
{
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
    }
    cell.textLabel.text = @"text";

  return cell;
}

```


### License

BrickView is available under the MIT license.
