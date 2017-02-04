//
//  UINavigationController+IUFullScreenInteractivePopGestureRecognizer.m
//  IUController
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UINavigationController+IUFullScreenInteractivePopGestureRecognizer.h"
#import "IUTransitioningDelegate.h"
#import <objc/runtime.h>

static char TAG_TRANSITION_GESTURE_RECOGNIZER_HELPER;

@interface _IUNavigationControllerGestureRecognizerHelper : NSObject <UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@property (nonatomic, strong, readonly) UIPanGestureRecognizer  *panGestureRecognizer;
@property (nonatomic, strong, readonly) IUTransitioningDelegate *transitioningDelegate;

@end

@interface UINavigationController ()

@property (nonatomic, strong, readonly) _IUNavigationControllerGestureRecognizerHelper *transitionGestureRecognizerHelper;

@end

@implementation UINavigationController (IUFullScreenInteractivePopGestureRecognizer)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setDelegate:)), class_getInstanceMethod(self, @selector(iu_setDelegate:)));
}

- (void)iu_setDelegate:(id<UINavigationControllerDelegate>)delegate {
    self.transitionGestureRecognizerHelper.transitioningDelegate.delegate = delegate;
}

- (_IUNavigationControllerGestureRecognizerHelper *)transitionGestureRecognizerHelper {
    _IUNavigationControllerGestureRecognizerHelper *helper = objc_getAssociatedObject(self, &TAG_TRANSITION_GESTURE_RECOGNIZER_HELPER);
    if (helper == nil) {
        helper = [[_IUNavigationControllerGestureRecognizerHelper alloc] init];
        objc_setAssociatedObject(self, &TAG_TRANSITION_GESTURE_RECOGNIZER_HELPER, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        helper.navigationController = self;
        
        self.interactivePopGestureRecognizer.enabled = NO;
        [self.view removeGestureRecognizer:self.interactivePopGestureRecognizer];
        
        [self iu_setDelegate:helper.transitioningDelegate];
        [self.view addGestureRecognizer:helper.panGestureRecognizer];
    }
    return helper;
}

- (UIGestureRecognizer *)fullScreenInteractivePopGestureRecognizer {
    return self.transitionGestureRecognizerHelper.panGestureRecognizer;
}

@end

@implementation _IUNavigationControllerGestureRecognizerHelper

@synthesize panGestureRecognizer = _panGestureRecognizer, transitioningDelegate = _transitioningDelegate;

- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (_panGestureRecognizer == nil) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        _panGestureRecognizer.enabled = NO;
        _panGestureRecognizer.delegate = self;
    }
    return _panGestureRecognizer;
}

- (IUTransitioningDelegate *)transitioningDelegate {
    if (_transitioningDelegate == nil) {
        _transitioningDelegate = [IUTransitioningDelegate transitioningDelegateWithType:IUTransitionTypeDefault];
        _transitioningDelegate.config = ^(IUTransitionAnimator *animator){
            animator.duration = 0.25f;
        };
    }
    return _transitioningDelegate;
}

- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer {
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self.transitioningDelegate setInteractiveTransitionBegan];
            [self.navigationController.topViewController popBack];
            break;
        case UIGestureRecognizerStateChanged:
            [self.transitioningDelegate.interactiveTransition updateInteractiveTransition:[panGestureRecognizer translationInView:panGestureRecognizer.view].x / self.navigationController.view.bounds.size.width];
            break;
        case UIGestureRecognizerStateEnded:
            if ([panGestureRecognizer translationInView:panGestureRecognizer.view].x > self.navigationController.view.bounds.size.width / 12.f &&
                [panGestureRecognizer velocityInView:panGestureRecognizer.view].x    > self.navigationController.view.bounds.size.width / 8.f) {
                // finish
                [self.transitioningDelegate.interactiveTransition finishInteractiveTransition];
                break;
            }
            // no break here
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            // cancel
            [self.transitioningDelegate.interactiveTransition cancelInteractiveTransition];
            break;
            
        default:
            break;
    }
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view];
        if (velocity.x > fabs(velocity.y)) {
            return YES;
        }
    }
    return NO;
}

@end

@implementation UIViewController (IUPopBack)

- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
