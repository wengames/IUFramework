//
//  UITextView+IUTextInputRestrict.m
//  IUTextInput
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UITextView+IUTextInputRestrict.h"
#import "objc/runtime.h"

@interface IUTextInputRestrict ()

@property (nonatomic, assign) NSUInteger maxTextLength;
- (void)_textDidChange:(id<UITextInput>)textInput;

@end

@interface _IUTextViewDelegateProxy : NSObject <UITextViewDelegate>

@property (nonatomic, strong) id(^textInputRestrict)();

@end

@interface UITextView ()

@property (nonatomic, strong, readonly) _IUTextViewDelegateProxy *proxy;
@property (nonatomic, strong, readonly) UILabel *placeholderLabel;

@end

@implementation _IUTextViewDelegateProxy

- (void)textViewDidChange:(NSNotification *)notification {
    UITextView *textView = notification.object;
    [self.textInputRestrict() _textDidChange:textView];
    textView.placeholderLabel.hidden = [textView.text length] != 0;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

#pragma mark - UITextView

static char TAG_TEXT_VIEW_TEXT_INPUT_RESTRICT;
static char TAG_TEXT_VIEW_MAX_TEXT_LENGTH;
static char TAG_TEXT_VIEW_DELEGATE_PROXY;
static char TAG_TEXT_VIEW_PLACEHOLDER_LABEL;

@implementation UITextView (IUTextInputRestrict)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(layoutSubviews)), class_getInstanceMethod(self, @selector(iu_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setText:)), class_getInstanceMethod(self, @selector(iu_setText:)));
}

- (void)iu_layoutSubviews {
    [self iu_layoutSubviews];
    UILabel *placeholderLabel = objc_getAssociatedObject(self, &TAG_TEXT_VIEW_PLACEHOLDER_LABEL);
    if (placeholderLabel) {
        placeholderLabel.frame = CGRectMake(self.textContainerInset.left + self.textContainer.lineFragmentPadding, self.textContainerInset.top, self.bounds.size.width - self.textContainerInset.left - self.textContainerInset.right - self.textContainer.lineFragmentPadding * 2, 0);
        placeholderLabel.font = self.font ?: [UIFont systemFontOfSize:12];
        [placeholderLabel sizeToFit];
        placeholderLabel.hidden = self.text.length != 0;
    }
}

- (void)iu_setText:(NSString *)text {
    [self iu_setText:text];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
}

- (_IUTextViewDelegateProxy *)proxy {
    _IUTextViewDelegateProxy *proxy = objc_getAssociatedObject(self, &TAG_TEXT_VIEW_DELEGATE_PROXY);
    if (proxy == nil) {
        __weak typeof(self) weakSelf = self;
        proxy = [[_IUTextViewDelegateProxy alloc] init];
        objc_setAssociatedObject(self, &TAG_TEXT_VIEW_DELEGATE_PROXY, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        proxy.textInputRestrict = ^{ return weakSelf.textInputRestrict; };
        [[NSNotificationCenter defaultCenter] addObserver:proxy selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return proxy;
}

- (UILabel *)placeholderLabel {
    UILabel *placeholderLabel = objc_getAssociatedObject(self, &TAG_TEXT_VIEW_PLACEHOLDER_LABEL);
    if (placeholderLabel == nil) {
        placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.font = self.font ?: [UIFont systemFontOfSize:12];
        placeholderLabel.textColor = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, &TAG_TEXT_VIEW_PLACEHOLDER_LABEL, placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:placeholderLabel];
    }
    return placeholderLabel;
}

- (void)setPlaceholder:(NSString *)placeholder {
    [self resetProxy];
    self.placeholderLabel.frame = CGRectMake(self.textContainerInset.left + self.textContainer.lineFragmentPadding, self.textContainerInset.top, self.bounds.size.width - self.textContainerInset.left - self.textContainerInset.right - self.textContainer.lineFragmentPadding * 2, 0);
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
    self.placeholderLabel.hidden = self.text.length != 0;
}

- (NSString *)placeholder {
    return self.placeholderLabel.text;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    [self resetProxy];
    self.placeholderLabel.frame = CGRectMake(self.textContainerInset.left + self.textContainer.lineFragmentPadding, self.textContainerInset.top, self.bounds.size.width - self.textContainerInset.left - self.textContainerInset.right - self.textContainer.lineFragmentPadding * 2, 0);
    self.placeholderLabel.attributedText = attributedPlaceholder;
    [self.placeholderLabel sizeToFit];
    self.placeholderLabel.hidden = self.text.length != 0;
}

- (NSAttributedString *)attributedPlaceholder {
    return self.placeholderLabel.attributedText;
}

#pragma mark - Getter & Setter
- (void)setTextInputRestrict:(IUTextInputRestrict *)textInputRestrict {
    [self resetProxy];
    objc_setAssociatedObject(self, &TAG_TEXT_VIEW_TEXT_INPUT_RESTRICT, textInputRestrict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([textInputRestrict isKindOfClass:[IUTextInputRestrictNumberOnly class]]) {
        self.keyboardType = UIKeyboardTypeNumberPad;
    } else if ([textInputRestrict isKindOfClass:[IUTextInputRestrictDecimalNegative class]]) {
        self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    } else if ([textInputRestrict isKindOfClass:[IUTextInputRestrictDecimalOnly class]]) {
        self.keyboardType = UIKeyboardTypeDecimalPad;
    } else if ([textInputRestrict isKindOfClass:[IUTextInputRestrictIdentityCard class]]) {
        self.keyboardType = UIKeyboardTypeNumberPad;
        [(IUTextInputRestrictIdentityCard *)textInputRestrict setInputView:self];
    }
    textInputRestrict.maxTextLength = self.maxTextLength;
}

- (IUTextInputRestrict *)textInputRestrict {
    IUTextInputRestrict *textInputRestrict = objc_getAssociatedObject(self, &TAG_TEXT_VIEW_TEXT_INPUT_RESTRICT);
    if (textInputRestrict == nil) {
        textInputRestrict = [[IUTextInputRestrict alloc] init];
        textInputRestrict.maxTextLength = self.maxTextLength;
        objc_setAssociatedObject(self, &TAG_TEXT_VIEW_TEXT_INPUT_RESTRICT, textInputRestrict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return textInputRestrict;
}

- (void)setMaxTextLength:(NSUInteger)maxTextLength {
    [self resetProxy];
    objc_setAssociatedObject(self, &TAG_TEXT_VIEW_MAX_TEXT_LENGTH, @(maxTextLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.textInputRestrict.maxTextLength = maxTextLength;
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
}

- (NSUInteger)maxTextLength {
    NSNumber *number = objc_getAssociatedObject(self, &TAG_TEXT_VIEW_MAX_TEXT_LENGTH);
    if (number) {
        return [number unsignedIntegerValue];
    }
    return NSUIntegerMax;
}

- (NSString *)phone {
    NSString *text = self.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]*$"];
    NSMutableString *string = [@"" mutableCopy];
    for (int i = 0; i < [text length]; i++) {
        NSString *charater = [text substringWithRange:NSMakeRange(i, 1)];
        if ([predicate evaluateWithObject:charater]) {
            [string appendString:charater];
        }
    }
    return [string copy];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-getter-return-value"
- (void)resetProxy {
    self.proxy;
}
#pragma clang diagnostic pop

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-implementation"
@implementation UITextView (IUChainExtendIUTextInputRestrict)

@end
#pragma clang diagnostic pop
