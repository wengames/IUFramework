//
//  IUTransitioningDelegate.h
//  IUController
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IUTransitionAnimator.h"

@interface IUTransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak)   id<UINavigationControllerDelegate> delegate; // to get other method in Protocol UINavigationControllerDelegate to be invoked

@property (nonatomic, assign) IUTransitionType type;
@property (nonatomic, strong) void(^config)(IUTransitionAnimator *animator);

@property (nonatomic, strong, readonly) UIPercentDrivenInteractiveTransition *interactiveTransition;
- (void)setInteractiveTransitionBegan; // call this mothod before transition began

+ (instancetype)transitioningDelegateWithType:(IUTransitionType)type;

@end
