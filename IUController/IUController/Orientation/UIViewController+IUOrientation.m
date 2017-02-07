//
//  UIViewController+IUOrientation.m
//  IUController
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUOrientation.h"
#import "objc/runtime.h"

@implementation UIViewController (IUOrientation)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewWillAppear:)), class_getInstanceMethod(self, @selector(iu_viewWillAppear:)));
}

- (void)iu_viewWillAppear:(BOOL)animated {
    [self iu_viewWillAppear:animated];
    [self _iu_viewWillAppear:animated];
    if (self.navigationController && ([self supportedInterfaceOrientations] & (1 << self.navigationController.interfaceOrientation)) == 0) {
        [self presentViewController:[[UIViewController alloc] init] animated:NO completion:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
    }

    [self.class attemptRotationToDeviceOrientation];
}

- (void)_iu_viewWillAppear:(BOOL)animated { }

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
