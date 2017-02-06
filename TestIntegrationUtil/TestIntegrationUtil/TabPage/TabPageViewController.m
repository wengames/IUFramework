//
//  TabPageViewController.m
//  TestIntegrationUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "TabPageViewController.h"
#import "SubPageViewController.h"

@interface TabPageViewController ()

@property (nonatomic, strong) IUTabPageViewController *tabPageViewController;

@end

@implementation TabPageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.title = @"Tab Page";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *viewControllers = [@[] mutableCopy];
    for (int i = 0; i < 10; i++) {
        UIViewController *viewController = [[SubPageViewController alloc] init];
        viewController.tabBarItem.title = [NSString stringWithFormat:@"page%d", i];
        [viewControllers addObject:viewController];
    }
    
    self.tabPageViewController.viewControllers = [viewControllers copy];
}

- (IUTabPageViewController *)tabPageViewController {
    if (_tabPageViewController == nil) {
        _tabPageViewController = [[IUTabPageViewController alloc] init];
        [self addChildViewController:_tabPageViewController];
        [self.view addSubview:_tabPageViewController.view];
    }
    return _tabPageViewController;
}

@end
