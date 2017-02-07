//
//  UIView+IUTouchAreaExpand.m
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIView+IUTouchAreaExpand.h"
#import <objc/runtime.h>

static char TAG_VIEW_TOUCH_AREA_EXPAND_INSETS;

@implementation UIView (IUTouchAreaExpand)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(pointInside:withEvent:)), class_getInstanceMethod(self, @selector(iu_pointInside:withEvent:)));
}

- (void)setExpandEdge:(CGFloat)edge {
    self.expandInsets = UIEdgeInsetsMake(edge, edge, edge, edge);
}

- (void)setExpandInsets:(UIEdgeInsets)expandInsets {
    objc_setAssociatedObject(self, &TAG_VIEW_TOUCH_AREA_EXPAND_INSETS, [NSValue valueWithUIEdgeInsets:expandInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)expandInsets {
    return [objc_getAssociatedObject(self, &TAG_VIEW_TOUCH_AREA_EXPAND_INSETS) UIEdgeInsetsValue];
}

- (BOOL)iu_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets expandInsets = self.expandInsets;
    if (UIEdgeInsetsEqualToEdgeInsets(expandInsets, UIEdgeInsetsZero)) {
        return [self iu_pointInside:point withEvent:event];
    } else {
        CGRect rect = self.bounds;
        rect.origin.x -= expandInsets.left;
        rect.origin.y -= expandInsets.top;
        rect.size.width += expandInsets.left + expandInsets.right;
        rect.size.height += expandInsets.top + expandInsets.bottom;
        return CGRectContainsPoint(rect, point);
    }
}

@end
