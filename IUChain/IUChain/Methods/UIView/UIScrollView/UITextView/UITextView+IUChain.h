//
//  UITextView+IUChain.h
//  IUChain
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+IUChain.h"

#define IUChainMethod_UITextView(returnClass) \
\
IUChainMethod_UIScrollView(returnClass) \
\
@property (nonatomic, readonly) returnClass *(^setDelegate)(id<UITextViewDelegate>); \
@property (nonatomic, readonly) returnClass *(^setText)(NSString *); \
@property (nonatomic, readonly) returnClass *(^setFont)(UIFont *); \
@property (nonatomic, readonly) returnClass *(^setTextColor)(UIColor *); \
@property (nonatomic, readonly) returnClass *(^setTextAlignment)(NSTextAlignment); \
@property (nonatomic, readonly) returnClass *(^setSelectedRange)(NSRange); \
@property (nonatomic, readonly) returnClass *(^setEditable)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setSelectable)(BOOL); \
@property (nonatomic, readonly) returnClass *(^setDataDetectorTypes)(UIDataDetectorTypes); \
@property (nonatomic, readonly) returnClass *(^setAttributedText)(NSAttributedString *); \
@property (nonatomic, readonly) returnClass *(^setTypingAttributes)(NSDictionary<NSString *, id> *); \
@property (nonatomic, readonly) returnClass *(^setInputView)(UIView *); \
@property (nonatomic, readonly) returnClass *(^setInputAccessoryView)(UIView *); \
@property (nonatomic, readonly) returnClass *(^setTextContainer)(NSTextContainer *); \
@property (nonatomic, readonly) returnClass *(^setTextContainerInset)(UIEdgeInsets); \
@property (nonatomic, readonly) returnClass *(^setLayoutManager)(NSLayoutManager *); \
@property (nonatomic, readonly) returnClass *(^setTextStorage)(NSTextStorage *); \
@property (nonatomic, readonly) returnClass *(^setLinkTextAttributes)(NSDictionary<NSString *, id> *); \
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

@interface UITextView (IUChain)

IUChainMethod_UITextView(UITextView)

@end
