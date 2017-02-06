//
//  UINavigationController+IUFullScreenInteractivePopGestureRecognizer.h
//  IUController
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (IUFullScreenInteractivePopGestureRecognizer)

@property (nonatomic, readonly) UIGestureRecognizer *fullScreenInteractivePopGestureRecognizer; // enable defaults NO

@end

@interface UIViewController (IUPopBack)

@property (nonatomic, strong) UIBarButtonItem *backButtonItem; // default is a bar button item with a button as a custom view, set nil to hide it

// override point, will also be called if it is pop by the fullScreenInteractivePopGestureRecognizer
// defaults call [self.navigationController popViewControllerAnimated:YES]
- (void)popBack;

@end
