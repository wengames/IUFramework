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

@implementation UIViewController (IUPopBack)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(willMoveToParentViewController:)), class_getInstanceMethod(self, @selector(iu_willMoveToParentViewController:)));
}

- (void)iu_willMoveToParentViewController:(UIViewController *)parent {
    [self iu_willMoveToParentViewController:parent];
    if ([parent isKindOfClass:[UINavigationController class]]) {
        
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        NSMutableArray *items = [self.navigationItem.leftBarButtonItems mutableCopy];
        if ([[(UINavigationController *)parent viewControllers] firstObject] != self) {
            
            if (self.backButtonItem && ![items containsObject:self.backButtonItem]) {
                self.navigationItem.leftBarButtonItems = [@[self.backButtonItem] arrayByAddingObjectsFromArray:items];
            }
            
        } else {
            
            if ([items containsObject:self.backButtonItem]) {
                [items removeObject:self.backButtonItem];
                self.navigationItem.leftBarButtonItems = [items copy];
            }
        }
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

- (void)popBack {
    NSUInteger count = [self.navigationController.viewControllers count];
    if (count > 1) {
        [self.navigationController popViewControllerAnimated:([self.navigationController.viewControllers[count - 2] supportedInterfaceOrientations] & (1 << self.navigationController.interfaceOrientation))];
    }
}

@end
