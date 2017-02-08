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

@property (nonatomic, strong, readonly) UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer  *panGestureRecognizer;
@property (nonatomic, strong, readonly) IUTransitioningDelegate *transitioningDelegate;

@end

@interface UIViewController ()

- (void)_showDismissButtonItem:(BOOL)show;

@end

@interface UINavigationController ()

@property (nonatomic, strong, readonly) _IUNavigationControllerGestureRecognizerHelper *transitionGestureRecognizerHelper;

@end

@implementation UINavigationController (IUFullScreenInteractivePopGestureRecognizer)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setDelegate:)), class_getInstanceMethod(self, @selector(iu_setDelegate:)));
    if (![self instancesRespondToSelector:@selector(iu_viewWillAppear:)]) {
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewWillAppear:)), class_getInstanceMethod(self, @selector(_iu_viewWillAppear:)));
    }
    
}

// method called by UIViewController(IUOrientation)
- (void)_iu_viewWillAppear:(BOOL)animated {
    if (![self respondsToSelector:@selector(iu_viewWillAppear:)]) [self _iu_viewWillAppear:animated];
    [[self.viewControllers firstObject] _showDismissButtonItem:self.presentingViewController];
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
        [self.view addGestureRecognizer:helper.edgePanGestureRecognizer];
        [helper.panGestureRecognizer requireGestureRecognizerToFail:helper.edgePanGestureRecognizer];
    }
    return helper;
}

- (UIGestureRecognizer *)fullScreenInteractivePopGestureRecognizer {
    return self.transitionGestureRecognizerHelper.panGestureRecognizer;
}

- (UIGestureRecognizer *)edgeScreenInteractivePopGestureRecognizer {
    return self.transitionGestureRecognizerHelper.edgePanGestureRecognizer;
}

@end

@implementation _IUNavigationControllerGestureRecognizerHelper

@synthesize edgePanGestureRecognizer = _edgePanGestureRecognizer, panGestureRecognizer = _panGestureRecognizer, transitioningDelegate = _transitioningDelegate;

- (UIScreenEdgePanGestureRecognizer *)edgePanGestureRecognizer {
    if (_edgePanGestureRecognizer == nil) {
        _edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        _edgePanGestureRecognizer.edges = UIRectEdgeLeft;
    }
    return _edgePanGestureRecognizer;
}

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
            animator.duration = .25f;
        };
    }
    return _transitioningDelegate;
}

- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer {
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self.transitioningDelegate beginInteractiveTransition];
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
                [self.transitioningDelegate endInteractiveTransition];
                break;
            }
            // no break here
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            // cancel
            [self.transitioningDelegate.interactiveTransition cancelInteractiveTransition];
            [self.transitioningDelegate endInteractiveTransition];
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

static char TAG_VIEW_CONTROLLER_BACK_BUTTON_ITEM;
static char TAG_VIEW_CONTROLLER_BACK_BUTTON_ITEM_CREATED;

static char TAG_VIEW_CONTROLLER_DISSMISS_BUTTON_ITEM;
static char TAG_VIEW_CONTROLLER_DISSMISS_BUTTON_ITEM_CREATED;

@implementation UIViewController (IUPopBack)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(willMoveToParentViewController:)), class_getInstanceMethod(self, @selector(iu_willMoveToParentViewController:)));
}

- (void)iu_willMoveToParentViewController:(UIViewController *)parent {
    [self iu_willMoveToParentViewController:parent];
    if ([parent isKindOfClass:[UINavigationController class]]) {
        
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        NSMutableArray *items = [self.navigationItem.leftBarButtonItems ?: @[] mutableCopy];
        if ([[(UINavigationController *)parent viewControllers] firstObject] != self) {
            
            if ([items containsObject:self.dismissButtonItem]) {
                [items removeObject:self.dismissButtonItem];
            }
            
            if (self.backButtonItem && ![items containsObject:self.backButtonItem]) {
                [items insertObject:self.backButtonItem atIndex:0];
            }
            
        } else {
            
            if ([items containsObject:self.backButtonItem]) {
                [items removeObject:self.backButtonItem];
            }
            
        }
        self.navigationItem.leftBarButtonItems = [items copy];
    }
}

