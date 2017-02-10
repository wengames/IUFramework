//
//  PushedViewController.m
//  TestIntegrationUtil
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "PushedViewController.h"

@interface PushedViewController ()

@end

@implementation PushedViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.title = @"Pushed";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom].setFrame(CGRectMake(50, 150, 200, 200));
    button.titleColor = [UIColor whiteColor];
    button.backgroundColor = [UIColor greenColor];
    button.tag = 1;
    [button setTitle:@"button1" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self.view addSubview:[[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 300)].setBackgroundColor([UIColor colorWithWhite:0 alpha:0.3]).setUserInteractionEnabled(NO)];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom].setFrame(CGRectMake(100, 200, 100, 100));
    button.titleColor = [UIColor blackColor];
    button.backgroundColor = [UIColor cyanColor];
    button.expandInsets = UIEdgeInsetsMake(100, 0, 100, 100);
    button.tag = 2;
    [button setTitle:@"button2" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)tapButton:(UIButton *)button {
    NSLog(@"button%ld tapped", button.tag);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

@end
