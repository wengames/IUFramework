//
//  UITextField+IUChain.h
//  IUChain
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIControl+IUChain.h"

#define IUChainMethod_UITextField(returnClass) \
\
IUChainMethod_UIControl(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setText)(NSString *); \
@property (nonatomic, readonly) returnClass *(^setFont)(UIFont *); \
@property (nonatomic, readonly) returnClass *(^setTextColor)(UIColor *); \
@property (nonatomic, readonly) returnClass *(^setAttributedText)(NSAttributedString *); \
@property (nonatomic, readonly) returnClass *(^setTextAlignment)(NSTextAlignment); \
@property (nonatomic, readonly) returnClass *(^setDelegate)(id<UITextFieldDelegate>); \
@property (nonatomic, readonly) returnClass *(^setPlaceholder)(NSString *); \
@property (nonatomic, readonly) returnClass *(^setAttributedPlaceholder)(NSAttributedString *); \
@property (nonatomic, readonly) returnClass *(^setClearsOnBeginEditing)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setBorderStyle)(UITextBorderStyle); \
@property (nonatomic, readonly) returnClass *(^setAdjustsFontSizeToFitWidth)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setMinimumFontSize)(CGFloat); \
@property (nonatomic, readonly) returnClass *(^setBackground)(UIImage *); \
@property (nonatomic, readonly) returnClass *(^setDisabledBackground)(UIImage *); \
@property (nonatomic, readonly) returnClass *(^setAllowsEditingTextAttributes)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setTypingAttributes)(NSDictionary<NSString *, id> *); \
@property (nonatomic, readonly) returnClass *(^setClearButtonMode)(UITextFieldViewMode); \
@property (nonatomic, readonly) returnClass *(^setLeftView)(UIView *); \
@property (nonatomic, readonly) returnClass *(^setLeftViewMode)(UITextFieldViewMode); \
@property (nonatomic, readonly) returnClass *(^setRightView)(UIView *); \
@property (nonatomic, readonly) returnClass *(^setRightViewMode)(UITextFieldViewMode); \
@property (nonatomic, readonly) returnClass *(^setInputView)(UIView *); \
@property (nonatomic, readonly) returnClass *(^setInputAccessoryView)(UIView *); \
@property (nonatomic, readonly) returnClass *(^setClearsOnInsertion)(BOOL); \
\
@property (nonatomic, readonly) returnClass *(^setSelectedTextRange)(UITextRange *); \
@property (nonatomic, readonly) returnClass *(^setMarkedTextStyle)(NSDictionary *); \
@property (nonatomic, readonly) returnClass *(^setInputDelegate)(id <UITextInputDelegate>); \
@property (nonatomic, readonly) returnClass *(^setSelectionAffinity)(UITextStorageDirection); \
\
@property (nonatomic, readonly) returnClass *(^setKeyboardType)(UIKeyboardType); \
@property (nonatomic, readonly) returnClass *(^setKeyboardAppearance)(UIKeyboardAppearance); \
@property (nonatomic, readonly) returnClass *(^setReturnKeyType)(UIReturnKeyType); \
@property (nonatomic, readonly) returnClass *(^setEnablesReturnKeyAutomatically)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setSecureTextEntry)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setAutocapitalizationType)(UITextAutocapitalizationType); \
@property (nonatomic, readonly) returnClass *(^setAutocorrectionType)(UITextAutocorrectionType); \
@property (nonatomic, readonly) returnClass *(^setSpellCheckingType)(UITextSpellCheckingType); \
@property (nonatomic, readonly) returnClass *(^setTextContentType)(UITextContentType); \
\
@property (nonatomic, readonly) returnClass *(^setAdjustsFontForContentSizeCategory)(BOOL); \

@interface UITextField (IUChain)

IUChainMethod_UITextField(UITextField)

@end
