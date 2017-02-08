//
//  IUController.h
//  IUController
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef __OBJC__

// status bar
// effects when set "View controller-based status bar appearance" to "YES" in info.plist
#import "UIViewController+IUStatusBarAutoRefresh.h"
#import "UIViewController+IUStatusBarHidden.h"
#import "UIViewController+IUStatusBarStyle.h"
#import "UINavigationController+IUStatusBar.h"
#import "UITabBarController+IUStatusBar.h"

// orientation
#import "UIViewController+IUOrientation.h"
#import "UINavigationController+IUOrientation.h"
#import "UITabBarController+IUOrientation.h"

// push & pop
#import "UINavigationController+IUAutoHidesBottomBarWhenPushed.h"
#import "UINavigationController+IUFullScreenInteractivePopGestureRecognizer.h"

// transition
#import "IUTransitionAnimator.h"
#import "IUTransitioningDelegate.h"
#import "UIViewController+IUMagicTransition.h"

// base view controller
#import "IUViewController.h"

#endif
