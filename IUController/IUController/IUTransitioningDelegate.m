//
//  IUTransitioningDelegate.m
//  IUController
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUTransitioningDelegate.h"

@interface IUTransitioningDelegate ()

@property (nonatomic, assign) BOOL interactiveTransitionEnabled; // defaults NO, set enabled when interactive transition began, and disable it later.

@end

@implementation IUTransitioningDelegate

@synthesize interactiveTransition = _interactiveTransition;

+ (instancetype)transitioningDelegateWithType:(IUTransitionType)type {
    IUTransitioningDelegate *transitioningDelegate = [[self alloc] init];
    transitioningDelegate.type = type;
    return transitioningDelegate;
}

- (UIPercentDrivenInteractiveTransition *)interactiveTransition {
    if (_interactiveTransition == nil) {
        _interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        _interactiveTransition.completionCurve = UIViewAnimationCurveEaseOut;
    }
    return _interactiveTransition;
}

- (void)setInteractiveTransitionBegan {
    self.interactiveTransitionEnabled = YES;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if (self.type == IUTransitionTypeFade) {
        presented.modalPresentationStyle = UIModalPresentationCustom;
    }
    IUTransitionAnimator *animator = [IUTransitionAnimator animatorWithTransitionOperation:IUTransitionOperationPresent type:self.type];
    if (self.config) self.config(animator);
    return animator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    id<UIViewControllerInteractiveTransitioning> transition = self.interactiveTransitionEnabled ? self.interactiveTransition : nil;
    self.interactiveTransitionEnabled = NO;
    return transition;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    IUTransitionAnimator *animator = [IUTransitionAnimator animatorWithTransitionOperation:IUTransitionOperationDismiss type:self.type];
    if (self.config) self.config(animator);
    return animator;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    id<UIViewControllerInteractiveTransitioning> transition = self.interactiveTransitionEnabled ? self.interactiveTransition : nil;
    self.interactiveTransitionEnabled = NO;
    return transition;
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if ([self.delegate respondsToSelector:_cmd]) return [self.delegate navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
    IUTransitionAnimator *animator = [IUTransitionAnimator animatorWithTransitionOperation:operation type:self.type];
    if (self.config) self.config(animator);
    return animator;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    id<UIViewControllerInteractiveTransitioning> transition = self.interactiveTransitionEnabled ? self.interactiveTransition : nil;
    self.interactiveTransitionEnabled = NO;
    if ([self.delegate respondsToSelector:_cmd]) return [self.delegate navigationController:navigationController interactionControllerForAnimationController:animationController];
    return transition;
}

#pragma mark - redirect
- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [self.delegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
    return self;
}

@end
