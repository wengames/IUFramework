//
//  IUTransitionAnimator.m
//  IUController
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUTransitionAnimator.h"

#define IUTransitionContentViewTag 49061
#define IUTransitionDimmerViewTag  49062

#define IUTransitionPushBackViewControllerOffsetCurve 0.3

@interface IUTransitionAnimator ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation IUTransitionAnimator

+ (instancetype)animatorWithTransitionOperation:(IUTransitionOperation)operation {
    return [self animatorWithTransitionOperation:operation type:IUTransitionTypeDefault];
}

+ (instancetype)animatorWithTransitionOperation:(IUTransitionOperation)operation type:(IUTransitionType)type {
    IUTransitionAnimator *animator = [[self alloc] init];
    animator->_operation = operation;
    animator->_type = type;
    return animator;
}

- (instancetype)init {
    if (self = [super init]) {
        self.duration = 0.35f;
        self.animationCurve = UIViewAnimationCurveEaseOut;
    }
    return self;
}

- (void)setDimmerColor:(UIColor *)dimmerColor {
    _dimmerColor = dimmerColor;
    self.contentView.backgroundColor = _dimmerColor;
}

- (void)setDimmerView:(UIView *)dimmerView {
    if (_dimmerView.superview) {
        [_dimmerView.superview insertSubview:dimmerView aboveSubview:_dimmerView];
        [_dimmerView removeFromSuperview];
    }
    _dimmerView = dimmerView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.tag = IUTransitionContentViewTag;
    }
    return _contentView;
}

- (UIView *)contentViewWithContainerView:(UIView *)containerView {
    UIView *contentView = [containerView viewWithTag:IUTransitionContentViewTag];
    if (contentView == nil && self.dimmerColor) {
        contentView = self.contentView;
        contentView.frame = containerView.bounds;
        [containerView addSubview:contentView];
    }
    return contentView;
}

- (UIView *)dimmerViewWithContainerView:(UIView *)containerView {
    UIView *dimmerView = [containerView viewWithTag:IUTransitionDimmerViewTag];
    if (dimmerView == nil && self.dimmerView) {
        dimmerView = self.dimmerView;
        dimmerView.tag = IUTransitionDimmerViewTag;
        [containerView addSubview:dimmerView];
    }
    return dimmerView;
}

#pragma mark UIViewControllerTransitioningDelegate
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    UIView *contentView = [self contentViewWithContainerView:containerView];
    UIView *dimmerView = [self dimmerViewWithContainerView:containerView];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    void(^animations)(void) = nil;
    switch (_operation) {
        case IUTransitionOperationPush:
        case IUTransitionOperationPresent:
        {
            switch (_type) {
                case IUTransitionTypeDefault:
                case IUTransitionTypeFade:
                {
                    if (contentView) contentView.alpha = 0.0;
                    if (dimmerView) dimmerView.alpha = 0.0;
                    animations = ^{
                        if (contentView) contentView.alpha = 1.0;
                        if (dimmerView) dimmerView.alpha = 1.0;
                    };
                }
                    break;
                    
                default:
                    break;
            }
            // present时, 需要将 presentedView 显示在屏幕上
            if (toViewController.view.superview == nil) [containerView addSubview:toViewController.view];
        }
            break;
        case IUTransitionOperationPop:
        case IUTransitionOperationDismiss:
        {
            switch (_type) {
                case IUTransitionTypeDefault:
                case IUTransitionTypeFade:
                {
                    animations = ^{
                        if (contentView) contentView.alpha = 0.0;
                        if (dimmerView) dimmerView.alpha = 0.0;
                    };
                }
                    break;
                    
                default:
                    break;
            }
            
            // dismiss时, 如 presentingView 不在屏幕上, 需要将其显示在屏幕上
            if (toViewController.view.superview == nil) [containerView insertSubview:toViewController.view atIndex:0];
            [containerView bringSubviewToFront:fromViewController.view];
        }
            break;
            
        default:
            break;
    }
    
    fromViewController.view.userInteractionEnabled = NO;
    toViewController.view.userInteractionEnabled = NO;
    
    [self initAnimationWithTransition:transitionContext];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | (self.animationCurve << 16)
                     animations:^{
                         
                         if (animations) animations();
                         
                         [self performAnimationWithTransition:transitionContext];
                         
                     } completion:^(BOOL finished) {
                         
                         fromViewController.view.userInteractionEnabled = YES;
                         toViewController.view.userInteractionEnabled = YES;
                         
//                         [transitionContext finishInteractiveTransition];
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         
                         [self completeAnimationWithTransition:transitionContext finished:finished];
                     }];
}

