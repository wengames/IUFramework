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

- (void)popBack; // override point, will also be called if it is pop by the fullScreenInteractivePopGestureRecognizer

@end
