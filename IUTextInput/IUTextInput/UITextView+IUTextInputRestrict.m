//
//  UITextView+IUTextInputRestrict.m
//  IUTextInput
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UITextView+IUTextInputRestrict.h"
#import <objc/runtime.h>
#import "NSObject+IUMethodSwizzle.h"

@interface IUTextInputRestrict ()

@property (nonatomic, assign) NSUInteger maxTextLength;
- (void)_textDidChange:(id<UITextInput>)textInput;

@end

@interface UITextView ()

@property (nonatomic, strong, readonly) UILabel *__placeholderLabel;

@end

#pragma mark - UITextView

static char TAG_TEXT_VIEW_TEXT_INPUT_RESTRICT;
static char TAG_TEXT_VIEW_MAX_TEXT_LENGTH;
static char TAG_TEXT_VIEW_PLACEHOLDER_LABEL;

@implementation UITextView (IUTextInputRestrict)

+ (void)load {
    [self swizzleInstanceSelector:@selector(layoutSubviews) toSelector:@selector(iuTextInputRestrict_UITextView_layoutSubviews)];
    [self swizzleInstanceSelector:@selector(setText:) toSelector:@selector(iuTextInputRestrict_UITextView_setText:)];
}

- (void)iuTextInputRestrict_UITextView_layoutSubviews {
    [self iuTextInputRestrict_UITextView_layoutSubviews];
    UILabel *placeholderLabel = objc_getAssociatedObject(self, &TAG_TEXT_VIEW_PLACEHOLDER_LABEL);
    if (placeholderLabel) {
        placeholderLabel.frame = CGRectMake(self.textContainerInset.left + self.textContainer.lineFragmentPadding, self.textContainerInset.top, self.bounds.size.width - self.textContainerInset.left - self.textContainerInset.right - self.textContainer.lineFragmentPadding * 2, 0);
        placeholderLabel.font = self.font ?: [UIFont systemFontOfSize:12];
        [placeholderLabel sizeToFit];
        placeholderLabel.hidden = self.text.length != 0;
    }
}

- (void)iuTextInputRestrict_UITextView_setText:(NSString *)text {
    [self iuTextInputRestrict_UITextView_setText:text];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
}

- (UILabel *)__placeholderLabel {
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
    self.__placeholderLabel.frame = CGRectMake(self.textContainerInset.left + self.textContainer.lineFragmentPadding, self.textContainerInset.top, self.bounds.size.width - self.textContainerInset.left - self.textContainerInset.right - self.textContainer.lineFragmentPadding * 2, 0);
    self.__placeholderLabel.text = placeholder;
    [self.__placeholderLabel sizeToFit];
    self.__placeholderLabel.hidden = self.text.length != 0;
}

- (NSString *)placeholder {
    return self.__placeholderLabel.text;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.__placeholderLabel.frame = CGRectMake(self.textContainerInset.left + self.textContainer.lineFragmentPadding, self.textContainerInset.top, self.bounds.size.width - self.textContainerInset.left - self.textContainerInset.right - self.textContainer.lineFragmentPadding * 2, 0);
    self.__placeholderLabel.attributedText = attributedPlaceholder;
    [self.__placeholderLabel sizeToFit];
    self.__placeholderLabel.hidden = self.text.length != 0;
}

- (NSAttributedString *)attributedPlaceholder {
    return self.__placeholderLabel.attributedText;
}

#pragma mark - Getter & Setter
- (void)setTextInputRestrict:(IUTextInputRestrict *)textInputRestrict {
    IUTextInputRestrict *textInputRestrictBefore = objc_getAssociatedObject(self, &TAG_TEXT_VIEW_TEXT_INPUT_RESTRICT);
    if (textInputRestrictBefore) {
        [[NSNotificationCenter defaultCenter] removeObserver:textInputRestrictBefore name:UITextViewTextDidChangeNotification object:self];
    }
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
    
    [[NSNotificationCenter defaultCenter] addObserver:textInputRestrict selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:self];
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
    objc_setAssociatedObject(self, &TAG_TEXT_VIEW_MAX_TEXT_LENGTH, @(maxTextLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.textInputRestrict.maxTextLength = maxTextLength;
    [self.textInputRestrict _textDidChange:self];
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

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-implementation"
@implementation UITextView (IUChainExtendIUTextInputRestrict)

@end
#pragma clang diagnostic pop