- (void)setBackButtonItem:(UIBarButtonItem *)backButtonItem {
    objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_BACK_BUTTON_ITEM_CREATED, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIBarButtonItem *oldItem = self.backButtonItem;
    NSMutableArray *items = [self.navigationItem.leftBarButtonItems mutableCopy];
    if (oldItem && items) {
        NSUInteger index = [items indexOfObject:oldItem];
        if (index != NSNotFound) {
            [items removeObjectAtIndex:index];
        } else {
            index = 0;
        }
        
        if (backButtonItem) {
            [items insertObject:backButtonItem atIndex:index];
        }
        
        self.navigationItem.leftBarButtonItems = [items copy];
    }
    objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_BACK_BUTTON_ITEM, backButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBarButtonItem *)backButtonItem {
    UIBarButtonItem *backButtonItem = objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_BACK_BUTTON_ITEM);
    if (backButtonItem == nil && ![objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_BACK_BUTTON_ITEM_CREATED) boolValue]) {
        objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_BACK_BUTTON_ITEM_CREATED, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        CGSize size = CGSizeMake(36, 60);
        
        UIColor *color = [UINavigationBar appearance].tintColor ?: [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
        CGFloat r,g,b,a;
        [color getRed:&r green:&g blue:&b alpha:&a];
        r+=1.0; g+=1.0; b+=1.0; a+=1.0;
        r/=2.0; g/=2.0; b/=2.0; a/=2.0;
        UIColor *highlightedColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
        
        UIImage *(^getArrow)(UIColor *) = ^(UIColor *color){
            CGFloat lineWidth = 5;
            UIGraphicsBeginImageContext(size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, size.width - lineWidth, lineWidth);
            CGContextAddLineToPoint(context, lineWidth, size.height / 2.f);
            CGContextAddLineToPoint(context, size.width - lineWidth, size.height - lineWidth);
            CGContextSetLineWidth(context, lineWidth);
            CGContextSetStrokeColorWithColor(context, color.CGColor);
            CGContextStrokePath(context);
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return image;
        };

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, size.width / 3.f, size.height / 3.f);
        [button setBackgroundImage:getArrow(color) forState:UIControlStateNormal];
        [button setBackgroundImage:getArrow(highlightedColor) forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
        backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_BACK_BUTTON_ITEM, backButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return backButtonItem;
}

- (void)setDismissButtonItem:(UIBarButtonItem *)dismissButtonItem {
    objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_DISSMISS_BUTTON_ITEM_CREATED, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIBarButtonItem *oldItem = self.dismissButtonItem;
    NSMutableArray *items = [self.navigationItem.leftBarButtonItems mutableCopy];
    if (oldItem && items) {
        NSUInteger index = [items indexOfObject:oldItem];
        if (index != NSNotFound) {
            [items removeObjectAtIndex:index];
        } else {
            index = 0;
        }
        
        if (dismissButtonItem) {
            [items insertObject:dismissButtonItem atIndex:index];
        }
        
        self.navigationItem.leftBarButtonItems = [items copy];
    }
    objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_DISSMISS_BUTTON_ITEM, dismissButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBarButtonItem *)dismissButtonItem {
    UIBarButtonItem *dismissButtonItem = objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_DISSMISS_BUTTON_ITEM);
    if (dismissButtonItem == nil && ![objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_DISSMISS_BUTTON_ITEM_CREATED) boolValue]) {
        objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_DISSMISS_BUTTON_ITEM_CREATED, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        UIColor *color = [UINavigationBar appearance].tintColor ?: [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
        CGFloat r,g,b,a;
        [color getRed:&r green:&g blue:&b alpha:&a];
        r+=1.0; g+=1.0; b+=1.0; a+=1.0;
        r/=2.0; g/=2.0; b/=2.0; a/=2.0;
        UIColor *highlightedColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:color forState:UIControlStateNormal];
        [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        dismissButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_DISSMISS_BUTTON_ITEM, dismissButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dismissButtonItem;
}

- (void)_showDismissButtonItem:(BOOL)show {
    NSMutableArray *items = [self.navigationItem.leftBarButtonItems ?: @[] mutableCopy];
    if (show) {
        if (self.dismissButtonItem && ![items containsObject:self.dismissButtonItem]) {
            [items insertObject:self.dismissButtonItem atIndex:0];
        }
    } else {
        if ([items containsObject:self.dismissButtonItem]) {
            [items removeObject:self.dismissButtonItem];
        }
    }
    self.navigationItem.leftBarButtonItems = [items copy];
}

- (void)popBack {
    NSUInteger count = [self.navigationController.viewControllers count];
    if (count > 1) {
        [self.navigationController popViewControllerAnimated:([self.navigationController.viewControllers[count - 2] supportedInterfaceOrientations] & (1 << self.navigationController.interfaceOrientation))];
    }
}

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
