//
//  UIView+IUChain.h
//  IUChain
//
//  Created by admin on 2017/1/19.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IUChain)

@property (nonatomic, readonly) UIView *(^setFrame)(CGRect);
@property (nonatomic, readonly) UIView *(^setBounds)(CGRect);
@property (nonatomic, readonly) UIView *(^setCenter)(CGPoint);
@property (nonatomic, readonly) UIView *(^setBackgroundColor)(UIColor *);
@property (nonatomic, readonly) UIView *(^setAlpha)(UIColor *);
@property (nonatomic, readonly) UIView *(^setHidden)(BOOL);
@property (nonatomic, readonly) UIView *(^setUserInteractionEnabled)(BOOL);
@property (nonatomic, readonly) UIView *(^setContentMode)(UIViewContentMode);
@property (nonatomic, readonly) UIView *(^setAutoresizingMask)(UIViewAutoresizing);
@property (nonatomic, readonly) UIView *(^setTransform)(CGAffineTransform);
@property (nonatomic, readonly) UIView *(^setAutoresizesSubviews)(BOOL);
@property (nonatomic, readonly) UIView *(^setLayoutMargins)(UIEdgeInsets);
@property (nonatomic, readonly) UIView *(^setClipsToBounds)(BOOL);

@property (nonatomic, readonly) UIView *(^setOpaque)(BOOL);
@property (nonatomic, readonly) UIView *(^setMaskView)(UIView *);
@property (nonatomic, readonly) UIView *(^setTintColor)(UIColor *);
@property (nonatomic, readonly) UIView *(^setMultipleTouchEnabled)(BOOL);
@property (nonatomic, readonly) UIView *(^setExclusiveTouch)(BOOL);
@property (nonatomic, readonly) UIView *(^setContentScaleFactor)(CGFloat);
@property (nonatomic, readonly) UIView *(^setContentStretch)(CGRect);
@property (nonatomic, readonly) UIView *(^setTintAdjustmentMode)(UIViewTintAdjustmentMode);
@property (nonatomic, readonly) UIView *(^setPreservesSuperviewLayoutMargins)(BOOL);
@property (nonatomic, readonly) UIView *(^setClearsContextBeforeDrawing)(BOOL);
@property (nonatomic, readonly) UIView *(^setMotionEffects)(NSArray<__kindof UIMotionEffect *> *);
@property (nonatomic, readonly) UIView *(^setTranslatesAutoresizingMaskIntoConstraints)(BOOL);

@end
