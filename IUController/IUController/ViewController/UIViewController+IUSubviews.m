//
//  UIViewController+IUSubviews.m
//  IUController
//
//  Created by admin on 2017/2/10.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUSubviews.h"
#import <IUMethodSwizzle/IUMethodSwizzle.h>

@implementation UIViewController (IUSubviews)

+ (void)load {
    [self swizzleInstanceSelector:@selector(loadView) toSelector:@selector(iuSubviews_UIViewController_loadView)];
}

- (void)iuSubviews_UIViewController_loadView {
    [self iuSubviews_UIViewController_loadView];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
