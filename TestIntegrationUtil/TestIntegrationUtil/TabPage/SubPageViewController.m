//
//  SubPageViewController.m
//  TestIntegrationUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "SubPageViewController.h"

@interface SubPageViewController ()

@property (nonatomic, strong) UIView *magicView;

@end

@implementation SubPageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear : %@", self.tabBarItem.title);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear : %@", self.tabBarItem.title);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear : %@", self.tabBarItem.title);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear : %@", self.tabBarItem.title);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor randomColor];
    [self.view addSubview:self.magicView];
}

- (UIView *)magicView {
    if (_magicView == nil) {
         [[UIView alloc] init]
         .bind(&_magicView)
         .setFrame(CGRectMake(self.view.bounds.size.width - 100, self.view.bounds.size.height - 100, 100, 100))
         .setAutoresizingMask(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin)
         .setBackgroundColor([self.view.backgroundColor invertColor]).intoView(self.view);
    }
    return _magicView;
}

- (NSArray *)magicViewsTransitionToViewController:(UIViewController *)viewController {
    return @[self.magicView];
}

- (NSArray *)magicViewsTransitionFromViewController:(UIViewController *)viewController {
    return @[self.magicView];
}

@end
