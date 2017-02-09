//
//  UIViewController+IUPreviewing.h
//  IUController
//
//  Created by admin on 2017/2/8.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (IUPreviewing)

/**
 //TODO
 UIView category self.viewController
 
 - (BOOL)containView:(UIView *)view;
 - (BOOL)ownView:(UIView *)view;
 */

///
- (void)registerPreviewingWithSourceView:(UIView *)sourceView viewControllerCreator:(UIViewController *(^)())creator;

@end
