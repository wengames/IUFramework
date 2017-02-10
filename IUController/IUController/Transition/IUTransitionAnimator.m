//
//  IUTransitionAnimator.m
//  IUController
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUTransitionAnimator.h"
#import "UIViewController+IUMagicTransition.h"
#import <objc/runtime.h>

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
        self.animationCurve = UIViewAnimationCurveLinear;
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
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    void(^initAnimation)(void) = ^{};
    void(^animations)(void) = ^{};
    void(^completion)(BOOL) = ^(BOOL finished){};
    
    // add view on container
    {
        switch (self.operation) {
            case IUTransitionOperationPush:
            case IUTransitionOperationPresent:
                if (toViewController.view.superview == nil) {
                    initAnimation = ^{
                        initAnimation();
                        [containerView addSubview:toViewController.view];
                    };
                }
                break;
            case IUTransitionOperationPop:
            case IUTransitionOperationDismiss:
                if (toViewController.view.superview == nil) {
                    initAnimation = ^{
                        initAnimation();
                        [containerView insertSubview:toViewController.view atIndex:0];
                        [containerView bringSubviewToFront:fromViewController.view];
                    };
                }
                break;
        }
    }
    
    // dimmer
    {
        UIView *contentView = [self contentViewWithContainerView:containerView];
        UIView *dimmerView = [self dimmerViewWithContainerView:containerView];
        if (contentView || dimmerView) {
            switch (self.operation) {
                case IUTransitionOperationPush:
                case IUTransitionOperationPresent:
                {
                    initAnimation = ^{
                        initAnimation();
                        if (contentView) contentView.alpha = 0.0;
                        if (dimmerView) dimmerView.alpha = 0.0;
                    };
                    animations = ^{
                        if (contentView) contentView.alpha = 1.0;
                        if (dimmerView) dimmerView.alpha = 1.0;
                    };
                }
                    break;
                case IUTransitionOperationPop:
                case IUTransitionOperationDismiss:
                {
                    animations = ^{
                        if (contentView) contentView.alpha = 0.0;
                        if (dimmerView) dimmerView.alpha = 0.0;
                    };
                }
                    break;
            }
            
            completion = ^(BOOL finished) {
                completion(finished);
                if (contentView) [contentView removeFromSuperview];
                if (dimmerView)  [dimmerView removeFromSuperview];
            };
        }
    }
    
    // shadow
    do {
        switch (self.type) {
            case IUTransitionTypeDefault:
                switch (self.operation) {
                    case IUTransitionOperationPush:
                    {
                        CGSize shadowOffset = toViewController.view.layer.shadowOffset;
                        CGColorRef shadowColor = toViewController.view.layer.shadowColor;
                        CGFloat shadowRadius = toViewController.view.layer.shadowRadius;
                        CGFloat shadowOpacity = toViewController.view.layer.shadowOpacity;

                        initAnimation = ^{
                            initAnimation();
                            toViewController.view.layer.shadowOffset = CGSizeMake(-5, 0);
                            toViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
                            toViewController.view.layer.shadowRadius = 2;
                            toViewController.view.layer.shadowOpacity = 0.1;
                        };
                        
                        completion = ^(BOOL finshed) {
                            completion(finshed);
                            toViewController.view.layer.shadowOffset = shadowOffset;
                            toViewController.view.layer.shadowColor = shadowColor;
                            toViewController.view.layer.shadowRadius = shadowRadius;
                            toViewController.view.layer.shadowOpacity = shadowOpacity;
                        };
                    }
                        break;
                    case IUTransitionOperationPop:
                    {
                        CGSize shadowOffset = fromViewController.view.layer.shadowOffset;
                        CGColorRef shadowColor = fromViewController.view.layer.shadowColor;
                        CGFloat shadowRadius = fromViewController.view.layer.shadowRadius;
                        CGFloat shadowOpacity = fromViewController.view.layer.shadowOpacity;
                        
                        initAnimation = ^{
                            initAnimation();
                            fromViewController.view.layer.shadowOffset = CGSizeMake(-5, 0);
                            fromViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
                            fromViewController.view.layer.shadowRadius = 2;
                            fromViewController.view.layer.shadowOpacity = 0.1;
                        };
                        
                        completion = ^(BOOL finshed) {
                            completion(finshed);
                            fromViewController.view.layer.shadowOffset = shadowOffset;
                            fromViewController.view.layer.shadowColor = shadowColor;
                            fromViewController.view.layer.shadowRadius = shadowRadius;
                            fromViewController.view.layer.shadowOpacity = shadowOpacity;
                        };
                    }
                        break;
                    case IUTransitionOperationPresent:
                    case IUTransitionOperationDismiss:
                        break;
                }
                break;
        }
    } while (0);
    
    // view frame animation
    {
        initAnimation = ^{
            initAnimation();
            
            fromViewController.view.frame = [transitionContext initialFrameForViewController:fromViewController];
            if (!CGRectEqualToRect(CGRectZero, [transitionContext initialFrameForViewController:toViewController])) {
                toViewController.view.frame = [transitionContext initialFrameForViewController:toViewController];
            }
            CGRect toFinalFrame = [transitionContext finalFrameForViewController:toViewController];
            
            switch (self.type) {
                case IUTransitionTypeDefault:
                    switch (self.operation) {
                        case IUTransitionOperationPush:
                            toViewController.view.frame = CGRectOffset(toFinalFrame, containerView.bounds.size.width, 0);
                            break;
                        case IUTransitionOperationPop:
                            toViewController.view.frame = CGRectOffset(toFinalFrame, -containerView.bounds.size.width * IUTransitionPushBackViewControllerOffsetCurve, 0);
                            break;
                        case IUTransitionOperationPresent:
                            toViewController.view.frame = CGRectOffset(toFinalFrame, 0, containerView.bounds.size.height);
                            break;
                        case IUTransitionOperationDismiss:
                            break;
                    }
                    break;
                case IUTransitionTypeFade:
                    switch (self.operation) {
                        case IUTransitionOperationPush:
                        case IUTransitionOperationPresent:
                            toViewController.view.alpha = 0.0;
                            break;
                        case IUTransitionOperationPop:
                        case IUTransitionOperationDismiss:
                            break;
                    }
                    break;
            }
        };
        
        animations = ^{
            animations();
            
            toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
            if (!CGRectEqualToRect(CGRectZero, [transitionContext finalFrameForViewController:fromViewController])) {
                fromViewController.view.frame = [transitionContext finalFrameForViewController:fromViewController];
            }
            CGRect fromInitialFrame = [transitionContext initialFrameForViewController:fromViewController];
            
            switch (self.type) {
                case IUTransitionTypeDefault:
                    switch (self.operation) {
                        case IUTransitionOperationPush:
                            fromViewController.view.frame = CGRectOffset(fromInitialFrame, -containerView.bounds.size.width * IUTransitionPushBackViewControllerOffsetCurve, 0);
                            break;
                        case IUTransitionOperationPop:
                            fromViewController.view.frame = CGRectOffset(fromInitialFrame, containerView.bounds.size.width, 0);
                            break;
                        case IUTransitionOperationPresent:
                            break;
                        case IUTransitionOperationDismiss:
                            fromViewController.view.frame = CGRectOffset(fromInitialFrame, 0, containerView.bounds.size.height);
                            break;
                    }
                    break;
                case IUTransitionTypeFade:
                    switch (self.operation) {
                        case IUTransitionOperationPush:
                        case IUTransitionOperationPresent:
                            toViewController.view.alpha = 1.0;
                            break;
                        case IUTransitionOperationPop:
                        case IUTransitionOperationDismiss:
                            fromViewController.view.alpha = 0.0;
                            break;
                    }
                    break;
            }
        };
        
        completion = ^(BOOL finished) {
            completion(finished);
            if (self.type == IUTransitionTypeFade) {
                fromViewController.view.alpha = 1.0;
                toViewController.view.alpha = 1.0;
            }
        };
    }
    
    // call delegate
    {
        __weak typeof(self.delegate) delegate = self.delegate;
        
        if ([delegate respondsToSelector:@selector(transitionAnimator:willBeginTransition:)]) {
            initAnimation = ^{
                initAnimation();
                [delegate transitionAnimator:self willBeginTransition:transitionContext];
            };
        }
        
        if ([delegate respondsToSelector:@selector(transitionAnimator:willEndTransition:)]) {
            animations = ^{
                animations();
                [delegate transitionAnimator:self willEndTransition:transitionContext];
            };
        }
        
        if ([delegate respondsToSelector:@selector(transitionAnimator:didCompleteTransition:finished:)]) {
            completion = ^(BOOL finished) {
                completion(finished);
                [delegate transitionAnimator:self didCompleteTransition:transitionContext finished:finished];
            };
        }
    }
    
    // magic move
    do {
        NSArray <UIView *> *fromMagicViews = [fromViewController magicViewsTransitionToViewController:toViewController];
        NSArray <UIView *> *toMagicViews = [toViewController magicViewsTransitionFromViewController:fromViewController];
        
        if ([fromMagicViews count] == 0 || [fromMagicViews count] != [toMagicViews count]) break;

        static const NSString *MAGIC_VIEW_ANIMATION_KEY = @"MAGIC_VIEW_ANIMATION_KEY";
        
        for (int i = 0; i < [fromMagicViews count]; i++) {
            UIView *fromMagicView = fromMagicViews[i];
            UIView *toMagicView = toMagicViews[i];
            
            initAnimation = ^{
                initAnimation();
                fromMagicView.frame = [containerView convertRect:fromMagicView.bounds fromView:fromMagicView];
                [containerView addSubview:fromMagicView];
                fromMagicView.frame = [containerView convertRect:fromMagicView.bounds fromView:fromMagicView];
                [fromMagicView layoutIfNeeded];
                toMagicView.hidden = YES;
            };
            
            animations = ^{
                animations();
                
                /* move animation */
                fromMagicView.frame = [containerView convertRect:toMagicView.bounds fromView:toMagicView];
                [fromMagicView layoutIfNeeded];
                
                /* lift drop animation */
#define _kLiftHeight   8
#define _kShadowOffset CGSizeMake(3, 10)
                CATransform3D transform = fromMagicView.layer.transform;
                
                CAAnimationGroup *animation = [[CAAnimationGroup alloc] init];
                animation.duration = [self transitionDuration:transitionContext];
                animation.removedOnCompletion = NO;
                animation.fillMode = kCAFillModeForwards;
                
                // lift
                CAAnimationGroup *lift = [[CAAnimationGroup alloc] init];
                lift.duration = animation.duration * 0.2;
                lift.beginTime = 0;
                lift.removedOnCompletion = NO;
                lift.fillMode = kCAFillModeForwards;
                {
                    CABasicAnimation *shadowOffsetAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOffset"];
                    shadowOffsetAnimation.duration = lift.duration;
                    shadowOffsetAnimation.byValue = [NSValue valueWithCGSize:_kShadowOffset];
                    
                    CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
                    shadowOpacityAnimation.duration = lift.duration;
                    shadowOpacityAnimation.byValue = @0.5;
                    
                    CABasicAnimation *trasformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
                    trasformAnimation.duration = lift.duration;
                    transform = CATransform3DTranslate(transform, 0, -_kLiftHeight, 0);
                    trasformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
                    
                    lift.animations = @[shadowOffsetAnimation, shadowOpacityAnimation, trasformAnimation];
                }
                
                // drop
                CAAnimationGroup *drop = [[CAAnimationGroup alloc] init];
                drop.beginTime = lift.duration;
                drop.duration = animation.duration - drop.beginTime;
                drop.removedOnCompletion = NO;
                drop.fillMode = kCAFillModeForwards;
                {
                    CABasicAnimation *shadowOffsetAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOffset"];
                    shadowOffsetAnimation.duration = drop.duration;
                    shadowOffsetAnimation.toValue = [NSValue valueWithCGSize:fromMagicView.layer.shadowOffset];
                    
                    CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
                    shadowOpacityAnimation.duration = drop.duration;
                    shadowOpacityAnimation.toValue = @(fromMagicView.layer.shadowOpacity);
                    
                    CABasicAnimation *trasformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
                    trasformAnimation.duration = drop.duration;
                    transform = CATransform3DTranslate(transform, 0, _kLiftHeight, 0);
                    trasformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
                    
                    drop.animations = @[shadowOffsetAnimation, shadowOpacityAnimation, trasformAnimation];
                }
                
                // set animation
                animation.animations = @[lift, drop];
                [animation setValue:fromMagicView forKey:MAGIC_VIEW_ANIMATION_KEY];
                [fromMagicView.layer addAnimation:animation forKey:MAGIC_VIEW_ANIMATION_KEY];
                
            };
            
            __weak UIView *weakFromView = fromMagicView;
            __weak UIView *weakToView = toMagicView;
            __weak UIView *weakSuperview = fromMagicView.superview;
            CGRect frame = fromMagicView.frame;
            BOOL toViewHidden = toMagicView.hidden;
            completion = ^(BOOL finished) {
                completion(finished);
                [weakSuperview addSubview:weakFromView];
                weakFromView.frame = frame;
                weakToView.hidden = toViewHidden;
                [weakFromView.layer removeAnimationForKey:MAGIC_VIEW_ANIMATION_KEY];
            };
        }
        
    } while (0);
    
    fromViewController.view.userInteractionEnabled = NO;
    toViewController.view.userInteractionEnabled = NO;
    
    initAnimation();
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | (self.animationCurve << 16)
                     animations:animations
                     completion:^(BOOL finished) {
                         
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         
                         completion(finished);
                         
                         fromViewController.view.userInteractionEnabled = YES;
                         toViewController.view.userInteractionEnabled = YES;
                         
                     }];
}

@end
