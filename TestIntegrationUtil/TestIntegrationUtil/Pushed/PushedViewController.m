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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    [self.navigationController performSelector:@selector(setInterfaceOrientation:) withObject:@(UIInterfaceOrientationMaskLandscapeLeft)];
//    [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:@([UIDevice currentDevice].orientation)];
    //    [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:@(orientation)afterDelay:0];
    
//    UIWindow
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController setViewControllers:self.navigationController.viewControllers animated:YES];
//    [self.navigationController pushViewController:[[TTTViewController alloc] init] animated:NO];
    
    [self.view addSubview:[[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)].setText(@"Pushed")];
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

@end
