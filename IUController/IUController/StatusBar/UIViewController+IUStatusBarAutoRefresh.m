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
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewDidLayoutSubviews)), class_getInstanceMethod(self, @selector(iu_viewDidLayoutSubviews)));
}

- (void)iu_viewDidLayoutSubviews {
    [self iu_viewDidLayoutSubviews];
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
