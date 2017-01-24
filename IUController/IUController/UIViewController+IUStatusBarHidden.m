//
//  UIViewController+IUStatusBarHidden.m
//  IUController
//
//  Created by admin on 2017/1/24.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIViewController+IUStatusBarHidden.h"
#import "objc/runtime.h"

static char TAG_VIEW_CONTROLLER_STATUS_BAR_HIDDEN;

@implementation UIViewController (IUStatusBarHidden)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewDidLayoutSubviews)), class_getInstanceMethod(self, @selector(iu_viewDidLayoutSubviews)));
}

- (void)iu_viewDidLayoutSubviews {
    [self iu_viewDidLayoutSubviews];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    objc_setAssociatedObject(self, &TAG_VIEW_CONTROLLER_STATUS_BAR_HIDDEN, @(statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)statusBarHidden {
    return [objc_getAssociatedObject(self, &TAG_VIEW_CONTROLLER_STATUS_BAR_HIDDEN) boolValue];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.statusBarHidden) return UIStatusBarStyleDefault;
    
    CGFloat brightness = 0, alpha = 1;
    BOOL s = [[self statusBarBackgroundColor] getHue:nil saturation:nil brightness:&brightness alpha:&alpha];
    return brightness * alpha > 0.5 ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}

- (UIColor *)statusBarBackgroundColor {
    UIGraphicsBeginImageContext(CGSizeMake(self.view.bounds.size.width, 20));
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize = CGSizeMake(3, 1);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
         
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData(context);
         
    if (data == NULL) return nil;
    
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    for (int x = 0; x < thumbSize.width; x++) {
        for (int y = 0; y < thumbSize.height; y++) {
            int offset = 4*x*y;
            int red   = data[offset];
            int green = data[offset+1];
            int blue  = data[offset+2];
            int alpha = data[offset+3];
            NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
            [cls addObject:clr];
        }
    }
    CGContextRelease(context);
    
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor = nil;
    NSUInteger MaxCount = 0;
    
    while ( (curColor = [enumerator nextObject]) != nil ) {
        NSUInteger tmpCount = [cls countForObject:curColor];
        
        if ( tmpCount < MaxCount ) continue;
        
        MaxCount = tmpCount;
        MaxColor = curColor;
        
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}

@end
