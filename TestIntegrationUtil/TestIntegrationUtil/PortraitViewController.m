//
//  PortraitViewController.m
//  TestIntegrationUtil
//
//  Created by admin on 2017/1/24.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "PortraitViewController.h"

@interface PortraitViewController ()

@end

@implementation PortraitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"landscape";

    self.view.backgroundColor = [UIColor cyanColor];

    [self.view addSubview:[[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)].setText(@"landscape")];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

@end
