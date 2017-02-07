//
//  UINavigationController+IUFullScreenInteractivePopGestureRecognizer.h
//  IUController
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (IUFullScreenInteractivePopGestureRecognizer)

// lazy loading
// both gesture recognizer will be created after any one be called
// using "navigationController.fullScreenInteractivePopGestureRecognizer.enabled = YES" to enable both
@property (nonatomic, readonly) UIGestureRecognizer *fullScreenInteractivePopGestureRecognizer; // enable defaults NO
@property (nonatomic, readonly) UIGestureRecognizer *edgeScreenInteractivePopGestureRecognizer; // enable defaults YES

@end

@interface UIViewController (IUPopBack)

@property (nonatomic, strong) UIBarButtonItem *backButtonItem;    // default is a bar button item with a button as a custom view, set nil to hide it
@property (nonatomic, strong) UIBarButtonItem *dismissButtonItem; // default is a bar button item with a button as a custom view, set nil to hide it

// action of backButtonItem
// override point, will also be called if it is pop by the fullScreenInteractivePopGestureRecognizer
// defaults call [self.navigationController popViewControllerAnimated:YES]
- (void)popBack;

// action of dismissButtonItem
// override point
// defaults call [self.navigationController dismissViewControllerAnimated:YES completion:nil]
- (void)dismiss;

@end