- (void)initAnimationWithTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    CGFloat containerWidth  = transitionContext.containerView.bounds.size.width;
    CGFloat containerHeight = transitionContext.containerView.bounds.size.height;
    switch (_operation) {
        case IUTransitionOperationPush:
        {
            UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            switch (_type) {
                case IUTransitionTypeDefault:
                {
                    toViewController.view.frame = CGRectOffset([transitionContext finalFrameForViewController:toViewController], containerWidth, 0);
                    
                    toViewController.view.layer.shadowOffset = CGSizeMake(-5, 0);
                    toViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
                    toViewController.view.layer.shadowRadius = 2;
                    toViewController.view.layer.shadowOpacity = 0.1;

                }
                    break;
                case IUTransitionTypeFade:
                {
                    toViewController.view.alpha = 0.0;
                    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case IUTransitionOperationPop:
        {
            UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            switch (_type) {
                case IUTransitionTypeDefault:
                {
                    toViewController.view.frame = CGRectOffset([transitionContext finalFrameForViewController:toViewController], -containerWidth * IUTransitionPushBackViewControllerOffsetCurve, 0);
                    
                    fromViewController.view.layer.shadowOffset = CGSizeMake(-5, 0);
                    fromViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
                    fromViewController.view.layer.shadowRadius = 2;
                    fromViewController.view.layer.shadowOpacity = 0.1;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case IUTransitionOperationPresent:
        {
            UIViewController *presentedViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            switch (_type) {
                case IUTransitionTypeDefault:
                {
                    presentedViewController.view.frame = CGRectOffset([transitionContext finalFrameForViewController:presentedViewController], 0, containerHeight);
                }
                    break;
                case IUTransitionTypeFade:
                {
                    presentedViewController.view.alpha = 0.0;
                    presentedViewController.view.frame = [transitionContext finalFrameForViewController:presentedViewController];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case IUTransitionOperationDismiss:
            break;
            
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(transitionAnimatorWillBeginAnimation:)]) [self.delegate transitionAnimatorWillBeginAnimation:self];
}

- (void)performAnimationWithTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    CGFloat containerWidth  = transitionContext.containerView.bounds.size.width;
    CGFloat containerHeight = transitionContext.containerView.bounds.size.height;
    switch (_operation) {
        case IUTransitionOperationPush:
        {
            UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            switch (_type) {
                case IUTransitionTypeDefault:
                    fromViewController.view.frame = CGRectOffset(fromViewController.view.frame, -containerWidth * IUTransitionPushBackViewControllerOffsetCurve, 0);;
                    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
                    break;
                case IUTransitionTypeFade:
                    toViewController.view.alpha = 1.0;
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case IUTransitionOperationPop:
        {
            UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            switch (_type) {
                case IUTransitionTypeDefault:
                    fromViewController.view.frame = CGRectOffset(fromViewController.view.frame, containerWidth, 0);
                    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
                    break;
                case IUTransitionTypeFade:
                    fromViewController.view.alpha = 0.0;
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case IUTransitionOperationPresent:
        {
            UIViewController *presentedViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            
            switch (_type) {
                case IUTransitionTypeDefault:
                    presentedViewController.view.frame = [transitionContext finalFrameForViewController:presentedViewController];
                    break;
                case IUTransitionTypeFade:
                    presentedViewController.view.alpha = 1.0;
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case IUTransitionOperationDismiss:
        {
            UIViewController *presentedViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            
            switch (_type) {
                case IUTransitionTypeDefault:
                    presentedViewController.view.frame = CGRectOffset([transitionContext initialFrameForViewController:presentedViewController], 0, containerHeight);
                    break;
                case IUTransitionTypeFade:
                    presentedViewController.view.alpha = 0.0;
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            return;
            break;
    }

    if ([self.delegate respondsToSelector:@selector(transitionAnimatorWillEndAnimation:)]) [self.delegate transitionAnimatorWillEndAnimation:self];
}

- (void)completeAnimationWithTransition:(id <UIViewControllerContextTransitioning>)transitionContext finished:(BOOL)finished {
    UIView *containerView = transitionContext.containerView;
    UIView *contentView = [self contentViewWithContainerView:containerView];
    UIView *dimmerView = [self dimmerViewWithContainerView:containerView];
    if (contentView) [contentView removeFromSuperview];
    if (dimmerView)  [dimmerView removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(transitionAnimator:didCompleteAnimation:)]) [self.delegate transitionAnimator:self didCompleteAnimation:finished];
}

@end
