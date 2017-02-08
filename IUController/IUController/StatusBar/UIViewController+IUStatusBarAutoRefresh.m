//
//  UIViewController+IUStatusBarAutoRefresh.m
//  IUController
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUStatusBarAutoRefresh.h"
#import "objc/runtime.h"

@implementation UIViewController (IUStatusBarAutoRefresh)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewDidLayoutSubviews)), class_getInstanceMethod(self, @selector(iuStatusBarAutoRefresh_UIViewController_viewDidLayoutSubviews)));
}

- (void)iuStatusBarAutoRefresh_UIViewController_viewDidLayoutSubviews {
    [self iuStatusBarAutoRefresh_UIViewController_viewDidLayoutSubviews];
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
