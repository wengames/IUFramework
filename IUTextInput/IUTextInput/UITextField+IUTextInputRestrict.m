//
//  UITextField+IUTextInputRestrict.m
//  IUTextInput
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UITextField+IUTextInputRestrict.h"
#import "objc/runtime.h"

static char TAG_TEXT_FIELD_TEXT_INPUT_RESTRICT;
static char TAG_TEXT_FIELD_MAX_TEXT_LENGTH;

@interface IUTextInputRestrict ()

@property (nonatomic, assign) NSUInteger maxTextLength;
- (void)_textDidChange:(id<UITextInput>)textInput;

@end

@implementation UITextField (IUTextInputRestrict)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setText:)), class_getInstanceMethod(self, @selector(iu_setText:)));
}

- (void)iu_setText:(NSString *)text {
    [self iu_setText:text];
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Getter & Setter
- (void)setTextInputRestrict:(IUTextInputRestrict *)textInputRestrict {
    IUTextInputRestrict *textInputRestrictBefore = objc_getAssociatedObject(self, &TAG_TEXT_FIELD_TEXT_INPUT_RESTRICT);
    if (textInputRestrictBefore) {
        [self removeTarget:textInputRestrictBefore action:@selector(_textDidChange:) forControlEvents:UIControlEventAllEditingEvents];
    }
    objc_setAssociatedObject(self, &TAG_TEXT_FIELD_TEXT_INPUT_RESTRICT, textInputRestrict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([textInputRestrict isKindOfClass:[IUTextInputRestrictNumberOnly class]]) {
        self.keyboardType = UIKeyboardTypeNumberPad;
    } else if ([textInputRestrict isKindOfClass:[IUTextInputRestrictDecimalNegative class]]) {
        self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    } else if ([textInputRestrict isKindOfClass:[IUTextInputRestrictDecimalOnly class]]) {
        self.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
    textInputRestrict.maxTextLength = self.maxTextLength;
    
    [self addTarget:textInputRestrict action:@selector(_textDidChange:) forControlEvents:UIControlEventAllEditingEvents];
}

- (IUTextInputRestrict *)textInputRestrict {
    IUTextInputRestrict *textInputRestrict = objc_getAssociatedObject(self, &TAG_TEXT_FIELD_TEXT_INPUT_RESTRICT);
    if (textInputRestrict == nil) {
        textInputRestrict = [[IUTextInputRestrict alloc] init];
        textInputRestrict.maxTextLength = self.maxTextLength;
        objc_setAssociatedObject(self, &TAG_TEXT_FIELD_TEXT_INPUT_RESTRICT, textInputRestrict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addTarget:textInputRestrict action:@selector(_textDidChange:) forControlEvents:UIControlEventAllEditingEvents];
    }
    return textInputRestrict;
}

- (void)setMaxTextLength:(NSUInteger)maxTextLength {
    objc_setAssociatedObject(self, &TAG_TEXT_FIELD_MAX_TEXT_LENGTH, @(maxTextLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.textInputRestrict.maxTextLength = maxTextLength;
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (NSUInteger)maxTextLength {
    NSNumber *number = objc_getAssociatedObject(self, &TAG_TEXT_FIELD_MAX_TEXT_LENGTH);
    if (number) {
        return [number unsignedIntegerValue];
    }
    return NSUIntegerMax;
}

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-implementation"
@implementation UITextField (IUChainExtendIUTextInputRestrict)

@end
#pragma clang diagnostic pop
