//
//  UILabel+IUChain.h
//  IUChain
//
//  Created by admin on 2017/1/19.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (IUChain)

@property (nonatomic, readonly) UILabel *(^setText)(NSString *);
@property (nonatomic, readonly) UILabel *(^setFont)(UIFont *);
@property (nonatomic, readonly) UILabel *(^setTextColor)(UIColor *);
@property (nonatomic, readonly) UILabel *(^setTextAlignment)(NSTextAlignment);
@property (nonatomic, readonly) UILabel *(^setLineBreakMode)(NSLineBreakMode);
@property (nonatomic, readonly) UILabel *(^setNumberOfLines)(NSInteger);
@property (nonatomic, readonly) UILabel *(^setAttributedText)(NSAttributedString *);
@property (nonatomic, readonly) UILabel *(^setAdjustsFontSizeToFitWidth)(BOOL);

@property (nonatomic, readonly) UILabel *(^setHighlightedTextColor)(UIColor *);
@property (nonatomic, readonly) UILabel *(^setHighlighted)(BOOL);
@property (nonatomic, readonly) UILabel *(^setEnabled)(BOOL);
@property (nonatomic, readonly) UILabel *(^setShadowColor)(UIColor *);
@property (nonatomic, readonly) UILabel *(^setShadowOffset)(CGSize);
@property (nonatomic, readonly) UILabel *(^setBaselineAdjustment)(UIBaselineAdjustment);
@property (nonatomic, readonly) UILabel *(^setMinimumScaleFactor)(CGFloat);
@property (nonatomic, readonly) UILabel *(^setAllowsDefaultTighteningForTruncation)(BOOL);
@property (nonatomic, readonly) UILabel *(^setPreferredMaxLayoutWidth)(CGFloat);

@end

@interface UILabel (IUChainConformProtocolUIContentSizeCategoryAdjusting)

/* UIContentSizeCategoryAdjusting */
@property (nonatomic, readonly) UILabel *(^setAdjustsFontForContentSizeCategory)(BOOL);

@end

@interface UILabel (IUChainOverrideUIView)

/* UIView */
@property (nonatomic, readonly) UILabel *(^setFrame)(CGRect);
@property (nonatomic, readonly) UILabel *(^setBounds)(CGRect);
@property (nonatomic, readonly) UILabel *(^setCenter)(CGPoint);
@property (nonatomic, readonly) UILabel *(^setBackgroundColor)(UIColor *);
@property (nonatomic, readonly) UILabel *(^setAlpha)(UIColor *);
@property (nonatomic, readonly) UILabel *(^setHidden)(BOOL);
@property (nonatomic, readonly) UILabel *(^setUserInteractionEnabled)(BOOL);
@property (nonatomic, readonly) UILabel *(^setContentMode)(UIViewContentMode);
@property (nonatomic, readonly) UILabel *(^setAutoresizingMask)(UIViewAutoresizing);
@property (nonatomic, readonly) UILabel *(^setTransform)(CGAffineTransform);
@property (nonatomic, readonly) UILabel *(^setAutoresizesSubviews)(BOOL);
@property (nonatomic, readonly) UILabel *(^setLayoutMargins)(UIEdgeInsets);
@property (nonatomic, readonly) UILabel *(^setClipsToBounds)(BOOL);

@property (nonatomic, readonly) UILabel *(^setOpaque)(BOOL);
@property (nonatomic, readonly) UILabel *(^setMaskView)(UIView *);
@property (nonatomic, readonly) UILabel *(^setTintColor)(UIColor *);
@property (nonatomic, readonly) UILabel *(^setMultipleTouchEnabled)(BOOL);
@property (nonatomic, readonly) UILabel *(^setExclusiveTouch)(BOOL);
@property (nonatomic, readonly) UILabel *(^setContentScaleFactor)(CGFloat);
@property (nonatomic, readonly) UILabel *(^setContentStretch)(CGRect);
@property (nonatomic, readonly) UILabel *(^setTintAdjustmentMode)(UIViewTintAdjustmentMode);
@property (nonatomic, readonly) UILabel *(^setPreservesSuperviewLayoutMargins)(BOOL);
@property (nonatomic, readonly) UILabel *(^setClearsContextBeforeDrawing)(BOOL);
@property (nonatomic, readonly) UILabel *(^setMotionEffects)(NSArray<__kindof UIMotionEffect *> *);
@property (nonatomic, readonly) UILabel *(^setTranslatesAutoresizingMaskIntoConstraints)(BOOL);

@end
